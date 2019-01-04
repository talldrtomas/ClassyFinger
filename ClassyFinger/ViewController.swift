//
//  ViewController.swift
//  ClassyFinger
//
//  Created by Tomas Galvan-Huerta on 11/14/18.
//  Copyright © 2018 Somat. All rights reserved.
// Create Museum points (sammy)
// Create roads for the entrences of museums
// Make several Current Location nodes for the museums


import UIKit
import SceneKit
import ARKit
import ARCL
import CoreLocation




class ViewController: UIViewController, ARSCNViewDelegate, UISearchBarDelegate {
    var sceneViewLocation = SceneLocationView()
    var destination = [Spots]()
    let multiplelocations = Locations()
    var searchSpots = [Spots]()
    
    
    @IBAction func rightTouchmove(_ sender: UITapGestureRecognizer) {
        sceneViewLocation.moveSceneHeadingClockwise()
    }
    @IBAction func lefTouchMove(_ sender: UITapGestureRecognizer) {
        sceneViewLocation.moveSceneHeadingAntiClockwise()
        
    }
    
    
    @IBAction func RestartNorth(_ sender: UIButton) {
        removeallNode()
        sceneViewLocation.run()
        sceneViewLocation.resetSceneHeading()
        selectednodestoPresent()
    }
    
    @IBAction func ShowAllNodes(_ sender: UIButton) {
        removeallNode()
        selectednodestoPresent()
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var sceneView: ARSCNView!

    //Mark: Loading ontoo phone
    override func viewDidLoad() {
        super.viewDidLoad()
        multiplelocations.trianglenode()
        destination.append(contentsOf: multiplelocations.destinations)
        sceneView.addSubview(sceneViewLocation)
        selectednodestoPresent()
    
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
    
    func addpicobject(spots: Spots){
        let coordinate = CLLocationCoordinate2D(latitude: spots.laditude, longitude: spots.longitude)
        let location = CLLocation(coordinate: coordinate, altitude: spots.altitude + spots.elevation)
        if spots.image != nil{
            let imagename = spots.image!
            guard let image = UIImage(named: imagename)else {
                return print("Did not find image") }
            let annotationNode = LocationAnnotationNode(location: location, image: image)
            
            sceneViewLocation.addLocationNodeWithConfirmedLocation(locationNode: annotationNode, action: nil)
            annotationNode.scaleRelativeToDistance = true
        }
        if spots.node != nil{
            let node = LocationNode(location: location)
            node.geometry = spots.node?.geometry
            let action = SCNAction.rotateBy(x: 0, y: 6.28319, z: 0, duration: 5.3)
            let repeataction = SCNAction.repeatForever(action)
            node.runAction(repeataction)
            sceneViewLocation.addLocationNodeWithConfirmedLocation(locationNode: node, action: repeataction)

        }
        
    }

    
    //MARK: SearchBar
    
    func alterLayout() {
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = true // you can show/hide this dependant on your layout
        searchBar.sizeToFit()
        //searchBar.placeholder = "Search Animal by Name"
    }
   func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        removeallNode()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let mytextspots = destination.first(where: {$0.label.lowercased() == searchBar.text!.lowercased()}) {
            // it exists, do something
            //mytextSpots is the Spots
            addpicobject(spots: mytextspots)
        } else {
            print("no Picture was found")
        }
        
    }
    
    //MARK: Add all the nodes and make them move
    //make the Parent node the
    
    func selectednodestoPresent(){
        guard let currentposition = sceneViewLocation.currentLocation() else {
            return print("Current location not found")
        }
        multiplelocations.addpointOfIntrest()
        for allnodes in multiplelocations.pointsofIntrest{
            if comparedistance(spot1: allnodes.cllocation, spot2: currentposition) < 3000 {
                addpicobject(spots: allnodes)
            
            }else {
                //Add new marker here
                //MARK: Add new design of marker
                addpicobject(spots: allnodes)
            }}
        sceneView.addSubview(sceneViewLocation)
    }
    
    func addAllNodes(){
        for allnodes in destination{
            addpicobject(spots: allnodes)
            sceneView.addSubview(sceneViewLocation)
        }}
    
    func removeallNode(){
        for indexNodes in sceneViewLocation.locationNodes {
            sceneViewLocation.removeLocationNode(locationNode: indexNodes)
        }
    }
    func comparedistance(spot1: CLLocation, spot2: CLLocation) -> Double {
        let distanceInMeters = spot1.distance(from: spot2)// Distance in Meters
        return distanceInMeters
    }
    
    
    
    
    
    
    
    
    
    
    
}

