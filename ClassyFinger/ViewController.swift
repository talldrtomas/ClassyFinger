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


enum intrestPoints: String {
    case ChicoState = "Chico State"
    case SanDiegoMesaCollege = "SD Mesa College"
    case Home = "Home"
    case BalboaMuseums = "Balboa museums"
}


class ViewController: UIViewController, ARSCNViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var sceneViewLocation = SceneLocationView()
    var destination = [Spots]()
    var pointsofIntrest = [Spots]()
    var searchSpots = [Spots]()
    var myscene = SCNScene()
    var spintop = SCNNode()
    var arrowNode = SCNNode()
    
    
    @IBOutlet weak var table: UITableView!
    @IBAction func rightTouchmove(_ sender: UITapGestureRecognizer) {
        sceneViewLocation.moveSceneHeadingClockwise()
    }
    
    @IBAction func lefTouchMove(_ sender: UITapGestureRecognizer) {
        sceneViewLocation.moveSceneHeadingAntiClockwise()
    }
    
    
    @IBAction func RestartNorth(_ sender: UIButton) {
        removeallNode()
        pointsofIntrest.removeAll()
        destination.removeAll()
        sceneViewLocation.resetSceneHeading()
        addpointOfIntrest()
        selectednodestoPresent()
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var sceneView: ARSCNView!

    //Mark: Loading ontoo phone
    override func viewDidLoad(){
        super.viewDidLoad()
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
        myscene = SCNScene(named: "art.scnassets/SceneKit Scene 2.scn")!
        spintop = myscene.rootNode.childNode(withName: "cone", recursively: true)!
        arrowNode = myscene.rootNode.childNode(withName: "arrows", recursively: true)!
    }
    //--------------------------------------------------------------------------//
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneViewLocation.pause()
        
    }
    

    //MARK: - Add pictures and Objects Function
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
            let arrows = LocationNode(location: location)
            arrows.geometry = arrowNode.geometry
            sceneViewLocation.addLocationNodeWithConfirmedLocation(locationNode: arrows, action: nil)
        }
    }

    func addlabelAbove(spots: Spots){
        let coordinate = CLLocationCoordinate2D(latitude: spots.laditude, longitude: spots.longitude)
        let location = CLLocation(coordinate: coordinate, altitude: spots.altitude + spots.elevation + 150)
        
        let geometry = SCNText(string: spots.label, extrusionDepth: 3)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        geometry.materials = [material]
        let node = LocationNode(location: location)
        node.geometry = geometry
        node.scale = SCNVector3(100.0, 100.0, 100.0)
        let action = SCNAction.rotateBy(x: 0, y: -6.28319, z: 0, duration: 15.0)
        let repeataction = SCNAction.repeatForever(action)
        node.runAction(repeataction)
        var constrain = SCNConstraint()
        let billboardConstraint = SCNBillboardConstraint()
        //Manually set the contraints to all instead of Y
        billboardConstraint.freeAxes = SCNBillboardAxis.all
        constrain = billboardConstraint
        node.constraints = [constrain]
        
        sceneViewLocation.addLocationNodeWithConfirmedLocation(locationNode: node, action: repeataction)
    }

    //MARK: - SearchBar
    
    func alterLayout() {
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = true // you can show/hide this dependant on your layout
        searchBar.sizeToFit()
    }
    
   func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        removeallNode()
        table.isHidden = false
        searchSpots = destination
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        table.isHidden = true
        searchBar.resignFirstResponder()//gets rid of keyboard
        if let mytextspots = searchSpots.first(where: {$0.label.lowercased() == searchBar.text!.lowercased()}){
            addpicobject(spots: mytextspots)
            addlabelAbove(spots: mytextspots)
            
        } else {
            print("no Picture was found")
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {searchSpots = destination
            table.reloadData()
            return}
        searchSpots = destination.filter({ (spots) -> Bool in
            return spots.label.lowercased().contains(searchText.lowercased())
        })
        table.reloadData()
    }
    
    //MARK: - Add all the nodes and make them move
        func selectednodestoPresent(){
        //assumtion of comparasion to 800meters
        for allnodes in pointsofIntrest{
         //turn list into object
            addpicobject(spots: allnodes)
            addlabelAbove(spots: allnodes)
            switch allnodes.intrest{
            case intrestPoints.ChicoState.rawValue:
                addchicoClasse()
                print("Added chico Classes")
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
    
    func removeallNode(){
        for indexNodes in sceneViewLocation.locationNodes {
            sceneViewLocation.removeLocationNode(locationNode: indexNodes)
        }
    }
    
    func comparedistance(spot1: CLLocation, spot2: CLLocation) -> Double {
        let distanceInMeters = spot1.distance(from: spot2)// Distance in Meters
        return distanceInMeters
    }
    
    //MARK: - Main points to determine location radius
    func addpointOfIntrest(){
        guard let currentposition = sceneViewLocation.currentLocation() else {
            return print("Current location not found")
        }
        let chicoState = Spots(laditude: 39.7297, longitude: -121.8447, altitude: 30, image: nil, name: "Chico State", elevation: 65, intrest: intrestPoints.ChicoState.rawValue)
        if comparedistance(spot1: chicoState.cllocation, spot2: currentposition) < 24000 {
            pointsofIntrest.append(chicoState)
            print("With in chico state")
        }
        let SDMesacollege = Spots(laditude: 32.8038, longitude: -117.1690, altitude: 50, mynode: spintop, name: "Mesa College", elevation: 104, intrest: intrestPoints.SanDiegoMesaCollege.rawValue)
        if comparedistance(spot1: SDMesacollege.cllocation, spot2: currentposition) < 800 {
            pointsofIntrest.append(SDMesacollege)}
        let home = Spots(laditude: 32.6990, longitude: -117.1160, altitude: 4, mynode: spintop, name: "home", elevation: 15, intrest: intrestPoints.Home.rawValue)
        if comparedistance(spot1: home.cllocation, spot2: currentposition) < 2000 {
            pointsofIntrest.append(home)}
        let balboaintrest = Spots(laditude: 32.7314, longitude: -117.1504, altitude: 15, mynode: spintop, name: "Balboa Park", elevation: 89, intrest: intrestPoints.BalboaMuseums.rawValue)
        if comparedistance(spot1: balboaintrest.cllocation, spot2: currentposition) < 24000 {
            pointsofIntrest.append(balboaintrest)}
    }
    
    
    //MARK: - Functions to Append into Destination
    
    func addchicoClasse(){
        let intrest = intrestPoints.ChicoState
        chicononclasse(intrest: intrest)
        //append to Destination
    }
    
    func addsandiegoMesaCollege(){
        //append to Destination
        
    }
    
    func addSDBalboaMuseums(){
        //append to Destination
        let intrest = intrestPoints.BalboaMuseums.rawValue
        let fountain = Spots(laditude: 32.7314, longitude: -117.1468, altitude: 2, mynode: spintop, name: "fountain", elevation: 89.0, intrest: intrest)
        destination.append(fountain)
        let ReubenHfleet = Spots(laditude: 32.7310, longitude: -117.1467, altitude: 10, mynode: spintop, name: "Science", elevation: 89, intrest: intrest)
        destination.append(ReubenHfleet)
        let nat = Spots(laditude: 32.7318, longitude: -117.1474, altitude: 15, mynode: spintop, name: "Natural", elevation: 89, intrest: intrest)
        destination.append(nat)
        let Zora = Spots(laditude: 32.7312, longitude: -117.1478, altitude: 0, mynode: spintop, name: "Zora", elevation: 76, intrest: intrest)
        destination.append(Zora)
        let SDhistory = Spots(laditude: 32.7313, longitude: -117.1483, altitude: -4, mynode: spintop, name: "SDhistory", elevation: 89, intrest: intrest)
        destination.append(SDhistory)
        let casadelPrado = Spots(laditude: 32.7317, longitude: -117.1486, altitude: -3, mynode: spintop, name: "Prado", elevation: 89, intrest: intrest)
        destination.append(casadelPrado)
        print("added Balboa markers")
    }
    
    
    //MARK: - Table Controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSpots.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableCell else{
            return UITableViewCell()
        }
        cell.label.text = searchSpots[indexPath.row].label
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchSpots = destination
        let cell = tableView.cellForRow(at: indexPath) as? TableCell
        let celltext = cell?.label.text
        table.isHidden = true
        searchBar.resignFirstResponder()//gets rid of keyboard
        if let mytextspots = searchSpots.first(where: {$0.label.lowercased() == celltext!.lowercased()}){
            searchBar.text = celltext
            addpicobject(spots: mytextspots)
            addlabelAbove(spots: mytextspots)
        } else {
            print("no Picture was found")
        }
    }
    
   /* func oconnellBuilding(intrest: intrestPoints){
    //add O'connell classes
        let elevation = 59.13
        let secondFloor = 10.0
        let thirdFloor = 20.0
        let fourthFloor = 30.0
        let OC124 = Spots(laditude: 39.7276, longitude: -121.8474, altitude: 0, mynode: spintop, name: "OCNL 124", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC124)
        let OC130 = Spots(laditude: 39.7275, longitude: -121.8476, altitude: 0, mynode: spintop, name: "OCNL 130", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC130)
        let OC131 = Spots(laditude: 39.7275, longitude: -121.8476, altitude: 0, mynode: spintop, name: "OCNL 131", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC131)
        let OC123 = Spots(laditude: 39.7277, longitude: -121.8475, altitude: 0, mynode: spintop, name: "OCNL 123", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC123)
        let OC121 = Spots(laditude: 39.7278, longitude: -121.8476, altitude: 0, mynode: spintop, name: "OCNL 121", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC121)
        let OC133 = Spots(laditude: 39.7277, longitude: -121.8477, altitude: 0, mynode: spintop, name: "OCNL 133", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC133)
        let OC119 = Spots(laditude: 39.7277, longitude: -121.8477, altitude: 0, mynode: spintop, name: "OCNL 119", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC119)
        let OC120 = Spots(laditude: 39.7278, longitude: -121.8476, altitude: 0, mynode: spintop, name: "OCNL 120", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC120)
        let OC136 = Spots(laditude: 39.7277, longitude: -121.8478, altitude: 0, mynode: spintop, name: "OCNL 136", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC136)
        
        //Second Floor
        let OC254 = Spots(laditude: 39.7277, longitude: -121.8478, altitude: secondFloor, mynode: spintop, name: "OCNL 254", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC254)
        let OC255 = Spots(laditude: 39.7276, longitude: -121.8477, altitude: secondFloor, mynode: spintop, name: "OCNL 255", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC255)
        let OC249 = Spots(laditude: 39.7276, longitude: -121.8476, altitude: secondFloor, mynode: spintop, name: "OCNL 249", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC249)
        let OC244 = Spots(laditude: 39.7275, longitude: -121.8477, altitude: secondFloor, mynode: spintop, name: "OCNL 244", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC244)
        let OC251 = Spots(laditude: 39.7276, longitude: -121.8477, altitude: secondFloor, mynode: spintop, name: "OCNL 251", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC251)
        let OC246 = Spots(laditude: 39.7276, longitude: -121.846, altitude: secondFloor, mynode: spintop, name: "OCNL 246", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC246)
        let OC247 = Spots(laditude: 39.7277, longitude: -121.845, altitude: secondFloor, mynode: spintop, name: "OCNL 247", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC247)
        let OC242 = Spots(laditude: 39.7275, longitude: -121.844, altitude: secondFloor, mynode: spintop, name: "OCNL 242", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC242)
        let OC241 = Spots(laditude: 39.7275, longitude: -121.844, altitude: secondFloor, mynode: spintop, name: "OCNL 241", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC241)
        let OC239 = Spots(laditude: 39.7274, longitude: -121.844, altitude: secondFloor, mynode: spintop, name: "OCNL 239", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC239)
        let OC237 = Spots(laditude: 39.7275, longitude: -121.843, altitude: secondFloor, mynode: spintop, name: "OCNL 237", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC237)
        //missing one class
        
        //third floor
        let OC334 = Spots(laditude: 39.7275, longitude: -121.844, altitude: thirdFloor, mynode: spintop, name: "OCNL 334", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC334)
        let OC337 = Spots(laditude: 39.7275, longitude: -121.844, altitude: thirdFloor, mynode: spintop, name: "OCNL 334", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC337)
        let OC338 = Spots(laditude: 39.7274, longitude: -121.844, altitude: thirdFloor, mynode: spintop, name: "OCNL 338", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC338)
        let OC339 = Spots(laditude: 39.7275, longitude: -121.845, altitude: thirdFloor, mynode: spintop, name: "OCNL 339", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC339)
        let OC344 = Spots(laditude: 39.7276, longitude: -121.846, altitude: thirdFloor, mynode: spintop, name: "OCNL 344", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC344)
        let OC340 = Spots(laditude: 39.7276, longitude: -121.845, altitude: thirdFloor, mynode: spintop, name: "OCNL 340", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC340)
        let OC342 = Spots(laditude: 39.7276, longitude: -121.845, altitude: thirdFloor, mynode: spintop, name: "OCNL 342", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC342)
        let OC345 = Spots(laditude: 39.7277, longitude: -121.847, altitude: thirdFloor, mynode: spintop, name: "OCNL 345", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC345)
        let OC346 = Spots(laditude: 39.7277, longitude: -121.848, altitude: thirdFloor, mynode: spintop, name: "OCNL 346", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC346)
        let OC343 = Spots(laditude: 39.7277, longitude: -121.846, altitude: thirdFloor, mynode: spintop, name: "OCNL 343", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC343)
        let OC347 = Spots(laditude: 39.7278, longitude: -121.847, altitude: thirdFloor, mynode: spintop, name: "OCNL 347", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC347)
        let OC304 = Spots(laditude: 39.7278, longitude: -121.848, altitude: thirdFloor, mynode: spintop, name: "OCNL 304", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC304)
        let OC312 = Spots(laditude: 39.7278, longitude: -121.848, altitude: thirdFloor, mynode: spintop, name: "OCNL 312", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC312)
        
        //Fourth Floor
        let OC419 = Spots(laditude: 39.7278, longitude: -121.845, altitude: fourthFloor, mynode: spintop, name: "OCNL 419", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC419)
        let OC438 = Spots(laditude: 39.7276, longitude: -121.846, altitude: fourthFloor, mynode: spintop, name: "OCNL 438", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC438)
        let OC431 = Spots(laditude: 39.7278, longitude: -121.848, altitude: fourthFloor, mynode: spintop, name: "OCNL 431", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC431)
        let OC432 = Spots(laditude: 39.7278, longitude: -121.847, altitude: fourthFloor, mynode: spintop, name: "OCNL 432", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC432)
        let OC436 = Spots(laditude: 39.7278, longitude: -121.847, altitude: fourthFloor, mynode: spintop, name: "OCNL 436", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC436)
        let OC434 = Spots(laditude: 39.7278, longitude: -121.847, altitude: fourthFloor, mynode: spintop, name: "OCNL 434", elevation: elevation, intrest: intrest.rawValue)
        destination.append(OC434)
}*/
    
    func chicononclasse(intrest: intrestPoints){
        let elevation = 59.13
        let soccerstadium = Spots(laditude: 39.7322, longitude: -121.8539, altitude: 10 , mynode: spintop, name: "Soccer Stadium", elevation: elevation, intrest: intrest.rawValue)
        destination.append(soccerstadium)
        let baseballfield = Spots(laditude: 39.7304, longitude: -121.8536, altitude: 10, mynode: spintop, name: "Nettleton Stadium ", elevation: elevation, intrest: intrest.rawValue)
        destination.append(baseballfield)
        let trackfield = Spots(laditude: 39.7301, longitude: -121.8510, altitude: 10, mynode: spintop, name: "Track and Field", elevation: elevation, intrest: intrest.rawValue)
        destination.append(trackfield)
        let soccertraining = Spots(laditude: 39.7295, longitude: -121.8523, altitude: 10, mynode: spintop, name: "Soccer Training", elevation: elevation, intrest: intrest.rawValue)
        destination.append(soccertraining)
        let tennis = Spots(laditude: 39.7288, longitude: -121.8509, altitude: 10, mynode: spintop, name: "Tennis Courts", elevation: elevation, intrest: intrest.rawValue)
        destination.append(tennis)
        let sutterCafe = Spots(laditude: 39.7301, longitude: -121.8490, altitude: 10, mynode: spintop, name: "Sutter Cafe", elevation: elevation, intrest: intrest.rawValue)
        destination.append(sutterCafe)
        let sutterHall = Spots(laditude: 39.7308, longitude: -121.8485, altitude: 10, mynode: spintop, name: "Sutter Hall", elevation: elevation, intrest: intrest.rawValue)
        destination.append(sutterHall)
        let theHub = Spots(laditude: 39.7314, longitude: -121.8478, altitude: 10, mynode: spintop, name: "The Hub", elevation: elevation, intrest: intrest.rawValue)
        destination.append(theHub)
        let shurmerGym = Spots(laditude: 39.7291, longitude: -121.8490, altitude: 10, mynode: spintop, name: "Shurmer Gym - SGYM", elevation: elevation, intrest: intrest.rawValue)
        destination.append(shurmerGym)
        let wildcatStore = Spots(laditude: 39.7279, longitude: -121.8453, altitude: 10, mynode: spintop, name: "Wildcat Store", elevation: elevation, intrest: intrest.rawValue)
        destination.append(wildcatStore)
        let commonGrounds = Spots(laditude: 39.7280, longitude: -121.8450, altitude: 10, mynode: spintop, name: "Common Grounds", elevation: elevation, intrest: intrest.rawValue)
        destination.append(commonGrounds)
        let atm = Spots(laditude: 39.7283, longitude: -121.8450, altitude: 10, mynode: spintop, name: "ATM", elevation: elevation, intrest: intrest.rawValue)
        destination.append(atm)
        let laxon = Spots(laditude: 39.7298, longitude: -121.8438, altitude: 10, mynode: spintop, name: "Laxson Hall", elevation: elevation, intrest: intrest.rawValue)
        destination.append(laxon)
        let meriamlibrary = Spots(laditude: 39.7281, longitude: -121.8462, altitude: 10, mynode: spintop, name: "Meriam Library MLIB", elevation: elevation, intrest: intrest.rawValue)
        destination.append(meriamlibrary)
        let wrec = Spots(laditude: 39.7263, longitude: -121.8476, altitude: 10, mynode: spintop, name: "Wildcat Recreation Center - WREC", elevation: elevation, intrest: intrest.rawValue)
        destination.append(wrec)
        let konkoHall = Spots(laditude: 39.7329, longitude: -121.853157, altitude: 10, mynode: spintop, name: "Konkow Hall", elevation: elevation, intrest: intrest.rawValue)
        destination.append(konkoHall)
        let mechopda = Spots(laditude: 39.732746, longitude: -121.853128, altitude: 10, mynode: spintop, name: "Mechoopda Hall", elevation: elevation, intrest: intrest.rawValue)
        destination.append(mechopda)
        let esken = Spots(laditude: 39.731879, longitude: -121.852549, altitude: 10, mynode: spintop, name: "Esken Hall", elevation: elevation, intrest: intrest.rawValue)
        destination.append(esken)
        let healthCenter = Spots(laditude: 39.730672, longitude: -121.850306, altitude: 10, mynode: spintop, name: "Student Health Center - SHC", elevation: elevation, intrest: intrest.rawValue)
        destination.append(healthCenter)
        let ackerGym = Spots(laditude: 39.729884, longitude: -121.849726, altitude: 10, mynode: spintop, name: "Acker Gym - AGYM", elevation: elevation, intrest: intrest.rawValue)
        destination.append(ackerGym)
        let whitneyHall = Spots(laditude: 39.730516, longitude: -121.848981, altitude: 10, mynode: spintop, name: "Whitney Hall", elevation: elevation, intrest: intrest.rawValue)
        destination.append(whitneyHall)
        let tehamaHall = Spots(laditude: 39.729936, longitude: -121.848609, altitude: 10, mynode: spintop, name: "Tehama Hall - THMA", elevation: elevation, intrest: intrest.rawValue)
        destination.append(tehamaHall)
        let yoloHall = Spots(laditude: 39.728701, longitude: -121.849941, altitude: 10, mynode: spintop, name: "Yolo Hall", elevation: elevation, intrest: intrest.rawValue)
        destination.append(yoloHall)
        let plumasHall = Spots(laditude: 39.729706, longitude: -121.848239, altitude: 10, mynode: spintop, name: "Plumas Hall PLMS", elevation: elevation, intrest: intrest.rawValue)
        destination.append(plumasHall)
        let butteHall = Spots(laditude: 39.729978, longitude: -121.847296, altitude: 10, mynode: spintop, name: "Butte Hall - BUTE", elevation: elevation, intrest: intrest.rawValue)
        destination.append(butteHall)
        let lassenHall = Spots(laditude: 39.730532, longitude: -121.847363, altitude: 10, mynode: spintop, name: "Lassen Hall", elevation: elevation, intrest: intrest.rawValue)
        destination.append(lassenHall)
        let shastaHall = Spots(laditude: 39.731107, longitude: -121.847760, altitude: 10, mynode: spintop, name: "Shasta Hall", elevation: elevation, intrest: intrest.rawValue)
        destination.append(shastaHall)
        let holtHall = Spots(laditude: 39.730949, longitude: -121.845309, altitude: 10, mynode: spintop, name: "Holt Hall", elevation: elevation, intrest: intrest.rawValue)
        destination.append(holtHall)
        let creeksidecafe = Spots(laditude: 39.729976, longitude: -121.845225, altitude: 10, mynode: spintop, name: "Creakside Cafe", elevation: elevation, intrest: intrest.rawValue)
        destination.append(creeksidecafe)
        let janetturnerprintmuseum = Spots(laditude: 39.729551, longitude: -121.845628, altitude: 10, mynode: spintop, name: "Janet Turner Print Museum", elevation: elevation, intrest: intrest.rawValue)
        destination.append(janetturnerprintmuseum)
        let GlenHall = Spots(laditude: 39.729127, longitude: -121.846319, altitude: 10, mynode: spintop, name: "Glenn Hall - GLNN", elevation: elevation, intrest: intrest.rawValue)
        destination.append(GlenHall)
        let roseGarden = Spots(laditude: 39.729114, longitude: -121.845878, altitude: 10, mynode: spintop, name: "Rose Garden", elevation: elevation, intrest: intrest.rawValue)
        destination.append(roseGarden)
        let trinityHall = Spots(laditude: 39.729114, longitude: -121.845878, altitude: 10, mynode: spintop, name: "Trinity Hall - TRNT", elevation: elevation, intrest: intrest.rawValue)
        destination.append(trinityHall)
        let bellMemorial = Spots(laditude: 39.7280, longitude: -121.8449, altitude: 10, mynode: spintop, name: "Bell Memorial Union - BMU", elevation: elevation, intrest: intrest.rawValue)
        destination.append(bellMemorial)
        let anthropologyMuseum = Spots(laditude: 39.728185, longitude: -121.846129, altitude: 10, mynode: spintop, name: "Valene L. Smith Museum of Anthropology", elevation: elevation, intrest: intrest.rawValue)
        destination.append(anthropologyMuseum)
        let oconnellcenter = Spots(laditude: 39.727558, longitude: -121.847423, altitude: 10, mynode: spintop, name: "O'Connell Center - OCNL", elevation: elevation, intrest: intrest.rawValue)
        destination.append(oconnellcenter)
        let langdonEngineering = Spots(laditude: 39.727191, longitude: -121.847460, altitude: 10, mynode: spintop, name: "Langdon Engineering Center - LANG", elevation: elevation, intrest: intrest.rawValue)
        destination.append(langdonEngineering)
        let performingArtsCenter = Spots(laditude: 39.7285, longitude: -121.8439, altitude: 10, mynode: spintop, name: "Performing Arts Center - PAC", elevation: elevation, intrest: intrest.rawValue)
        destination.append(performingArtsCenter)
        let artsAndHumanities = Spots(laditude: 39.729111, longitude: -121.843179, altitude: 10, mynode: spintop, name: "Arts and Humanities - ARTS", elevation: elevation, intrest: intrest.rawValue)
            destination.append(artsAndHumanities)
        let paulandYasukoZingg = Spots(laditude: 39.728500, longitude: -121.844066, altitude: 10, mynode: spintop, name: "Paul and Yasuko Zingg Recital Hall", elevation: elevation, intrest: intrest.rawValue)
            destination.append(paulandYasukoZingg)
        let colusa = Spots(laditude: 39.729587, longitude: -121.845732, altitude: 10, mynode: spintop, name: "Colusa Hall - CLSA", elevation: elevation, intrest: intrest.rawValue)
            destination.append(colusa)
        let universityVillage = Spots(laditude: 39.7313, longitude: -121.8636, altitude: 10, mynode: spintop, name: "University Village", elevation: elevation, intrest: intrest.rawValue)
        destination.append(universityVillage)
        let modochall = Spots(laditude: 39.73233, longitude: -121.84496, altitude: 10, mynode: spintop, name: "Modoc Hall - MODC", elevation: elevation, intrest: intrest.rawValue)
        destination.append(modochall)
        let childdevelop = Spots(laditude: 39.73297, longitude: -121.84474, altitude: 10, mynode: spintop, name: "Aymer J. Hamilton Building - AJH", elevation: elevation, intrest: intrest.rawValue)
            destination.append(childdevelop)
        let parkingG1 = Spots(laditude: 39.7309, longitude: -121.8522, altitude: 10, mynode: spintop, name: "G1 Parking", elevation: elevation, intrest: intrest.rawValue)
        destination.append(parkingG1)
        let parkingG2 = Spots(laditude: 39.7263, longitude: -121.8494, altitude: 10, mynode: spintop, name: "G2 Parking", elevation: elevation, intrest: intrest.rawValue)
        destination.append(parkingG2)
        let parkingG3 = Spots(laditude: 39.7248, longitude: -121.8476, altitude: 10, mynode: spintop, name: "G3 Parking", elevation: elevation, intrest: intrest.rawValue)
        destination.append(parkingG3)
        let parkingG4 = Spots(laditude: 39.7251, longitude: -121.8470, altitude: 10, mynode: spintop, name: "G4 Parking", elevation: elevation, intrest: intrest.rawValue)
        destination.append(parkingG4)
        let parkingG5 = Spots(laditude: 39.7267, longitude: -121.8468, altitude: 20, mynode: spintop, name: "G5 Parking", elevation: elevation, intrest: intrest.rawValue)
        destination.append(parkingG5)
        let parkingG7 = Spots(laditude: 39.7272, longitude: -121.8441, altitude: 10, mynode: spintop, name: "G7 Parking", elevation: elevation, intrest: intrest.rawValue)
        destination.append(parkingG7)
        let parkingG8 = Spots(laditude: 39.7312, longitude: -121.8508, altitude: 10, mynode: spintop, name: "G8 Parking", elevation: elevation, intrest: intrest.rawValue)
        destination.append(parkingG8)
        let studentServicesBuilding = Spots(laditude: 39.7270, longitude: -121.8457, altitude: 10, mynode: spintop, name: "Student Services Center - SSC", elevation: elevation, intrest: intrest.rawValue)
        destination.append(studentServicesBuilding)
        let physcialScience = Spots(laditude: 39.7310, longitude: -121.8433, altitude: 10, mynode: spintop, name: "Physical Science Building - PHSC", elevation: elevation, intrest: intrest.rawValue)
        destination.append(physcialScience)
        let ayrelshall = Spots(laditude: 39.7305, longitude: -121.8435, altitude: 10, mynode: spintop, name: "Ayres Hall - AYRS", elevation: elevation, intrest: intrest.rawValue)
        destination.append(ayrelshall)
        let kendallHall = Spots(laditude: 39.729671, longitude: -121.844825, altitude: 10, mynode: spintop, name: "Kendal Hall", elevation: elevation, intrest: intrest.rawValue)
        destination.append(kendallHall)
        
        
    }
    
    
}


