import Foundation
import LookheartPackage

public class TenSecondDataManager {
    
    static let shared = TenSecondDataManager()
    
    public struct TenSecondData {
        var arrCnt: Int = 0
        var step: Int = 0
        
        var distance: Double = 0
        var distanceM: Double = 0
        
        var calorie: Double = 0
        var activityCalorie: Double = 0
        
        mutating func reset() {
            self = TenSecondData()
        }
    }
    
    // BPM, HRV
    private var tempCnt = 0.0
    private var tempSum = 0.0
    private var tempAvg = 0.0
    
    private var hrvCnt = 0
    private var hrvSum = 0
    private var hrvAvg = 0
    
    private var bpmCnt = 0
    private var bpmSum = 0
    private var bpmAvg = 0
    
    private var tenSecondData = TenSecondData()
        
    // MARK: -
    init() {}
    
    public func resetTenSecondData() {
        
        tenSecondData.reset()
        
        bpmCnt = 0
        bpmSum = 0
        
        hrvCnt = 0
        hrvSum = 0
        
        tempCnt = 0
        tempSum = 0
        
    }
    
    public func updateTenSecondData() {
        
        let modData = calcMod()
        let modCalorie = modData.0
        let modActivityCalorie = modData.1
        let modDistance = modData.2
        let modDistanceM = modData.3
        
        arrCnt = 0
        step = 0
        calorie = modCalorie
        activityCalorie = modActivityCalorie
        distance = modDistance
        distanceM = modDistanceM
        
        bpmCnt = 0
        bpmSum = 0
        
        hrvCnt = 0
        hrvSum = 0
        
        tempCnt = 0
        tempSum = 0
    }
    
    
    private func calcInt() -> (Int, Int, Int, Int) {
        let intCalorie = Int(calorie)
        let intActivityCalorie = Int(activityCalorie)
        let intDistance = Int(distance)
        let intDistanceM = Int(distanceM)
        
        return (intCalorie, intActivityCalorie, intDistance, intDistanceM)
    }
    
    
    private func calcMod() -> (Double, Double, Double, Double) {
        let intData = calcInt()
        let intCalorie = intData.0
        let intActivityCalorie = intData.1
        let intDistance = intData.2
        let intDistanceM = intData.3
        
        let modCalorie = calorie - Double(intCalorie)
        let modActivityCalorie = activityCalorie - Double(intActivityCalorie)
        let modDistance = distance - Double(intDistance)
        let modDistanceM = distanceM - Double(intDistanceM)
        
        return (modCalorie, modActivityCalorie, modDistance, modDistanceM)
    }
    
    
    // MARK: - Send Data
    public func sendTenSecondData(_ currentDateTime: String) {
        let intData = calcInt()
        let intCalorie = intData.0
        let intActivityCalorie = intData.1
        let intDistanceM = intData.3
        
        let dataParams: [String: Any] = [
            "bpm": bpm,
            "hrv": hrv,
            "cal": intCalorie,
            "calexe": intActivityCalorie,
            "step": step,
            "distanceKM": intDistanceM,
            "arrcnt": arrCnt,
            "temp": temp,
            "battery": BatteryProgress.shared.getBattery()
        ]
        
        Task {
            await PostData.shared.sendTenSecondData(
                tenSecondData: dataParams,
                writeDateTime: currentDateTime
            )
        }
        
        updateTenSecondData()
    }
    
    // MARK: - Get, Set
    public var bpm: Int {
        get {
            return bpmAvg
        }
        set {
            bpmCnt += 1
            bpmSum += newValue
            bpmAvg = bpmSum / bpmCnt
        }
    }

    public var hrv: Int {
        get {
            return hrvAvg
        }
        set {
            hrvCnt += 1
            hrvSum += newValue
            hrvAvg = hrvSum / hrvCnt
        }
    }
    
    
    public var temp: Double {
        get {
            return tempAvg
        }
        set {
            tempCnt += 1
            tempSum += newValue
            tempAvg = tempSum / tempCnt
        }
    }
    
    
    
    public var arrCnt: Int {
        get {
            return tenSecondData.arrCnt
        }
        set {
            tenSecondData.arrCnt = newValue
        }
    }
    
    public var step: Int {
        get {
            return tenSecondData.step
        }
        set {
            tenSecondData.step = newValue
        }
    }
    
    public var distance: Double {
        get {
            return tenSecondData.distance
        }
        set {
            tenSecondData.distance = newValue
        }
    }
    
    public var distanceM: Double {
        get {
            return tenSecondData.distanceM
        }
        set {
            tenSecondData.distanceM = newValue
        }
    }
    
    public var calorie: Double {
        get {
            return tenSecondData.calorie
        }
        set {
            tenSecondData.calorie = newValue
        }
    }
    
    public var activityCalorie: Double {
        get {
            return tenSecondData.activityCalorie
        }
        set {
            tenSecondData.activityCalorie = newValue
        }
    }
    

    // MARK: - Calculate Calorie & Distance
    public func calculateCalorie(_ calorieCalculaton: Double, _ activityFlag: Bool) {
        
        // Calorie
        let calcCalorie = calorie + calorieCalculaton
        calorie = (calcCalorie * 1000).rounded() / 1000
        
        // Activity Calorie
        if activityFlag {
            let calcActivityCalorie = activityCalorie + calorieCalculaton
            activityCalorie = (calcActivityCalorie * 1000).rounded() / 1000
        }
    }
    
    public func calculateDistance(_ step: Double, _ additionalSize: Double, _ avgSize: Double) {
        // Distance
        let calcDistance = distance + ((avgSize + additionalSize) * step)
        distance = (calcDistance * 1000).rounded() / 1000.0
        distanceM = distance / 100
    }
    
}
