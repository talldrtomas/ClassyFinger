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
        destination.append(contentsOf: multiplelocations.destinations)
        for mylocations in destination{
           // if mylocations.image != nil{
                addPicture(laditude: mylocations.laditude, longitude: mylocations.longitude, altitude: mylocations.altitude, image: mylocations.image!)
//            }
  //          if mylocations.node != nil{
                guard let myscene = SCNScene(named: "art.scnassets/SceneKit Scene 2.scn") else {
                    return print("No scene Found")}
                guard let mynodeo = myscene.rootNode.childNode(withName: "cone", recursively: true) else {
                    return print("No Pin found")}
                addobject(mynode: mynodeo, laditude: 32.6990, longitude: -117.1160, altitude: 4)
            
           // }
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
    
    func addpicobject(laditude: Double, longitude: Double, altitude: Double, image: String?, tnode: SCNNode?){
        let coordinate = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude + 65.00)
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
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchSpots = destination.filter({ (spots) -> Bool in
            switch searchBar.selectedScopeButtonIndex{
            case 0:
                if searchText.isEmpty{return true}
                let identifier = searchSpots[searchBar.selectedScopeButtonIndex]
                
                addobject(mynode: identifier.node!, laditude: identifier.laditude, longitude: identifier.longitude, altitude: identifier.altitude)

                
                return spots.label.lowercased().contains(searchText.lowercased())
                
            default:
                return false
                
            }
            
        })
    }
    
    
    
}

