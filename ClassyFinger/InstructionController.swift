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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationmaneger.delegate = self
        locationmaneger.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

        if CLLocationManager.headingAvailable(){
            locationmaneger.headingFilter = 5
            locationmaneger.startUpdatingHeading()
        }
        
        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        degreeLabel.text = String(newHeading.magneticHeading.rounded())
    }
    

    

}
