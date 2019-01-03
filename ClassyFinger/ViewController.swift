//
//  ViewController.swift
//  ClassyFinger
//
//  Created by Tomas Galvan-Huerta on 11/14/18.
//  Copyright © 2018 Somat. All rights reserved.
// Create Museum points (sammy)
// Place 
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
    
    
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var sceneView: ARSCNView!

    //Mark: Loading ontoo phone
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneViewLocation.orientToTrueNorth = false
        trianglenode()
        destination.append(contentsOf: multiplelocations.destinations)
        
        for mylocations in destination{
           // if mylocations.image != nil{
                addpicobject(laditude: mylocations.laditude, longitude: mylocations.longitude, altitude: mylocations.altitude, image: mylocations.image, tnode: mylocations.node, elevation: mylocations.elevation)

        }
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
    
    func addpicobject(laditude: Double, longitude: Double, altitude: Double, image: String?, tnode: SCNNode?, elevation: Double){
        let coordinate = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude + elevation)
        if image != nil{
            let imagename = image!
            guard let image = UIImage(named: imagename)else {
                return print("Did not find image") }
            let annotationNode = LocationAnnotationNode(location: location, image: image)
            sceneViewLocation.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
            annotationNode.scaleRelativeToDistance = true
        }
        if tnode != nil{
            let node = LocationNode(location: location)
            node.geometry = tnode!.geometry
            sceneViewLocation.addLocationNodeWithConfirmedLocation(locationNode: node)

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
    for indexNodes in sceneViewLocation.locationNodes {
        sceneViewLocation.removeLocationNode(locationNode: indexNodes)
    
    }
    
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let mytextspots = destination.first(where: {$0.label.lowercased() == searchBar.text!.lowercased()}) {
            // it exists, do something
            addpicobject(laditude: mytextspots.laditude, longitude: mytextspots.longitude, altitude: mytextspots.altitude, image: mytextspots.image, tnode: mytextspots.node, elevation: mytextspots.elevation)
        } else {
            print("no Picture was found")
        }
    }
    
   /* func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchSpots = destination.filter({ (spots) -> Bool in
            switch searchBar.selectedScopeButtonIndex{
            case 0:
                if searchText.isEmpty{return true}
                let identifier = searchSpots[searchBar.selectedScopeButtonIndex]
                
                addpicobject(laditude: identifier.laditude, longitude: identifier.longitude, altitude: identifier.altitude, image: identifier.image, tnode: identifier.node, elevation: identifier.elevation)

                return spots.label.lowercased().contains(searchText.lowercased())
                
            default:
                return false
                
            }
            
        })
    }*/
    //MARK: Add all the nodes and make them move
    //make the Parent node the
    
    func trianglenode(){
        let myscene = SCNScene(named: "art.scnassets/SceneKit Scene 2.scn")
        let mynodeo = myscene!.rootNode.childNode(withName: "cone", recursively: true)
        let rotate = SCNAction()
        
        mynodeo?.runAction(rotate)
        let triangle = Spots(laditude: 32.6990, longitude: -117.1160, altitude: 4, mynode: mynodeo, name: "home", elevation: 15)
        destination.append(triangle)
        
       
    }
    
    
}

