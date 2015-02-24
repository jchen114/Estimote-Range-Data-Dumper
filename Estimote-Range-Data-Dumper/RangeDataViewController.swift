//
//  RangeViewController.swift
//  Estimote-Range-Data-Dumper
//
//  Created by Jacob Chen on 2/20/15.
//  Copyright (c) 2015 Looped LLC. All rights reserved.
//

import UIKit

class RangeDataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var rangePickerView: UIPickerView!
    @IBOutlet var measuringButton: UIButton!
    @IBOutlet var rssiReadingLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var zoneLabel: UILabel!
    @IBOutlet var zoningButton: UIButton!
    
    let values:[Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    var measure:Bool = false
    var zoning:Bool = false
    var dataReaderCount: Int = 0
    
    //let locationManager: CLBeaconManager = CLBeaconManager.sharedBeaconManager
    let locationManager: estBeaconManager = estBeaconManager.sharedBeaconManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Notification listeners
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "changeRSSIReading:",
            name: NOTIF_UPDATE_RSSI_LABEL,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "updateZoneLabel:",
            name: NOTIF_UPDATE_ZONE_LABEL,
            object: nil
        )
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: UIPickerView Delegate methods
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50.0
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.size.width
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return String(values[row])
    }
    
    // MARK: UIPickerView Datasource methods
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: UIButton methods
    
    @IBAction func measuringButtonPressed(sender: AnyObject) {
        
        if (!measure) {
            /*
            Default UUID: B9407F30-F5F8-466E-AFF9-25556B57FE6D
            (major:46555, minor:50000),
            (major:31782, minor:36689),
            (major:19714, minor:49179)
            */
            // begin measuring and change text to stop measuring
            
            startMeasuring()
            
        } else {
            
            stopMeasuring()
            
        }

    }
    @IBAction func displayZonePressed(sender: AnyObject) {
        
        if !zoning {
            startRanging()
        } else {
            stopRanging()
            self.zoningButton.setTitle("Display Zone", forState: UIControlState.Normal)
        }
        
        zoning = !zoning
    }
    
    func startRanging() {
        
        locationManager.findZoneOfRegion(majID: 46555, minID: nil)
        self.zoningButton.setTitle("Stop Zoning", forState: UIControlState.Normal)
        
    }
    
    func stopRanging() {
        locationManager.stop()
        self.zoneLabel.text = ""
    }
    
    func startMeasuring() {
        locationManager.listenToRegion(
            majID: 46555,
            minID: nil,
            range: values[rangePickerView.selectedRowInComponent(0)]
        )
        measuringButton.setTitle("Stop Measuring", forState: UIControlState.Normal)
        dataReaderCount = 0
        measure = true
    }
    
    func stopMeasuring () {
        // stop measuring and change text to start measuring
        locationManager.stop()
        measuringButton.setTitle("Start Measuring", forState: UIControlState.Normal)
        measure = false
    }
    
    // MARK: NOTIFICATION METHODS
    
    func changeRSSIReading (notification: NSNotification) {
        
        var rssiReading: String = notification.userInfo![RSSI_KEY] as String
        
        self.rssiReadingLabel.text = rssiReading
        dataReaderCount += 1
        self.countLabel.text = String(dataReaderCount)
        
        if dataReaderCount == 51 {
            // Stop the reader
            stopMeasuring()
        }
        
    }
    
    func updateZoneLabel (notification: NSNotification) {
        
        var zone: String = notification.userInfo![ZONE_KEY] as String
        self.zoneLabel.text = zone
        
        
    }
    
    
}

