//
//  CLBeaconManager.swift
//  Estimote-Range-Data-Dumper
//
//  Created by Jacob Chen on 2/20/15.
//  Copyright (c) 2015 Looped LLC. All rights reserved.
//

import Foundation

private let _SingletonSharedBeaconManager = CLBeaconManager()
private let BEACON_PROXIMITY_UUID = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")

class CLBeaconManager: NSObject, CLLocationManagerDelegate {
    
    var manager : CLLocationManager = CLLocationManager()
    var beaconRegion : CLBeaconRegion?
    var startWriting : Bool = false
    var majorID: Int?
    var minorID: Int?
    
    class var sharedBeaconManager : CLBeaconManager {
        
        return _SingletonSharedBeaconManager
        
    }
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func listenToRegion(
        regionID: NSUUID = BEACON_PROXIMITY_UUID!,
        regionName: String = "Estimotes",
        majID: Int?,
        minID: Int?
        ) {
            
            if (majID != nil && minID != nil) {
                
                majorID = majID
                minorID = minID
                
            }
            if (majID != nil) {
                
                majorID = majID
                
            }
            
            beaconRegion = CLBeaconRegion(
                proximityUUID: BEACON_PROXIMITY_UUID,
                identifier: regionName
            )
            
            if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
                manager.requestWhenInUseAuthorization()
            }
            
            self.start()
            manager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    func start() {
        println("BM start");
        manager.startMonitoringForRegion(beaconRegion)
    }
    
    func stop() {
        println("BM stop");
        manager.stopMonitoringForRegion(beaconRegion)
    }
    
    // MARK: CLLocationManagerDelegate methods
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        println("BM didStartMonitoringForRegion");
        manager.requestStateForRegion(region); // should locationManager be manager?
    }
    
    func writeRangeToFile(fileName: String, range: Int, majorID: Int, minorID: Int) {
        
        
        if (!startWriting) {
            startWriting = true
        }
        // Start writing to a file
        
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        println(beacons)
    }
    
}