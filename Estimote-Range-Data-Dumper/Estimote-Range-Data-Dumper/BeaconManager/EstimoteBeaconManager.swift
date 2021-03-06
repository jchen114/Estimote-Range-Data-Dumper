//
//  EstimoteBeaconManager.swift
//  Estimote-Range-Data-Dumper
//
//  Created by Jacob Chen on 2/19/15.
//  Copyright (c) 2015 Looped LLC. All rights reserved.
//

import Foundation

/* 
Default UUID: B9407F30-F5F8-466E-AFF9-25556B57FE6D
(major:46555, minor:50000),
(major:31782, minor:36689), 
(major:19714, minor:49179)
*/

private let _SingletonSharedBeaconManager = estBeaconManager()
private let DEFAULT_UUID = NSUUID(UUIDString:"B9407F30-F5F8-466E-AFF9-25556B57FE6D")

class estBeaconManager : NSObject, ESTBeaconManagerDelegate {
    
    let manager : ESTBeaconManager = ESTBeaconManager()
    let fileMgr: RangeDataFileManager = RangeDataFileManager.sharedFileManager
    var beaconRegion : ESTBeaconRegion?
    var startWriting : Bool = false
    var majorID: NSNumber?
    var minorID: NSNumber?
    var range: NSNumber?
    
    class var sharedBeaconManager : estBeaconManager {
        
        return _SingletonSharedBeaconManager
        
    }
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func listenToRegion(
        regionID: NSUUID = DEFAULT_UUID!,
        regionName: String = "Default Region",
        majID: NSNumber?,
        minID: NSNumber?,
        range: NSNumber
        ) {
            
            startRanging(
                regionID: regionID,
                regionName: regionName,
                majID: majID,
                minID: minID,
                range: range
            )
            
            startWriting = true
            fileMgr.openFile(self.range!)
    }
    
    func findZoneOfRegion(
        regionID: NSUUID = DEFAULT_UUID!,
        regionName: String = "Default Region",
        majID: NSNumber?,
        minID: NSNumber?
        ) {
            
            startRanging(
                regionID: regionID,
                regionName: regionName,
                majID: majID,
                minID: minID,
                range: nil
            )
            
            startWriting = false
    }
    
    func startRanging(
        regionID: NSUUID = DEFAULT_UUID!,
        regionName: String = "Default Region",
        majID: NSNumber?,
        minID: NSNumber?,
        range: NSNumber?) {
            
            majorID = majID
            minorID = minID
            if range != nil {
                self.range = range
            }
            beaconRegion = ESTBeaconRegion(
                proximityUUID: regionID,
                identifier: regionName
            )
            
            manager.startMonitoringForRegion(beaconRegion)
            manager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    func writeRangeToFile(rssi: NSInteger) {
        
        // Start writing to a file
        if (startWriting) {
            fileMgr.write(String(rssi))
        }
    }
    
    func beaconManager(manager: ESTBeaconManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: ESTBeaconRegion!) {
        
        var filteredBeacons: [ESTBeacon] = beacons as [ESTBeacon]
        
        if (majorID != nil && minorID != nil) {
            filteredBeacons = filteredBeacons.filter{$0.major == self.majorID && $0.minor == self.minorID}
        }
        if (majorID != nil) {
            filteredBeacons = filteredBeacons.filter{$0.major == self.majorID}
        }
        
        for beacon in filteredBeacons {
            println("major: \(beacon.major), rssi: \(beacon.rssi)")
            if startWriting {
                self.writeRangeToFile(beacon.rssi)
            }
            
            // Display the zone
            
            var info:[String: String]
            
            switch (beacon.proximity) {
            case CLProximity.Unknown:
                info = [ZONE_KEY: "Unknown"]
                break;
            case CLProximity.Immediate:
                info = [ZONE_KEY: "Immediate"]
                break;
            case CLProximity.Near:
                info = [ZONE_KEY: "Near"]
                break;
            case CLProximity.Far:
                info = [ZONE_KEY: "Far"]
                break;
                
            default:
                break;
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(NOTIF_UPDATE_ZONE_LABEL, object: nil, userInfo: info)
            
        }
        
    }
    
    func beaconManager(manager: ESTBeaconManager!, rangingBeaconsDidFailForRegion region: ESTBeaconRegion!, withError error: NSError!) {
        println(error)
    }
    
    func stop() {
        
        // Stop listening
        manager.stopRangingBeaconsInRegion(beaconRegion)
        if startWriting {
            fileMgr.close()
            startWriting = false
        }
    }
    
}