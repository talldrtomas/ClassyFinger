//
//  InstructionController.swift
//  ClassyFinger
//
//  Created by Tomas Galvan-Huerta on 1/18/19.
//  Copyright © 2019 Somat. All rights reserved.
//

import UIKit
import CoreLocation


class InstructionController: UIViewController, CLLocationManagerDelegate{
        let locationmaneger = CLLocationManager()
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var nextbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationmaneger.delegate = self
        locationmaneger.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

        if CLLocationManager.headingAvailable(){
            locationmaneger.headingFilter = 1
            locationmaneger.startUpdatingHeading()
        }
        
        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let degreenumber = Int(newHeading.magneticHeading.rounded())
        
        degreeLabel.text = "\(degreenumber)°"
        if degreenumber == 1 || degreenumber == 0 || degreenumber == 360{
            nextbutton.isEnabled = true
            nextbutton.isHidden = false
        }
        else{
            nextbutton.isEnabled = false
            nextbutton.isHidden = true
        }
    }
    

    

}
