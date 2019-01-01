//
//  ViewController.swift
//  ClassyFinger
//
//  Created by Tomas Galvan-Huerta on 11/14/18.
//  Copyright © 2018 Somat. All rights reserved.
// Create Museum points (sammy)
// Create big pins for the Museums 
// Create roads for the entrences of museums
// Make several Current Location nodes for the museums


import UIKit
import SceneKit
import ARKit
import ARCL
import CoreLocation




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
            addPicture(laditude: mylocations.laditude, longitude: mylocations.longitude, altitude: mylocations.altitude, image: mylocations.image)
        }
        for objetcs in 
        
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
    
    func addPicture(laditude: Double, longitude: Double, altitude: Double, image: String){
        let coordinate = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
        
        
        let location = CLLocation(coordinate: coordinate, altitude: altitude + 65.00)
        guard let image = UIImage(named: image)else {
            return print("Did not find image") }
        
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        sceneViewLocation.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        annotationNode.scaleRelativeToDistance = true
        sceneView.addSubview(sceneViewLocation)
    }
    
    func addobject(node: SCNNode, laditude: Double, longitude: Double, altitude: Double){
        let coordinate = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude + 65.00)
        let node = LocationNode(location: location)
        node.geometry = node.geometry
        sceneView.scene.rootNode.addChildNode(node)
        
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

