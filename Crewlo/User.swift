//
//  User.swift
//  Crewlo
//
//  Created by Corey Howell on 2/7/16.
//  Copyright © 2016 Crewlo. All rights reserved.
//

import Foundation
import CoreLocation

class User: NSObject, CLLocationManagerDelegate {
    let defaults = NSUserDefaults.standardUserDefaults();
    let locationManager = CLLocationManager();
    var fb_id: Int = 0;
    
    override init() {
        super.init();
        initLocationDelegate();
    }
    
    func getId() -> Int {
        let id = defaults.objectForKey("user_id") as! Int;
        return id;
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func initLocationDelegate() {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.requestAlwaysAuthorization();
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations);
        if let location = locations.first {
            print("Current location: \(location)");
        } else {
            // ...
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
    
    func requestLocation() {
        locationManager.requestLocation();
    }
    
}