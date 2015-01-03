//
//  LocationEditorView.swift
//  Aloha-Uebung
//
//  Created by chucha on 03.01.15.
//  Copyright (c) 2015 Medien. All rights reserved.
//

import UIKit

// Aufgabe: Delegate Funktion selber schreiben mit diesen Parametern
protocol SpotMarkerDelegate {
    func createNewSpotDidFinish(controller: LocationEditorView, coords: CLLocationCoordinate2D)
}


class LocationEditorView: UIViewController {

    var spotDelegate: SpotMarkerDelegate? = nil
    
    var nuPunkt = Location()
    
    //Verbindung zu den UI-Elementen als Aufgabe
    
    @IBOutlet weak var adressTextLabel: UILabel!

    @IBOutlet weak var spotNameTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for spot in Locations {
            if (spot.lat == self.coords.latitude && spot.long == self.coords.longitude) {
                nuPunkt = spot
            }
        }
        
        println("aktueller Punkt: \(nuPunkt.name)")
        println("Koordinaten des Punktes: \(nuPunkt.lat) | \(nuPunkt.long)")
        println("aktuelle Koordinaten \(self.coords.latitude) | \(self.coords.longitude)")
        
        self.adressTextLabel.text = getAdress(coords)
        spotNameTf.text = nuPunkt.name
    }
    
    // Aufgabe: Datentransfer mittels Delegate
    @IBAction func saveBTNaction(sender: UIButton) {
        // erst mal Daten speichern
        nuPunkt.lat = self.coords.latitude
        nuPunkt.long = self.coords.longitude
        
        // falls der Punkt keinen Namen bekommen hat!
        if countElements(spotNameTf.text) == 0 {
            //workaround um die Daten valide zu halten
//            println("Name ist leer!")
            nuPunkt.name = " "
        }
        else {
            nuPunkt.name = spotNameTf.text
        }
        
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
    
    // wird gestellt
    func getAdress(coord: CLLocationCoordinate2D) -> String{
        let geocoder = GMSGeocoder()
        
        
        var newAddress: String = "Adresse wird geladen"
        geocoder.reverseGeocodeCoordinate (coord){ response , error in
            
            if let address = response?.firstResult() {
                let lines = address.lines as [String]
                newAddress = join(" ", lines)
                self.adressTextLabel.text = newAddress
            }
        }
        
        return newAddress
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
