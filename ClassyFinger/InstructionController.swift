//
//  InstructionController.swift
//  ClassyFinger
//
//  Created by Tomas Galvan-Huerta and Janet C on 1/18/19.
//  Copyright © 2019 Somat. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMobileAds


class InstructionController: UIViewController, CLLocationManagerDelegate, GADBannerViewDelegate{
        let locationmaneger = CLLocationManager()
    
    var tutorialstarted = 0
    
    @IBOutlet weak var bannerView: GADBannerView!
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
            TopTutorialLabel.text = "Start Outside"
            bottomTutorial.isHidden = true
            
        case 1:
            TopTutorialLabel.isHidden = true
            bottomTutorial.isHidden = false
            degreeLabel.textColor = UIColor.white
        case 2:
            TopTutorialLabel.text = "Click on the Arrow"
            TopTutorialLabel.isHidden = false
            bottomTutorial.isHidden = true
            nextbutton.isEnabled = true
            degreeLabel.textColor = UIColor.lightText
            nextbutton.isHighlighted = true
        case 3:
            tutorial.isHidden = true
            TopTutorialLabel.text = "Start Outside"


        default:
            tutorialstarted = 0
        }

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let alert = UIAlertController(title: "Warning", message: "Please be safe and check surroundings", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Got it Captain", style: UIAlertAction.Style.default, handler: nil))
        alert.isSpringLoaded = true
        self.present(alert, animated: true, completion: nil)
        
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
        bannerView.adUnitID = "ca-app-pub-9535412467175731/8962469619"
        //ca-app-pub-9535412467175731/8962469619 Id to actuall ads
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
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

