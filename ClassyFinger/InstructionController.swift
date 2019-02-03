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
    
    var tutorialstarted = 0
    
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var nextbutton: UIButton!
    @IBOutlet weak var tutorial: UIView!
    @IBOutlet weak var TopTutorialLabel: UILabel!
    @IBOutlet weak var bottomTutorial: UILabel!
    @IBOutlet weak var tutorialbutton: UIButton!
    
    
    @IBAction func startTutorial(_ sender: UIButton) {
        tutorialstarted = 0
        tutorial.isHidden = false
        tutorial.alpha = 1
        nextbutton.isEnabled = false
        TopTutorialLabel.isHidden = false
        bottomTutorial.isHidden = true
    }
    @IBAction func nextInstruction(_ sender: UITapGestureRecognizer) {
        tutorialstarted += 1
        switch tutorialstarted {
        case 0:
            TopTutorialLabel.isHidden = false
            bottomTutorial.isHidden = true
        case 1:
            TopTutorialLabel.isHidden = true
            bottomTutorial.isHidden = false
        case 2:
            TopTutorialLabel.text = "Click on the Arrow"
            TopTutorialLabel.isHidden = false
            bottomTutorial.isHidden = true
            nextbutton.isEnabled = true
        case 3:
            tutorial.isHidden = true
            tutorialbutton.titleLabel?.text = "Tutorial"
        default:
            tutorialstarted = 0
        }

        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorial.isHidden = true
        
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
