//
//  LocationService.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 23/03/22.
//

import Foundation
import CoreLocation

public class LocationService: NSObject, CLLocationManagerDelegate{
    public static var sharedInstance = LocationService()
    let locationManager: CLLocationManager
    var requestNewLocation: ((_ newLocation: CLLocation) -> Void)?
    var ErrorLocation: ((_ errmsg: String) -> Void)?
    var Tmr: Timer = Timer()
    
    override init() {
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        locationManager.activityType = .fitness
        
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = false
        
        super.init()
        locationManager.delegate = self
        self.Tmr=Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ExitLocation), userInfo: nil, repeats: false)
        
    }
    @objc func ExitLocation(){
        self.ErrorLocation?("Timed Out. Location Can't Capture")
        Tmr.invalidate()
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func isLocationPermissionEnable() -> Bool{
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        @unknown default:
            return true
        }
    }
    public func getNewLocation(location: ((CLLocation) -> Void)?,error: ((String) -> Void)?) {
        self.requestNewLocation = location
        self.ErrorLocation = error
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
    }
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // for(int i=0;i<locations.count;i++)
        for i in 0...locations.count-1 {
            let newLocation: CLLocation = locations[i]
            let theLocation: CLLocationCoordinate2D  = newLocation.coordinate
            let theAccuracy: CLLocationAccuracy  = newLocation.horizontalAccuracy
            
            let locationAge: TimeInterval  = -newLocation.timestamp.timeIntervalSinceNow
            NSLog("New Location: %f , %f", theLocation.latitude, theLocation.longitude);
            
            if (locationAge > 30.0)
            {
                continue;
            }
            
            if(newLocation != nil && theAccuracy > 0 && theAccuracy < 2000 && (!(theLocation.latitude==0.0 && theLocation.longitude==0.0))){
                
                //self.myLastLocation = theLocation;
                //self.myLastLocationAccuracy= theAccuracy;
                
                if(self.requestNewLocation != nil ){
                    Tmr.invalidate()
                    self.requestNewLocation?(newLocation)
                    locationManager.stopUpdatingLocation()
                }
                
                let dict = NSMutableDictionary()
                dict.setObject(theLocation.latitude , forKey: "latitude" as NSCopying)
                dict.setObject(theLocation.longitude , forKey: "longitude" as NSCopying)
                dict.setObject(theAccuracy , forKey: "theAccuracy" as NSCopying)
                
            }
        }
    }
}
