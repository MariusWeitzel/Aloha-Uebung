//
//  Vault.swift
//  Aloha-Uebung
//
//  Created by Medien on 03.01.15.
//  Copyright (c) 2015 Medien. All rights reserved.
//

import Foundation

//surfSpots voneinander trennen
let spotSeperator = "#"
//SpotEigenschaften voneinander trennen
let spotItemSeperator = "|"

// Sammlung aller Punkte
var Locations = [Location]()

class Vault: UIViewController {
    
    class func saveLocation(punkt: Location) {
        // anzulegenden Punkt an bisherige Locations anfügen
        Locations.append(punkt)
        var saveStr = ""
        
        println("Anzahl zu speichernder Punkte: \(Locations.count)")
        
        // Locations auseinander fuddeln
        for spot in Locations {
            //ID aus Längen- und Breitengrad
            saveStr += spot.lat.stringValue + spotItemSeperator
            saveStr += spot.long.stringValue + spotItemSeperator
            
            //der Name
            saveStr += spot.name + spotItemSeperator
            
            // zum trennen der Punkte
            saveStr += spotSeperator;
        }
        
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        let path = dirs?[0].stringByAppendingPathComponent("locations.csv")
        
        //DEBUG: um sich Pfad anschauen zu können - extern drauf zugreifen kann man eh nicht
        //println("path: \(path)")
        
        if (path != nil) {
            saveStr.writeToFile(path!, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
            //DEBUG: damit man sich den gespeicherten String nochmal anschauen kann
            println("Daten \"\(saveStr)\" geschrieben.")
        }
    }
    
    class func loadLocations() {
        var loadedStr: String
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        let path = dirs?[0].stringByAppendingPathComponent("locations.csv")
        
        //DEBUG: um sich Pfad anschauen zu können - extern drauf zugreifen kann man eh nicht
        //println("path: \(path)")
        
        var checkValidation = NSFileManager.defaultManager()
        
        //Datei überprüfen ob vorhanden
        if (checkValidation.fileExistsAtPath(path!)) {
            loadedStr = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)!
            
            //die Punkte trennen und ihre Eigenschaften als Array speichern
            let splittedLocations = split(loadedStr, {$0=="#"})
            
            for location in splittedLocations {
                var pointItems = split(location, {$0=="|"})
                var nuPunkt = Location()
                
                nuPunkt.lat = NSNumberFormatter().numberFromString(pointItems[0])!
                nuPunkt.long = NSNumberFormatter().numberFromString(pointItems[1])!
                
                nuPunkt.name = pointItems[2]
                
                //den geladenen Punkt an die Sammlung wieder anfügen
                Locations.append(nuPunkt)
            }
            //DEBUG: um sich den geladenen String anzusehen
//            println("\"\(loadedStr)\" geladen");
        }
        
        else {
            println("Laden fehlgeschlagen")
        }
        
        //DEBUG: Anzahl geladener Punkte ausgeben
        println("Anzahl geladener Punkte: \(Locations.count)")
        
    }
    
    // um extern die Sammlung aller Punkte zu bekommen
    class func getLocations() -> [Location] {
        return Locations
    }
}