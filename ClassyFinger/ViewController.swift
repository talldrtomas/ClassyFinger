//
//  ViewController.swift
//  ClassyFinger
//
//  Created by Tomas Galvan-Huerta on 11/14/18.
//  Copyright © 2018 Somat. All rights reserved.
// Create Museum points (sammy)
//Learn about reference nodes
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
    var pointsofIntrest = [Spots]()
    var searchSpots = [Spots]()
    var myscene = SCNScene()
    var spintop = SCNNode()
    var longmarker = SCNNode()
    
    
    @IBAction func rightTouchmove(_ sender: UITapGestureRecognizer) {
        sceneViewLocation.moveSceneHeadingClockwise()
    }
    
    @IBAction func lefTouchMove(_ sender: UITapGestureRecognizer) {
        sceneViewLocation.moveSceneHeadingAntiClockwise()
    }
    
    
    @IBAction func RestartNorth(_ sender: UIButton) {
        removeallNode()
        pointsofIntrest.removeAll()
        sceneViewLocation.run()
        sceneViewLocation.resetSceneHeading()
        addpointOfIntrest()
        selectednodestoPresent()
    }
    
    @IBAction func ShowAllNodes(_ sender: UIButton) {
        removeallNode()
        pointsofIntrest.removeAll()
        addpointOfIntrest()
        selectednodestoPresent()
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var sceneView: ARSCNView!

    //Mark: Loading ontoo phone
    override func viewDidLoad() {
        super.viewDidLoad()
        myscene = SCNScene(named: "art.scnassets/SceneKit Scene 2.scn")!
        spintop = myscene.rootNode.childNode(withName: "cone", recursively: true)!
        longmarker = myscene.rootNode.childNode(withName: "capsule", recursively: true)!
        sceneView.addSubview(sceneViewLocation)
        addpointOfIntrest()
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
        for allnodes in pointsofIntrest{
         //turn list into object
            addpicobject(spots: allnodes)
            switch allnodes.intrest{
            case intrestPoints.ChicoState.rawValue:
                addchicoClasse()
            case intrestPoints.SanDiegoMesaCollege.rawValue:
                addsandiegoMesaCollege()
            case intrestPoints.BalboaMuseums.rawValue:
                addSDBalboaMuseums()
            case intrestPoints.Home.rawValue:
                print("Home personal nodes are added")
            default: print("No nodes were added")
            }
        
        
        sceneView.addSubview(sceneViewLocation)
        }}
    
    func addAllNodesinQuery(){
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
    
    
    
    
    
    
    
    
        enum intrestPoints: String {
        case ChicoState = "Chico State"
        case SanDiegoMesaCollege = "SD Mesa College"
        case Home = "Home"
        case BalboaMuseums = "Balboa museums"
    }
    
    func addpointOfIntrest(){
        guard let currentposition = sceneViewLocation.currentLocation() else {
            return print("Current location not found")
        }
        let chicoState = Spots(laditude: 39.7297, longitude: -121.8447, altitude: 30, image: nil, name: "Chico State", elevation: 65, intrest: intrestPoints.ChicoState.rawValue)
        if comparedistance(spot1: chicoState.cllocation, spot2: currentposition) < 800 {
            pointsofIntrest.append(chicoState)}
        let SDMesacollege = Spots(laditude: 32.8038, longitude: -117.1690, altitude: 50, mynode: longmarker, name: "Mesa College", elevation: 104, intrest: intrestPoints.SanDiegoMesaCollege.rawValue)
        if comparedistance(spot1: SDMesacollege.cllocation, spot2: currentposition) < 800 {
            pointsofIntrest.append(SDMesacollege)}
        let home = Spots(laditude: 32.6990, longitude: -117.1160, altitude: 4, mynode: spintop, name: "home", elevation: 15, intrest: intrestPoints.Home.rawValue)
        if comparedistance(spot1: home.cllocation, spot2: currentposition) < 800 {
            pointsofIntrest.append(home)}
    }
    
    
    func addchicoClasse(){
        //append to Destination
    }
    func addsandiegoMesaCollege(){
        //append to Destination
    }
    
    func addSDBalboaMuseums(){
        //append to Destination
        
    }
    
    
}

