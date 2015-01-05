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
        // Aufgabe - anzulegenden Punkt an bisherige Locations anfügen
        
        var saveStr = ""
        
        //DEBUG: Anzahl zu speichernder Punkte überprüfen
        //println("Anzahl zu speichernder Punkte: \(Locations.count)")
        
        // Aufgabe - Schleife um Locations auseinander zu fuddeln & als String speichern
        // Hinweis: dazu die Seperatoren benutzen
        
        // Aufgabe - von iOS einen Pfad als String zum speichern geben lassen
        
        // Aufgabe - Dateinamen anhängen
        let path = dirs?[0].
        
        
        //DEBUG: um sich Pfad anschauen zu können - extern drauf zugreifen kann man eh nicht
        //println("path: \(path)")
        
        if (path != nil) {
            saveStr.writeToFile(path!, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
            //DEBUG: damit man sich den gespeicherten String nochmal anschauen kann
            //println("Daten \"\(saveStr)\" geschrieben.")
        }
    }
    
    class func loadLocations() {
        var loadedStr: String
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        // Aufgabe - den selben Dateinamen zum laden auch wieder anfügen
        
        //DEBUG: um sich Pfad anschauen zu können - extern drauf zugreifen kann man eh nicht
        //println("path: \(path)")
        
        var checkValidation = NSFileManager.defaultManager()
        
        //Datei überprüfen ob vorhanden
        if (checkValidation.fileExistsAtPath(path!)) {
            loadedStr = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)!
            
            //die Punkte trennen und ihre Eigenschaften als Array speichern
            let splittedLocations = split(loadedStr, {$0=="#"})
            
            // Aufgabe - die Punkte in ihre Bestandteile aufteilen & in die jeweiligen Werte des Location Structs schreiben & die Sammlung aller Punkte (Locations) befüllen
            
            }
            //DEBUG: um sich den geladenen String anzusehen
//            println("\"\(loadedStr)\" geladen");
        }
        
        else {
            println("Laden fehlgeschlagen")
        }
        
        //DEBUG: Anzahl geladener Punkte ausgeben
        //println("Anzahl geladener Punkte: \(Locations.count)")
        
    }
    
    // um extern die Sammlung aller Punkte zu bekommen
    class func getLocations() -> [Location] {
        return Locations
    }
}