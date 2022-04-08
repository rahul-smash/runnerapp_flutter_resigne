//
//  LocationManager.swift
//  Runner
//
//  Created by Jasmeet on 10/02/22.
//

import Foundation
import CoreLocation


class LocationManager : NSObject,CLLocationManagerDelegate {
    
    static var shared = LocationManager()
    var currentLocation:CLLocation?
    var locationManager : CLLocationManager?
    
    private override init(){
        
    }
    
    func setupLocationManager(){
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.requestAlwaysAuthorization()
                locationManager?.allowsBackgroundLocationUpdates = true
                locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager?.startUpdatingLocation()

            }

        // Below method will provide you current location.
         func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

                if currentLocation == nil {
                    currentLocation = locations.last!
                    locationManager?.stopMonitoringSignificantLocationChanges()
                    let locationValue:CLLocationCoordinate2D = manager.location!.coordinate

                    print("locations = \(locationValue)")

                    //locationManager?.stopUpdatingLocation()
                }
            }

        // Below Mehtod will print error if not able to update location.
            func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                print("Error")
            }

    
}
