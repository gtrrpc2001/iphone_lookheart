import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private let locationManager = CLLocationManager()
    var gpsDate: Date?
    var gpsLat: Double?
    var gpsLong: Double?
    var firstCheck = false
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        startUpdatingLocation()
    }

    // 권한 요청
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    // 위치 업데이트 시작
    func startUpdatingLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            // 권한 없음 설정 및 안내 필요
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        gpsDate = Date()
        gpsLat = location.coordinate.latitude   // 위도
        gpsLong = location.coordinate.longitude // 경도
        
        locationManager.stopUpdatingLocation()
    
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // 위치 정보를 바탕으로 주소 가져오기
    func addressInfo(lat: CLLocationDegrees, long: CLLocationDegrees, completion: @escaping (String?) -> Void) {
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(findLocation, completionHandler: {(placemarks, error) in
            var currentAddress: String? = nil
            if error == nil {
                if let address = placemarks?.first {
                    if let country = address.country,
                        let administrativeArea = address.administrativeArea,
                        let name = address.name {
                        currentAddress = "\(country) \(administrativeArea) \(name)"
                    }
                }
            }
            completion(currentAddress)
        })
    }
    
    func getLocation() -> (lat: Double?, long: Double?)? {
        if gpsLat != nil && gpsLong != nil {
            return (gpsLat, gpsLong)
        } else {
            return nil
        }
    }
    
}
