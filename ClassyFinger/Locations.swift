//
//  Locations.swift
//  
//
//  Created by Tomas Galvan-Huerta on 12/31/18.
//

import Foundation
import ARKit
import CoreLocation
let world = "high"

class Spots: NSObject, ARSCNViewDelegate {
    let laditude: Double
    let longitude:Double
    let altitude: Double
    let image: String?
    let node: SCNNode?
    let label: String
    let elevation: Double
    let cllocation: CLLocation
    let intrest: String
    
    
    init(laditude: Double, longitude: Double, altitude: Double, image: String?, name: String, elevation: Double, intrest: String) {
        self.laditude = laditude
        self.longitude = longitude
        self.altitude = altitude
        self.image  = image
        self.label = name
        self.elevation = elevation
        self.node = nil
        self.cllocation = CLLocation(latitude: self.laditude, longitude: self.longitude)
        self.intrest = intrest
    }
    init(laditude: Double, longitude: Double, altitude: Double, mynode: SCNNode?, name: String, elevation: Double, intrest: String) {
        self.laditude = laditude
        self.longitude = longitude
        self.altitude = altitude
        self.node  = mynode
        self.label = name
        self.image = nil
        self.elevation = elevation
        self.cllocation = CLLocation(latitude: self.laditude, longitude: self.longitude)
        self.intrest = intrest
    
}
    
    
    
    }






