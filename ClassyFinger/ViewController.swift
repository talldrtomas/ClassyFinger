//
//  ViewController.swift
//  ClassyFinger
//
//  Created by Tomas Galvan-Huerta on 11/14/18.
//  Copyright © 2018 Somat. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ARCL
import CoreLocation

class Spots: NSObject {
    let laditude: Double
    let longitude:Double
    let altitude: Double
    let image: String
    let label: String
    
    init(laditude: Double, longitude: Double, altitude: Double, image: String, name: String) {
        self.laditude = laditude
        self.longitude = longitude
        self.altitude = altitude
        self.image  = image
        self.label = name
    }
    
    
    
}

class ViewController: UIViewController, ARSCNViewDelegate {
    var sceneViewLocation = SceneLocationView()
    var destinations = [Spots(laditude: 32.7636, longitude: -117.1216
        , altitude: 5.0, image: "mario", name: "Starbucks"), Spots(laditude: 32.7635, longitude: -117.1222, altitude: 5.0, image: "butterfly", name: "HairStudio"), Spots(laditude: 32.7635, longitude: -117.1220, altitude: 5.0, image: "heart", name: "BottleShop"),Spots(laditude: 32.7632, longitude: -117.1219, altitude: 1.5, image: "Homer", name: "Column")]
    
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneViewLocation.run()
        sceneViewLocation.orientToTrueNorth = false
        
        // Set the view's delegate
        for mylocations in destinations{
            newMarker(laditude: mylocations.laditude, longitude: mylocations.longitude, altitude: mylocations.altitude, image: mylocations.image)
        }
        
        //Markers will be added
        
        
        
    }
    //--------------------------------------------------------------------------//
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneViewLocation.frame = view.bounds
        
        
        
    }
    //--------------------------------------------------------------------------//
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    //--------------------------------------------------------------------------//
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneViewLocation.pause()
        
    }
    
    //--------------------------------------------------------------------------//
    //Create function to make things easier
    
    func newMarker(laditude: Double, longitude: Double, altitude: Double, image: String){
        let coordinate = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
        
        
        let location = CLLocation(coordinate: coordinate, altitude: altitude + 121.31 - 2)
        guard let image = UIImage(named: image)else {
            return print("Did not find image") }
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        sceneViewLocation.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        annotationNode.scaleRelativeToDistance = true
        sceneView.addSubview(sceneViewLocation)
        
    }
    
    
    
}
