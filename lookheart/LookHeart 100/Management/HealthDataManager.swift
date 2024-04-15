import Foundation
import LookheartPackage


public class HealthDataManager {
    
    private let ArrCntKey = "arrCnt"
    private let StepKey = "step"
    private let DistanceKey = "distance"
    private let CalorieKey = "calorie"
    private let ActivityCalorieKey = "activityCalorie"
        
    static let shared = HealthDataManager()
    
    public struct HealthData {
        
        var bodyStatus: String = ""
        
        var bpm: Int = 0
        var minBpm: Int = 70
        var maxBpm: Int = 0
        var avgBpm: Int = 0
        
        var arrCnt: Int = 0
        var hrv: Int = 0
        var temp: Double = 0.0
        
        var step: Int = 0
        var nowStep: Int = 0
        
        var distance: Double = 0
        var calorie: Double = 0.0
        var activityCalorie: Double = 0.0
        
        mutating func reset() {
            self = HealthData()
        }
    }
    
    private let CalMinuteUnit = 1.0 / 60.0  // 분당 칼로리 계산( 0.0166667 )
    private let CalcCalUnit = 4.184
    
    private var genderCalcAge = 0.2017
    private var genderCalcWeight = 0.1988
    private var genderCalcBpm = 0.6309
    private var genderCal = 55.0969
    
    private var avgSize = 10.0
    
    private var avgBpmSum = 0
    private var avgBpmCnt = 0
    
    // Exercise
    private var exerciseFlag = false
    private var exerciseCnt = 0
    private var exerciseCal = 0.0
    private var exerciseStep = 0
    private var exerciseDistance = 0.0
    
    // UserData
    private var healthData = HealthData()
    private var hourlyData = HourlyDataManager.shared
    private var tenSecondData = TenSecondDataManager.shared
    
    private var age: Double
    private var weight: Double

    // MARK: -
    init() {
        age = Double(UserProfileManager.shared.age) ?? 50.0
        weight = Double(UserProfileManager.shared.weight) ?? 70.0
    }
    
    public func initHealthDataManager() {
        
        resetHealthData()
        
        age = Double(UserProfileManager.shared.age) ?? 50.0
        weight = Double(UserProfileManager.shared.weight) ?? 70.0
        
        let prevDate = defaults.string(forKey: "\(propEmail)\(PrevDateKey)") ?? propCurrentDate
        
        if prevDate == propCurrentDate {
            
            initHealthData()
            
        } else {
            
            resetDefaultHealthData()
            
            defaults.set(propCurrentDate, forKey: "\(propEmail)\(PrevDateKey)")
            
            NotificationManager.shared.resetArrAlert(type: .total)
                        
        }
    }

    public func resetHealthData() {
        healthData.reset()
    }
    
    public func resetDefaultHealthData() {
        healthData.reset()
        setUserDefaultData()
    }
    
    public func setGender(_ gender: Bool) {
        // set Gender Calc Data
        genderCalcAge = gender ? 0.2017 : 0.074
        genderCalcWeight = gender ? 0.1988 : 0.1263
        genderCalcBpm = gender ? 0.6309 : 0.4472
        genderCal = gender ? 55.0969 : 20.4022
    }
    
    public func setHeight(_ height: Double) {
        // set Distance Calc
        let calcHeight = ((height * 0.37) + (height - 100)) / 2.0
        avgSize = calcHeight < 0 ? 10 : calcHeight
    }
    
    // MARK: - UserDefault
    private func initHealthData() {
        arrCnt = defaults.integer(forKey: "\(propEmail)\(ArrCntKey)")
        step = defaults.integer(forKey: "\(propEmail)\(StepKey)")
        distance = defaults.double(forKey: "\(propEmail)\(DistanceKey)")
        calorie = defaults.double(forKey: "\(propEmail)\(CalorieKey)")
        activityCalorie = defaults.double(forKey: "\(propEmail)\(ActivityCalorieKey)")
    }
    
    public func setUserDefaultData() {
        defaults.set(arrCnt, forKey: "\(propEmail)\(ArrCntKey)")
        defaults.set(step, forKey: "\(propEmail)\(StepKey)")
        defaults.set(distance, forKey: "\(propEmail)\(DistanceKey)")
        defaults.set(calorie, forKey: "\(propEmail)\(CalorieKey)")
        defaults.set(activityCalorie, forKey: "\(propEmail)\(ActivityCalorieKey)")
    }
    
    // MARK: - Set, Get
    public var bpm: Int {
        get {
            return healthData.bpm
        }
        set {
            healthData.bpm = newValue
            tenSecondData.bpm = newValue
            calcMinMax(newValue)
        }
    }
    
    public var minBpm: Int {
        get {
            return healthData.minBpm
        }
        set {
            healthData.minBpm = newValue
        }
    }
    
    public var maxBpm: Int {
        get {
            return healthData.maxBpm
        }
        set {
            healthData.maxBpm = newValue
        }
    }
    
    public var avgBpm: Int {
        get {
            return healthData.avgBpm
        }
        set {
            healthData.avgBpm = newValue
        }
    }
        
    private func calcMinMax(_ bpm: Int) {

        minBpm = min(minBpm, bpm)
        maxBpm = max(maxBpm, bpm)
        
        avgBpmSum += bpm
        avgBpmCnt += 1
        
        avgBpm = avgBpmSum/avgBpmCnt
    }
    
    
    
    // MARK: -
    public var step: Int {
        get {
            return healthData.step
        }
        set {
            healthData.step = newValue
        }
    }
    
    public var currentStep: Int {
        get {
            return healthData.nowStep
        }
        set {
            healthData.nowStep = newValue
        }
    }
    
    
    // MARK: -
    public var distance: Double {
        get {
            return healthData.distance
        }
        set {
            healthData.distance = newValue
        }
    }
    
    
    // MARK: -
    public var calorie: Double {
        get {
            return healthData.calorie
        }
        set {
            healthData.calorie = newValue
        }
    }
    
    
    public var activityCalorie: Double {
        get {
            return healthData.activityCalorie
        }
        set {
            healthData.activityCalorie = newValue
        }
    }
    
    
    // MARK: -
    public var arrCnt: Int {
        get {
            return healthData.arrCnt
        }
        set {
            healthData.arrCnt = newValue
        }
    }
    
    public var hrv: Int {
        get {
            return healthData.hrv
        }
        set {
            healthData.hrv = newValue
            tenSecondData.hrv = newValue
        }
    }
    
    
    public var temp: Double {
        get {
            return healthData.temp
        }
        set {
            healthData.temp = newValue
            tenSecondData.temp = newValue
        }
    }
    
    
    public var bodyState: String {
        get {
            return healthData.bodyStatus
        }
        set {
            healthData.bodyStatus = newValue
        }
    }
    
    
    // MARK: -
    public func calculateHealthData() {
        calculateCalorie()
        calculateDistance()
        
        setUserDefaultData()
        hourlyData.setUserDefaultData()
        
    }
    
    // MARK: - Calculate Calorie
    private func calculateCalorie() {
        if bpm < 40 {   return  }
        
        let targetBpm = UserProfileManager.shared.targetBpm
        let calorieCalculaton = getCalorieCalculation()
        let activityFlag = bpm > targetBpm
        
        // Calorie
        let calcCalorie = calorie + calorieCalculaton
        calorie = (calcCalorie * 1000).rounded() / 1000
        
        // Activity Calorie
        if activityFlag {
            let calcActivityCalorie = activityCalorie + calorieCalculaton
            activityCalorie = (calcActivityCalorie * 1000).rounded() / 1000
        }
        
        // Hourly Calorie
        hourlyData.calculateCalorie(calorieCalculaton, activityFlag)
        
        // Ten Second Calorie
        tenSecondData.calculateCalorie(calorieCalculaton, activityFlag)
    }
        
    public func getCalorieCalculation() -> Double {
        
        let calculateAge = age * genderCalcAge
        let calculateWeight = weight * genderCalcWeight
        let calculateBpm = Double(bpm) * genderCalcBpm
        
        return (calculateAge + calculateWeight + calculateBpm - genderCal) * CalMinuteUnit / CalcCalUnit
    }
    
    // MARK: - Calculate Distance
    private func calculateDistance() {
        // Distance
        let step = Double(currentStep)   // 걸음수 (cm)
        let additionalSize = getAdditionalSize()
        let calcDistance = distance + ((avgSize + additionalSize) * step)
        
        distance = (calcDistance * 1000).rounded() / 1000.0
        currentStep = 0
        
        // Hourly Distance
        hourlyData.calculateDistance(step, additionalSize, avgSize)
        
        // Ten Second Distance
        tenSecondData.calculateDistance(step, additionalSize, avgSize)
    }
    
    private func getAdditionalSize() -> Double {
        
        let targetBpm = UserProfileManager.shared.targetBpm
        
        if bpm < targetBpm {
            return 0
        } else if  bpm < targetBpm + 20 {
            return 1
        } else if  bpm < targetBpm + 40 {
            return 2
        } else if  bpm < 250 {
            return 3
        } else {
            return 0
        }
    }
    
    
    // MARK: - Body State
    public func updateBodyState(_ currentHour: String, _ bpm: Int) {
        if isInSleepTime(Int(currentHour) ?? 12) {
            bodyState = "S"
        } else {
            setBodyStateBasedOnBpm(bpm)
        }
    }
    
    private func isInSleepTime(_ hour: Int) -> Bool {
        // Sleep
        let bedTime = UserProfileManager.shared.bedTime
        let wakeUpTime = UserProfileManager.shared.wakeUpTime
        return hour >= bedTime || hour < wakeUpTime
    }
    
    private func setBodyStateBasedOnBpm(_ bpm: Int) {
        let targetBpm = UserProfileManager.shared.targetBpm
        
        if bpm >= targetBpm {
            // Active
            bodyState = "E"
        } else {
            // Rest
            bodyState = "R"
        }
    }
    
    
    
    
    
    // MARK: - Exercise
    public func startExercise() {
        exerciseFlag = true
        exerciseCal = healthData.activityCalorie
        exerciseStep = healthData.step
        exerciseDistance = healthData.distance
    }
    
    public func resetExercise() {
        exerciseFlag = false
        exerciseCal = 0.0
        exerciseStep = 0
        exerciseDistance = 0.0
    }
    
    public func getExerciseData() -> (Double, Int, Double) {
        let calorie = healthData.activityCalorie - exerciseCal
        let step = healthData.step - exerciseStep
        let distance = healthData.distance - exerciseDistance
        return (calorie, step, distance)
    }
    
    public func getExerciseFlag() -> Bool {
        return exerciseFlag
    }
}
 
