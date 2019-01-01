//
//  ViewController.swift
//  ClassyFinger
//
//  Created by Tomas Galvan-Huerta on 11/14/18.
//  Copyright © 2018 Somat. All rights reserved.
// Render: Create node for specific location(laditude and Longgitude)
// Create Museum points
// Create big pins for the Museums
// Create roads for the entrences of museums
// Make several Current Location nodes for the museums


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
    let destination = Locations()
    
    

    @IBOutlet var Longpress: UILongPressGestureRecognizer!
    @IBOutlet var sceneView: ARSCNView!
    //--------------------------------------------------------------------------//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneViewLocation.run()
        sceneViewLocation.orientToTrueNorth = false
        for mylocations in destination.destinations{
            newMarker(laditude: mylocations.laditude, longitude: mylocations.longitude, altitude: mylocations.altitude, image: mylocations.image)
        }
        
    }
    
    
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
        
        
        let location = CLLocation(coordinate: coordinate, altitude: altitude + 65.00)
        guard let image = UIImage(named: image)else {
            return print("Did not find image") }
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        sceneViewLocation.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        annotationNode.scaleRelativeToDistance = true
        sceneView.addSubview(sceneViewLocation)
    }
  
}

/*guard let imagetoTrack = ARReferenceImage.referenceImages(inGroupNamed: "trackingImages", bundle: Bundle.main) else {
    return print("Images not found")
}
configuration.detectionImages = imagetoTrack
configuration.maximumNumberOfTrackedImages = 2
sceneView.session.run(configuration)
print("Image was found")




 
 func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
 let CurrentLocation = SCNNode()
 if let imageAnchor = anchor as? ARImageAnchor{
 let plance = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
 let planeNode = SCNNode(geometry: plance)
 CurrentLocation.addChildNode(planeNode)
 }
 
 return CurrentLocation
 }
 
 */

