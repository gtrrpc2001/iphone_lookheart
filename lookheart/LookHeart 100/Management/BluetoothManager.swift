import Foundation
import UIKit
import LookheartPackage
import DGCharts
import CoreBluetooth

protocol BluetoothManagerDelegate: AnyObject {
    func didUpdateGraphData(_ data: [Double])
    func didUpdateUI()
}

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
        
    static let shared = BluetoothManager()
    
    weak var delegate: BluetoothManagerDelegate?
    
    // ----------------- UUID -----------------
    private let ServiceCBUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    private let ReceiveCBUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
    private let SendCBUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    // ----------------- UUID End-----------------
    
    // ----------------- Index -----------------
    private let BatteryIdx = 1
    private let BpmIdx = 2
    private let TempIdx = 3
    private let StepIdx = 4
    private let HrvIdx = 5
    private let EcgStartIdx = 6
    private let EcgEndIdx = 19
    // ----------------- Index End-----------------
    
    /*  ----------------- ARR, BODY STATE -----------------
    -> 비정상맥박, 전극 떨어짐, 근전도 구분 상수 */
    private let StepOffset = 14
    private let NotificationThreshold = 10
    // ----------------- ARR, BODY STATE End-----------------
    
    // ----------------- DateTime -----------------
    private let TEN_SECONDS = 9 // 9 : 10.08 ~ 10.20sec
    
    private var currentDate = String()
    private var currentTime = String()
    private var currentHour = String()
    private var splitDate = [String()]
    
    private var prevDate = String()
    private var prevHour = String()
    // ----------------- DateTime End -----------------
    
    /*  ----------------- ECG -----------------
    -> ECG 관련 변수 */
    private var ecgPacket:[Int] = [] // 펌웨어에서 받아오는 ECG (140)
    private var ecgData: [Double] = []  // ECG DATA ARRAY
    private var chartData: [Double] = []  // 그래프에 보여주는 변환된 ECG DATA
    private var ecgArrayCnt = 0    // 0 ~ 499 (500)
    private var ecgCnt = 0    // 0 ~ 13 (14)
    private var tenSecondCnt = 0    // 10.08 ~ 10.20sec
    // ----------------- ARR, BODY STATE End-----------------
    
    /*  ----------------- BLE -----------------
    -> BLUETOOTH LOW ENERGY 변수                */
    private var centralManager: CBCentralManager!
    private var heartRatePeripheral: CBPeripheral!
    private var txCharacteristic: CBCharacteristic!
    private var rxCharacteristic: CBCharacteristic!
    // ----------------- BLE End-----------------
    
    /*  ----------------- FLAG ----------------- */
    public var isUserInitiatedDisconnect = false
    // ----------------- FLAG End-----------------
    
    
    // data Manager
    private var healthDataManager = HealthDataManager.shared
    private var hourlyDataManager = HourlyDataManager.shared
    private var tenSecondDataManager = TenSecondDataManager.shared
    private var notificationManager = NotificationManager.shared
    
    private var age = 50.0
    private var weight = 70.0
    
    // MARK: -
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    public func initBluetoothManager() {
        
        age = Double(propProfil.age) ?? 50.0
        weight = Double(propProfil.weight) ?? 70.0
        
        updateDateTime()
        
        prevDate = defaults.string(forKey: "\(propEmail)\(PrevDateKey)") ?? currentDate
        prevHour = defaults.string(forKey: "\(propEmail)\(PrevHourKey)") ?? currentHour
        
        savePrevDateTime()
        
        ecgPacket.removeAll()
        ecgData.removeAll()
        chartData.removeAll()
        
        ecgArrayCnt = 0
        ecgCnt = 0
        tenSecondCnt = 0
    }
    
    // MARK: - CBCentralManagerDelegate
    /*  ----------------- CBCentralManagerDelegate -----------------
     -> Bluetooth 상태 및 연결 */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            
            centralManager.scanForPeripherals(withServices: [ServiceCBUUID])
            
        @unknown default:
            fatalError()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.name == "ECG" {
            heartRatePeripheral = peripheral
            heartRatePeripheral.delegate = self
            centralManager.stopScan()
            centralManager.connect(heartRatePeripheral)
            propProfil.bleIdentifier = peripheral.name ?? "ECG"
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        NetworkManager.shared.sendBleLog(action: .BleConnect)   // Log
        
        connectionFlag = true
        heartRatePeripheral.discoverServices([ServiceCBUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected!")
        
        if propProfil.isLogin {
            NetworkManager.shared.sendBleLog(action: .BleDisconnect)    // Log
        }
        
        if !isUserInitiatedDisconnect {
            heartRatePeripheral = peripheral
            heartRatePeripheral.delegate = self
            centralManager.retrieveConnectedPeripherals(withServices: [ServiceCBUUID])
            centralManager.connect(heartRatePeripheral)
        }
        
        connectionFlag = false
    }
    
    public func startScanning() {
        // BLE Scanning
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [ServiceCBUUID])
        }
    }
    
    public func disconnectBLEDevice() {
        // BLE 연결 해제
        if let peripheral = heartRatePeripheral {
            isUserInitiatedDisconnect = true
            centralManager.cancelPeripheralConnection(peripheral)
            centralManager.stopScan()
        }
    }
    
    
    // MARK: - CBPeripheralDelegate
    /*  ----------------- CBPeripheralDelegate -----------------
     -> Bluetooth 데이터  */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("service : \(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("characteristic : \(characteristic)")
            
            if characteristic.uuid.isEqual(ReceiveCBUUID)  {
                
                rxCharacteristic = characteristic
                
                peripheral.setNotifyValue(true, for: rxCharacteristic!)
                peripheral.readValue(for: characteristic)
                
                print("RX Characteristic: \(rxCharacteristic.uuid)")
            }
            
            if characteristic.uuid.isEqual(SendCBUUID){
                
                txCharacteristic = characteristic
                
                print("TX Characteristic: \(txCharacteristic.uuid)")
            }
        }
    }
    
    // MARK: -
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        switch characteristic.uuid {
        case ReceiveCBUUID:
            guard let characteristicData = characteristic.value else { break }
            
            let byteArray = [UInt8](characteristicData)
            
            let byteCnt = byteArray.count >= 21
            let firstBitValue = byteArray[0] & 0xFF == 1
            
            if byteCnt && firstBitValue {
                
                // battery[1], bpm[2], temp[3], hrv[5]
                healthDataReceived(data: [byteArray[BatteryIdx], byteArray[BpmIdx], byteArray[TempIdx], byteArray[HrvIdx]])
                
                // step[4]
                stepReceived(step: Int(byteArray[StepIdx]))
                
                // ecgArray[6 ~ 19]
                ecgArray(from: Array(byteArray[EcgStartIdx...EcgEndIdx]))
                
            }
            
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    private func writeOutGoingValue(data: String){
        
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
                
        if let heartRatePeripheral = heartRatePeripheral {
            if let txCharacteristic = txCharacteristic {
                
                heartRatePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    private func sendHeight(_ height: Int){
        
        // 민감도 설정
        var type:String
        switch height {
        case 165...170: type = "q\n"
        case 171...175: type = "r\n"
        case 176...180: type = "s\n"
        case 181...Int.max: type = "t\n"
        default:    type = "r\n"
        }
        
        writeOutGoingValue(data: type)
        
    }
    
    // MARK: - Received
    private func healthDataReceived(data : [UInt8]) {
        
        let battery = Int(data[0])
        let bpm = Int(data[1])
        let temperature = Double(data[2])
        let hrv = Int(data[3])
        
        // Update Battery ProgressBar
        BatteryProgress.shared.setProgress(Float(battery) / 100.0, battery, animated: true)
        
        // Update Bpm
        if healthDataManager.bpm != bpm && bpm > 3 {
            healthDataManager.bpm = bpm
            healthDataManager.updateBodyState(currentHour, bpm)
        }
        
        // Update Temp
        healthDataManager.temp = ((temperature + 186) / 10.0) + 0.5
        
        // Update HRV
        healthDataManager.hrv = hrv * 10
             
        // Update UI
        delegate?.didUpdateUI()
        
    }
    
    
    private func stepReceived(step: Int) {
        guard connectionFlag else { return }
        
        let stepCal = max(0, step - StepOffset)
        
        if stepCal >= NotificationThreshold {
            handleEvent(for: stepCal / 10)
        }
        
        let addStep = stepCal % 10
        
        healthDataManager.step += addStep
        healthDataManager.currentStep += addStep
        
        hourlyDataManager.step += addStep
        tenSecondDataManager.step += addStep

    }
    
    
    private func handleEvent(for eventType: Int) {
        
        var arrType = NotificationManager.NotiType.null
        
        switch eventType {
        case EMERGENCY_TAG:
            notificationManager.showAlert(type: .emergency)
        case NONCONTACT_TAG:
            notificationManager.showNotification(noti: .noncontact)
        case MYO_TAG:
            notificationManager.showNotification(noti: .myo)
        case ARR_TAG:
            arrType = .arr
        case FAST_ARR_TAG:
            if !HealthDataManager.shared.getExerciseFlag() {
                arrType = .fast
            }
        case SLOW_ARR_TAG:
            arrType = .slow
        case HEAVY_ARR_TAG:
            arrType = .irregular
        default:
            break
        }
        
        if arrType != .null && ecgData.count == 500 {
            sendArrData(type: arrType)
        }
    }
    
    // MARK: - Ecg
    private func ecgArray(from ecgData: [UInt8]) {
        
        // ecgData[14]
        for ecg in ecgData {
            
            let doubleEcg = Double(Int(ecg) * 4)
            
            // ECG[140]
            manageEcgData(with: doubleEcg)
            
            // ECG Array[500]
            manageEcgDataArray(with: doubleEcg)
            
        }
        
        // Update Chart
        delegate?.didUpdateGraphData(chartData)
        
    }
    
    private func manageEcgData(with doubleEcg: Double) {
        
        let intEcg = Int(doubleEcg)
        
        if ecgCnt < ECG_DATA_MAX {
            
            ecgPacket.append(intEcg)
            ecgCnt += 1
            
        } else {
            
            timeTrigger()
            
            sendEcgData()
            
            HealthDataManager.shared.exerciseTimer() // exercise
            
            ecgPacket.removeAll()
            ecgCnt = 0
        }
    }
    
    private func manageEcgDataArray(with doubleEcg: Double) {
        
        // conversionFlag ? PEAK : ECG
        let ecg = conversionFlag ? EcgDataConversion.shared.conversionEcgData(doubleEcg) : doubleEcg
        
        if ecgArrayCnt < ECG_MAX_ARRAY {
            
            ecgData.append(doubleEcg)
            chartData.append(ecg)
            ecgArrayCnt += 1
            
        } else {
            
            ecgData.removeFirst()
            ecgData.append(doubleEcg)
            
            chartData.removeFirst()
            chartData.append(ecg)
            
        }
        
    }
    
    // MARK: - DateTime
    private func updateDateTime() {
        currentDate = MyDateTime.shared.getCurrentDateTime(.DATE)
        currentTime = MyDateTime.shared.getCurrentDateTime(.TIME)
        currentHour = MyDateTime.shared.getSplitDateTime(.TIME)[0]
        splitDate = MyDateTime.shared.getSplitDateTime(.DATE)
    }
    
    public func savePrevDateTime() {
        defaults.set(prevDate, forKey: "\(propEmail)\(PrevDateKey)")
        defaults.set(prevHour, forKey: "\(propEmail)\(PrevHourKey)")
    }
    
    // MARK: - Trigger
    private func timeTrigger() {
        
        tenSecondCnt += 1
        
        updateDateTime()
        
        healthDataManager.calculateHealthData()
        
        if prevDate != currentDate {
            
            handleDateChange()
            
        } else if prevHour != currentHour {
            
            handleHourChange()
            
        } else {
            
            hourlyTrigger()
            
        }
        
        tenSecondTrigger()
        
    }
    
    private func handleDateChange() {
        
        print("(DATE) prevDate(\(prevDate)) != currentDate(\(currentDate))")
                
        prevDate = currentDate
        prevHour = currentHour
        
        savePrevDateTime()
        
        healthDataManager.resetHealthData()
        
        hourlyDataManager.resetHourlyData()
        
        notificationManager.resetArrAlert(type: .total)
    }
    
    private func handleHourChange() {
        
        print("(HOUR) prevHour(\(prevHour)) != currentHour(\(currentHour))")
                
        sendHourlyData(hour: prevHour)
        
        prevHour = currentHour
        
        savePrevDateTime()
        
        hourlyDataManager.updateHouryData()
        
    }
    
    private func tenSecondTrigger() {
  
        if tenSecondCnt == TEN_SECONDS {
            
            sendTenSecondData()
            
            tenSecondCnt = 0
        }
        
    }
    
    private func hourlyTrigger() {
        
        if tenSecondCnt == TEN_SECONDS {
            
            sendHourlyData(hour: currentHour)
            
        }
        
    }
    

    // MARK: - Send Data
    private func sendEcgData() {
        
        let currentDateTime = "\(currentDate) \(currentTime)"
        
        NetworkManager.shared.sendByteEcgDataToServer(ecgData: ecgPacket, bpm: healthDataManager.bpm, writeDateTime: currentDateTime)
        
    }
        
    
    public func sendTenSecondData() {
        
        let currentDateTime = "\(currentDate) \(currentTime)"
        
        tenSecondDataManager.sendTenSecondData(currentDateTime)
        
    }
    
    
    public func sendHourlyData(hour: String) {
        
        let year = splitDate[0]
        let month = splitDate[1]
        let day = splitDate[2]
        
        hourlyDataManager.sendHourlyData(year, month, day, hour)

    }
    
    
    private func sendArrData(type: NotificationManager.NotiType) {
        
        let currentDateTime = "\(currentDate) \(currentTime)"
        let bodyState = healthDataManager.bodyState
        let arrArray = ecgData.map { String($0) }
        let arrEcgData = arrArray.joined(separator: ",")
        
        let arrData = "\(currentTime),\(propTimeZone),\(bodyState),\(type.rawValue),\(arrEcgData)"
        
        let arrParams: [String: Any] = [
            "writetime": currentDateTime,
            "ecgPacket": arrData
        ]
        
        NetworkManager.shared.sendArrDataToServer(arrData: arrParams) { [self] result in
            
            switch result {
            case .success(let isSuccess):
                
                if isSuccess {
                    
                    healthDataManager.arrCnt += 1
                    hourlyDataManager.arrCnt += 1
                    tenSecondDataManager.arrCnt += 1
                    notificationManager.showNotification(noti: type)
                    
                    NotificationManager.shared.showAlert(type: .total, arrCnt: healthDataManager.arrCnt)
                    NotificationManager.shared.showAlert(type: .hourly, arrCnt: hourlyDataManager.arrCnt)
                }
                
            case .failure(let error):
                print("sendArrData : \(error)")
            }
        }
    }
}
