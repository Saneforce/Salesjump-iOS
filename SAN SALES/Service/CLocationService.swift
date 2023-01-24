//
//  CLocationService.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 23/03/22.
//

import Foundation
import CoreLocation

public class CLocationService: NSObject, CLLocationManagerDelegate {
    
    private let manager: CLLocationManager
    var requestNewLocation: ((_ newlocation: CLLocation) -> Void)?
    
    init(manager: CLLocationManager = .init()) {
        self.manager = manager
        super.init()
        manager.delegate = self
    }
   
    public func getNewLocation(location: ((CLLocation) -> Void)?) {
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = 5
        manager.activityType = .fitness
        
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        
        //manager.desiredAccuracy = kCLLocationAccuracyBest
        //manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
        self.requestNewLocation=location
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
            if(newLocation != nil && theAccuracy > 0 && theAccuracy < 2000 && (!(theLocation.latitude==0.0&&theLocation.longitude==0.0))){
                
                //self.myLastLocation = theLocation;
                //self.myLastLocationAccuracy= theAccuracy;
                
                self.requestNewLocation?(newLocation)
                //self.
                let dict = NSMutableDictionary()
                dict.setObject(theLocation.latitude , forKey: "latitude" as NSCopying)
                dict.setObject(theLocation.longitude , forKey: "longitude" as NSCopying)
                dict.setObject(theAccuracy , forKey: "theAccuracy" as NSCopying)
                
            }
        }
    }
}
/*extension CLocationService: CLLocationManagerDelegate {
   /*func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       
       self.requestNewLocation?((error))
       //newLocation?(.failure(error))
       manager.stopUpdatingLocation()
   }*/

   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if let location = locations.sorted(by: {$0.timestamp > $1.timestamp}).first {
           requestNewLocation?(location)
       }
       manager.stopUpdatingLocation()
   }

   /*func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       switch status {
       case .notDetermined, .restricted, .denied:
           didChangeStatus?(false)
       default:
           didChangeStatus?(true)
       }
   }*/
}*/
/*enum Result<T> {
  case success(T)
  case failure(Error)
}

final class CLocationService: NSObject {
    private let manager: CLLocationManager

    init(manager: CLLocationManager = .init()) {
        self.manager = manager
        super.init()
        manager.delegate = self
    }

    var newLocation: ((Result<CLLocation>) -> Void)?
    var didChangeStatus: ((Bool) -> Void)?

    var status: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }

    func requestLocationAuthorization() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }

    func getLocation() {
        manager.requestLocation()
    }

    deinit {
        manager.stopUpdatingLocation()
    }
    
    func requestLoc(callback : @escaping ((_ newLocation: CLLocation?) -> Void)){
        
    }

}*/


