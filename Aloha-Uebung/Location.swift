//
//  Location.swift
//  Aloha-Uebung
//
//  Created by Medien on 03.01.15.
//  Copyright (c) 2015 Medien. All rights reserved.
//

import Foundation

// Hier sind keine Änderungen notwendig
public struct Location {
    //ID bestehend aus der Koordinate
    var lat: NSNumber
    var long: NSNumber
    //Name des Punkts
    var name: String
    
    init() {
        lat = 0
        long = 0
        name = ""
    }
}