//
//  Locations.swift
//  
//
//  Created by Tomas Galvan-Huerta on 12/31/18.
//

import Foundation
import ARKit

class Spots: NSObject, ARSCNViewDelegate {
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
    }}
class ARobject: NSObject{
    let laditude: Double
    let longitude:Double
    let altitude: Double
    let label: String
    let node: SCNNode
    
    init(laditude: Double, longitude: Double, mynode: SCNNode, altitude: Double, name: String) {
        self.laditude = laditude
        self.longitude = longitude
        self.altitude = altitude
        self.label = name
        self.node = mynode
        }}

class Locations: NSObject{
    
    var destinations = [Spots(laditude: 32.7636, longitude: -117.1216
        , altitude: 5.0, image: "mario", name: "Starbucks"), Spots(laditude: 32.7635, longitude: -117.1222, altitude: 5.0, image: "butterfly", name: "HairStudio"), Spots(laditude: 32.7635, longitude: -117.1220, altitude: 5.0, image: "heart", name: "BottleShop"),Spots(laditude: 32.7632, longitude: -117.1219, altitude: 1.5, image: "Homer", name: "Column"), Spots(laditude: 32.7175, longitude: -117.1408, altitude: 1.5, image: "Homer", name: "Krakatoa"), Spots(laditude: 32.7308, longitude: -117.1470, altitude: 30, image: "Homer", name: "Science Museum")]
   // var test = [ARobject(laditude: 312.3, longitude: 32.3, node: SCNNODE, altitude: 21331, name: "homer")]
    
}



