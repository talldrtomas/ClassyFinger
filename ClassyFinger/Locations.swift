//
//  Locations.swift
//  
//
//  Created by Tomas Galvan-Huerta on 12/31/18.
//

import Foundation
import ARKit
import CoreLocation

class Spots: NSObject, ARSCNViewDelegate {
    let laditude: Double
    let longitude:Double
    let altitude: Double
    let image: String?
    let node: SCNNode?
    let label: String
    let elevation: Double
    let cllocation: CLLocation
    
    
    init(laditude: Double, longitude: Double, altitude: Double, image: String?, name: String, elevation: Double) {
        self.laditude = laditude
        self.longitude = longitude
        self.altitude = altitude
        self.image  = image
        self.label = name
        self.elevation = elevation
        self.node = nil
        self.cllocation = CLLocation(latitude: self.laditude, longitude: self.longitude)
    }
    init(laditude: Double, longitude: Double, altitude: Double, mynode: SCNNode?, name: String, elevation: Double) {
        self.laditude = laditude
        self.longitude = longitude
        self.altitude = altitude
        self.node  = mynode
        self.label = name
        self.image = nil
        self.elevation = elevation
        self.cllocation = CLLocation(latitude: self.laditude, longitude: self.longitude)
    
}
    
    }


class Locations: NSObject{
    /*
     starbucks
     HairStudio
     BottleShop
     Column
     Krakatoa
     Science Museum
 */
    
    var destinations = [Spots]()
    var pointsofIntrest = [Spots]()

    func trianglenode(){
//        let myscene = SCNScene(named: "art.scnassets/SceneKit Scene 2.scn")
//       let spintop = myscene!.rootNode.childNode(withName: "cone", recursively: true)
//        let longmarjer = myscene!.rootNode.childNode(withName: "capsule", recursively: true)
        
        
    }
    func addpointOfIntrest(){
        let myscene = SCNScene(named: "art.scnassets/SceneKit Scene 2.scn")
        let spintop = myscene!.rootNode.childNode(withName: "cone", recursively: true)
        let longmarker = myscene!.rootNode.childNode(withName: "capsule", recursively: true)
       let chicoState = Spots(laditude: 39.7297, longitude: -121.8447, altitude: 30, image: nil, name: "Chico State", elevation: 65)
        pointsofIntrest.append(chicoState)
        let SDMesacollege = Spots(laditude: 32.8038, longitude: -117.1690, altitude: 50, mynode: longmarker, name: "Mesa College", elevation: 104)
        pointsofIntrest.append(SDMesacollege)
        let triangle = Spots(laditude: 32.6990, longitude: -117.1160, altitude: 4, mynode: spintop, name: "home", elevation: 15)
        pointsofIntrest.append(triangle)
    }
    
    
    func addchicoClasse(){
        
    }
    
    func addSDBalboaMuseums(){
        
    }
    
    
    
}



