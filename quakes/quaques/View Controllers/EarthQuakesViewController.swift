//
//  EarthQuakesViewController.swift
//  quaques
//
//  Created by Nelson Gonzalez on 3/21/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import MapKit

class EarthQuakesViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let quakeFetcher = QuakeFetcher()
    var quakes: [Quake] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        fetchQuakes()
        
        //tell map view that a pin exists with an identifier..uitable view cell, etc
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeAnnotationView")
        
    }
    
    private func fetchQuakes() {
        quakeFetcher.fetchuakes { (quakes, error) in
            if let error = error {
                NSLog("Error fetching quakes: \(error)")
                return
            }
            
            guard let quakes = quakes else {return}
            
            DispatchQueue.main.async {
                self.mapView.addAnnotations(quakes)
            }
        }
    }
    
    //similar to cell for row at index path method
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //MKAnnotation is the underliying infop about a pin, location, title, sub title
        //MKAnnotationView is the physical pin the gets displayed on map view with MKAnnotations information
        
        //can have many, do 'if let'
        guard let quake = annotation as? Quake else {return nil}
        //create a new pin with the info held in the quake object
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeAnnotationView", for: quake) as? MKMarkerAnnotationView
        
        annotationView?.glyphImage = UIImage(named: "QuakeIcon")
        annotationView?.glyphTintColor = .white
        annotationView?.markerTintColor = .blue
        
        annotationView?.canShowCallout = true
        let detailView = QuakeDetailView(frame: .zero)
        detailView.quake = quake
        annotationView?.detailCalloutAccessoryView = detailView
        
        return annotationView
        
    }


}
