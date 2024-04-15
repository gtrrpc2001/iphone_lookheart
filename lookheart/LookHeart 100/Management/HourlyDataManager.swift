import Foundation
import LookheartPackage

public class HourlyDataManager {
    
    private let HourlyArrCnt = "HourlyArrCnt"
    private let HourlyStep = "HourlyStep"
    private let HourlyDistance = "HourlyDistance"
    private let HourlyDistanceM = "HourlyDistanceM"
    private let HourlyCalorie = "HourlyCalorie"
    private let HourlyActivityCalorie = "HourlyActivityCalorie"
    
    static let shared = HourlyDataManager()
    
    public struct HourlyData {
        
        var arrCnt: Int = 0
        var step: Int = 0
        
        var distance: Double = 0
        var distanceM: Double = 0
        
        var calorie: Double = 0
        var activityCalorie: Double = 0
        
        mutating func reset() {
            self = HourlyData()
        }
    }
    
    private var hourlyData = HourlyData()
    
    // MARK: -
    init() {}
    
    public func initHourlyDataManager() {
        
        resetHourlyData()
        
        let prevDate = defaults.string(forKey: "\(propEmail)\(PrevDateKey)") ?? propCurrentDate
        let prevHour = defaults.string(forKey: "\(propEmail)\(PrevHourKey)") ?? propCurrentHour
        
        if prevDate == propCurrentDate {
            
            initHourlyData()
            
            if prevHour != propCurrentHour {

                updateHouryData()
                setUserDefaultData()
                
                defaults.set(propCurrentHour, forKey: "\(propEmail)\(PrevHourKey)")
                NotificationManager.shared.resetArrAlert(type: .hourly)
            }
        } else {
            
            resetDefaultHourlyData()
            
            defaults.set(propCurrentHour, forKey: "\(propEmail)\(PrevHourKey)")
            
            NotificationManager.shared.resetArrAlert(type: .hourly)
        }
    }
    
    public func resetHourlyData() {
        hourlyData.reset()
    }
    
    public func resetDefaultHourlyData() {
        hourlyData.reset()
        setUserDefaultData()
    }
    
    
    public func updateHouryData() {
        
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
    
    
    
    // MARK: - UserDefaultData
    public func initHourlyData() {
        arrCnt = defaults.integer(forKey: "\(propEmail)\(HourlyArrCnt)")
        step = defaults.integer(forKey: "\(propEmail)\(HourlyStep)")
        distance = defaults.double(forKey: "\(propEmail)\(HourlyDistance)")
        distanceM = defaults.double(forKey: "\(propEmail)\(HourlyDistanceM)")
        calorie = defaults.double(forKey: "\(propEmail)\(HourlyCalorie)")
        activityCalorie = defaults.double(forKey: "\(propEmail)\(HourlyActivityCalorie)")
    
    }
    
    public func setUserDefaultData() {
        defaults.set(arrCnt, forKey: "\(propEmail)\(HourlyArrCnt)")
        defaults.set(step, forKey: "\(propEmail)\(HourlyStep)")
        defaults.set(distance, forKey: "\(propEmail)\(HourlyDistance)")
        defaults.set(distanceM, forKey: "\(propEmail)\(HourlyDistanceM)")
        defaults.set(calorie, forKey: "\(propEmail)\(HourlyCalorie)")
        defaults.set(activityCalorie, forKey: "\(propEmail)\(HourlyActivityCalorie)")
    }
    
    
    
    // MARK: - Send Data
    public func sendHourlyData(_ year: String, _ month: String, _ day: String, _ hour: String) {
        
        let intData = calcInt()
        let intCalorie = intData.0
        let intActivityCalorie = intData.1
        let intDistanceM = intData.3
        
        let hourlyDataParams: [String: Any] = [
            "datayear": year,
            "datamonth": month,
            "dataday": day,
            "datahour": hour,
            "ecgtimezone": propTimeZone,
            "step": step,
            "distanceKM": intDistanceM,
            "cal": intCalorie,
            "calexe": intActivityCalorie,
            "arrcnt": arrCnt
        ]
        
        Task { await PostData.shared.sendHourlyData(hourlyData: hourlyDataParams) }
    }
        
    
    // MARK: - Get, Set
    public func getHourlyData() -> HourlyData {
        return hourlyData
    }
    
    public var arrCnt: Int {
        get {
            return hourlyData.arrCnt
        }
        set {
            hourlyData.arrCnt = newValue
        }
    }
    
    public var step: Int {
        get {
            return hourlyData.step
        }
        set {
            hourlyData.step = newValue
        }
    }
    
    public var distance: Double {
        get {
            return hourlyData.distance
        }
        set {
            hourlyData.distance = newValue
        }
    }
    
    public var distanceM: Double {
        get {
            return hourlyData.distanceM
        }
        set {
            hourlyData.distanceM = newValue
        }
    }
    
    public var calorie: Double {
        get {
            return hourlyData.calorie
        }
        set {
            hourlyData.calorie = newValue
        }
    }
    
    public var activityCalorie: Double {
        get {
            return hourlyData.activityCalorie
        }
        set {
            hourlyData.activityCalorie = newValue
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
