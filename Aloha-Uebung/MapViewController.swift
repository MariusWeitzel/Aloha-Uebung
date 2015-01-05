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
    
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // Aufgabe - mapView für Google Maps im Storyboard erstellen
    // Aufgabe - hier musst du dann auch auf die mapView zugreifen können ;)
    
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 
    let locationManager = CLLocationManager()
    
    var tempCoord: CLLocationCoordinate2D!
    

    var savedSpots: [GMSMarker] = []
    let locations = Location()
    
    // wird gestellt
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Vault.loadLocations()
        
        mapView.delegate = self
        mapView.myLocationEnabled = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        loadSpotLocations()
    }
    
    func loadSpotLocations(){
        var localLocations = Vault.getLocations()
        savedSpots.removeAll(keepCapacity: false)
        for var i:Int = 0; i < localLocations.count; i++ {
            let spot = GMSMarker()
            
            spot.position = CLLocationCoordinate2DMake(localLocations[i].lat.doubleValue, localLocations[i].long.doubleValue)
            spot.snippet = localLocations[i].name
            
                       
            spot.appearAnimation = kGMSMarkerAnimationPop
            spot.map = self.mapView
            savedSpots.append(spot)
            
        }

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

    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        tempCoord = marker.position
        performSegueWithIdentifier("MapToLocSegue", sender: self)

        return true
    }

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
   // Aufgabe: Datentransfer mittels Delegate
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "MapToLocSegue"){

            let vc = segue.destinationViewController as LocationEditorView
            vc.coords = tempCoord
            vc.spotDelegate = self
            
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        }
    }
    
    func createNewSpotDidFinish(controller: LocationEditorView, coords: CLLocationCoordinate2D){
        // entferne die LocationEditorView
        controller.navigationController?.popViewControllerAnimated(true)
        // erstelle neuen Surfspotmarker
        if (!savedSpots.isEmpty) {
            for( var i:Int = 0; i < savedSpots.count; i++){
                if(savedSpots[i].position.latitude != coords.latitude && savedSpots[i].position.longitude != coords.longitude){
                    var spotMarker = GMSMarker()
                    //Aufgabe - Marker an der Koordinate auf der Map anzeigen
                    //          Marker an die Map übergeben
                    //          Marker in Array (savedSpots) speichern
                    //println("neue Spotlocation: \(coords.latitude, coords.longitude)")
                    
                    
                    
                    
                    
                    
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
                }
            }
        }
        else {
            var spotMarker = GMSMarker()
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
            // Aufgabe - hier analog, wie zu den bestehenden Punkten
            //println("neue Spotlocation: \(coords.latitude, coords.longitude)")
        

            
            
            
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
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