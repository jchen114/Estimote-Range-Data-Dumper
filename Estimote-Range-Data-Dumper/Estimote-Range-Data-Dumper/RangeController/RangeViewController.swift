//
//  RangeViewController.swift
//  Estimote-Range-Data-Dumper
//
//  Created by Jacob Chen on 2/20/15.
//  Copyright (c) 2015 Looped LLC. All rights reserved.
//

import UIKit

class RangeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var rangePickerView: UIPickerView!
    
    @IBOutlet var measuringButton: UIButton!
    
    let values:[Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    var measure:Bool = false
    
    //let locationManager: CLBeaconManager = CLBeaconManager.sharedBeaconManager
    let locationManager: estBeaconManager = estBeaconManager.sharedBeaconManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            locationManager.listenToRegion(
                majID: 46555,
                minID: nil,
                range: values[rangePickerView.selectedRowInComponent(0)]
            )
            measuringButton.setTitle("Stop Measuring", forState: UIControlState.Normal)
            
        } else {
            
            // stop measuring and change text to start measuring
            locationManager.stop()
            measuringButton.setTitle("Start Measuring", forState: UIControlState.Normal)
            
        }
        
        measure = !measure
        
    }
    
    
}

