//
//  LocationEditorView.swift
//  Aloha-Uebung
//
//  Created by chucha on 03.01.15.
//  Copyright (c) 2015 Medien. All rights reserved.
//

import UIKit

// Aufgabe - Delegate Funktion
protocol SpotMarkerDelegate {
    func createNewSpotDidFinish(controller: LocationEditorView, coords: CLLocationCoordinate2D)
}


class LocationEditorView: UIViewController {

    var spotDelegate: SpotMarkerDelegate? = nil
    
    var nuPunkt = Location()
    var me :Int = -1
    
    // Aufgabe - Zugriff auf die UI-Elemente gewährleisten
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // falls der Punkt schon besteht, diesen Laden statt eines neuen anzulegen
        for var i:Int=0; i < Locations.count; i++ {
            if (Locations[i].lat == self.coords.latitude && Locations[i].long == self.coords.longitude) {
                nuPunkt = Locations[i]
                me = i
            }
        }
        
        println("aktueller Punkt: \(nuPunkt.name)")
        println("Koordinaten des Punktes: \(nuPunkt.lat) | \(nuPunkt.long)")
        println("aktuelle Koordinaten \(self.coords.latitude) | \(self.coords.longitude)")
        
        self..text = getAdress(coords)
        self..text = nuPunkt.name
    }
    
    // Aufgabe: Datentransfer mittels Delegate
    @IBAction func saveBTNaction(sender: UIButton) {
        // erst mal Daten speichern
        nuPunkt.lat = self.coords.latitude
        nuPunkt.long = self.coords.longitude
        
        // falls der Punkt keinen Namen bekommen hat!
        if countElements(self..text) == 0 {
            //workaround um die Daten valide zu halten
//            println("Name ist leer!")
            nuPunkt.name = " "
        }
        else {
            nuPunkt.name = self..text
        }
        
        // falls bestehender Punkt gespeichert wird, den alten vorher entfernen -> sonst lauter Duplikate
        if me >= 0 {
            Locations.removeAtIndex(me)
            me = -1
        }
        // alle Punkte persistent speichern
        Vault.saveLocation(nuPunkt)
        
        if (spotDelegate != nil) {
            spotDelegate!.createNewSpotDidFinish(self, coords: coords)
        }
        
    }
    
    // wird gestellt
    @IBAction func abortBTNaction(sender: UIButton) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewController") as MapViewController
        navigationController?.popViewControllerAnimated(true)
    }
    
    var coords: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)
    
    // GeoCoordinate wieder als Adresse repräsentieren
    func getAdress(coord: CLLocationCoordinate2D) -> String{
        let geocoder = GMSGeocoder()
        
        
        var newAddress: String = "Adresse wird geladen"
        // Aufgabe - Funktion finden um die Adresse aus den Koordinaten wiederherstellen
        geocoder.(coord) { response , error in
            
            if let address = response?.firstResult() {
                let lines = address.lines as [String]
                newAddress = join(" ", lines)
                self..text = newAddress
            }
        }
        
        return newAddress
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
