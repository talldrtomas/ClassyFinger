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
    let image: String?
    let node: SCNNode?
    let label: String
    let elevation: Double
    
    
    init(laditude: Double, longitude: Double, altitude: Double, image: String?, name: String, elevation: Double) {
        self.laditude = laditude
        self.longitude = longitude
        self.altitude = altitude
        self.image  = image
        self.label = name
        self.elevation = elevation
        self.node = nil
    }
    init(laditude: Double, longitude: Double, altitude: Double, mynode: SCNNode?, name: String, elevation: Double) {
        self.laditude = laditude
        self.longitude = longitude
        self.altitude = altitude
        self.node  = mynode
        self.label = name
        self.image = nil
        self.elevation = elevation
    
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
    
    var destinations = [Spots(laditude: 32.7636, longitude: -117.1216
        , altitude: 5.0, image: "mario", name: "Starbucks", elevation: 121), Spots(laditude: 32.7635, longitude: -117.1222, altitude: 5.0, image: "butterfly", name: "HairStudio", elevation: 121), Spots(laditude: 32.7635, longitude: -117.1220, altitude: 5.0, image: "heart", name: "BottleShop", elevation: 121),Spots(laditude: 32.7632, longitude: -117.1219, altitude: 1.5, image: "Homer", name: "Column", elevation: 121), Spots(laditude: 32.7175, longitude: -117.1408, altitude: 1.5, image: "Homer", name: "Krakatoa", elevation: 65.00), Spots(laditude: 32.7308, longitude: -117.1470, altitude: 30, image: "Homer", name: "Science Museum", elevation: 15)]
    
   // var test = [ARobject(laditude: 312.3, longitude: 32.3, node: SCNNODE, altitude: 21331, name: "homer")]
    
}



