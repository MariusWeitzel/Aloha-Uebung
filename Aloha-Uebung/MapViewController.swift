//
//  MapViewController.swift
//  Aloha-Uebung
//
//  Created by chucha on 03.01.15.
//  Copyright (c) 2015 Medien. All rights reserved.
//

import Foundation
import UIKit

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, SpotMarkerDelegate{
    
    // MapView bzw Verbindung erstellen: Teil der Ü-aufgabe
    @IBOutlet weak var mapView: GMSMapView! // Aufgabe
 
    let locationManager = CLLocationManager() // wird gestellt
    
    var tempCoord: CLLocationCoordinate2D! // wird gestellt
    
    
    var savedSpots: [GMSMarker] = [] // wird gestellt
    
    // wird gestellt
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Vault.loadLocations()
        
        mapView.delegate = self
        mapView.myLocationEnabled = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.myLocationEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Funktionsrumpf und Seque wird gestellt
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate longPressCoordinate: CLLocationCoordinate2D){

       

        tempCoord = longPressCoordinate
        performSegueWithIdentifier("MapToLocSegue", sender: self)


    }

   // Aufgabe: Datentransfer mittels Delegate
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "MapToLocSegue"){

            println("ok segue")
            let vc = segue.destinationViewController as LocationEditorView
            vc.coords = tempCoord
            vc.spotDelegate = self

        }
    }
    // Aufgabe: Spoterstellung
    func createNewSpotDidFinish(controller: LocationEditorView, coords: CLLocationCoordinate2D){
        
        // entferne die LocationEditorView
        controller.navigationController?.popViewControllerAnimated(true)
        // erstelle neuen Surfspotmarker
        if(!savedSpots.isEmpty){
            for( var i:Int = 0; i < savedSpots.count; i++){
                if(savedSpots[i].position.latitude == coords.latitude && savedSpots[i].position.longitude == coords.longitude){
                    
                }
                else{
                    var spotMarker = GMSMarker()
                    spotMarker.position = coords
                    spotMarker.snippet = "Spot"

                    spotMarker.icon = UIImage(named: "surfer")

                    spotMarker.appearAnimation = kGMSMarkerAnimationPop
                    spotMarker.map = self.mapView
                    savedSpots.append(spotMarker)
                    println("neue Spotlocation: \(coords.latitude, coords.longitude)")
                }
            }
        }
        else{
            var spotMarker = GMSMarker()
            spotMarker.position = coords
            spotMarker.snippet = "Spot"

            spotMarker.icon = UIImage(named: "surfer")

            spotMarker.appearAnimation = kGMSMarkerAnimationPop
            spotMarker.map = self.mapView
            savedSpots.append(spotMarker)
            println("neue Spotlocation: \(coords.latitude, coords.longitude)")
        

        }
        
    }
    // wird gestellt
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            mapView.myLocationEnabled = true // erzeugt einen blauen Punkt, wo sich der User befindet
            mapView.settings.myLocationButton = true // erzeugt einen Button auf der Map zum zentrieren der Location
        }
    }
    
    // wird gestellt
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            // Kamera nach neuen Daten ausrichten
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 1, bearing: 0, viewingAngle: 0)
            
            
            locationManager.stopUpdatingLocation()
            
        }
        
    }

}