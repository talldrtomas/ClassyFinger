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
    
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var sceneView: ARSCNView!

    //Mark: Loading ontoo phone
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneViewLocation.orientToTrueNorth = false
        for mylocations in destination.destinations{
            addPicture(laditude: mylocations.laditude, longitude: mylocations.longitude, altitude: mylocations.altitude, image: mylocations.image)
        }
        guard let myscene = SCNScene(named: "art.scnassets/SceneKit Scene 2.scn") else {
            return print("No scene Found")}
        guard let mynode = myscene.rootNode.childNode(withName: "cone", recursively: true) else {
            return print("No Pin found")
        }
        addobject(mynode: mynode, laditude: 32.6990, longitude: -117.1160, altitude: 4)
        sceneView.addSubview(sceneViewLocation)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneViewLocation.frame = view.bounds
        
        
        
    }
    //--------------------------------------------------------------------------//
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneViewLocation.run()
    }
    //--------------------------------------------------------------------------//
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneViewLocation.pause()
        
    }
    

    //MARK: Create function to make things easier
    
    func addPicture(laditude: Double, longitude: Double, altitude: Double, image: String){
        let coordinate = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude + 65.00)
        guard let image = UIImage(named: image)else {
            return print("Did not find image") }
        
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        sceneViewLocation.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        annotationNode.scaleRelativeToDistance = true
        
    }
    
    func addobject(mynode: SCNNode, laditude: Double, longitude: Double, altitude: Double){
        let coordinate = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude + 15.24)
        let node = LocationNode(location: location)
        node.geometry = mynode.geometry
        sceneViewLocation.addLocationNodeWithConfirmedLocation(locationNode: node)
    }
    
    //MARK: SearchBar
    
    func alterLayout() {
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false // you can show/hide this dependant on your layout
        //searchBar.placeholder = "Search Animal by Name"
    }
  
}

