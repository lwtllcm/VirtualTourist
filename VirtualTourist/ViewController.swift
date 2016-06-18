//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Laurie Wheeler on 6/16/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
       // let allAnnotations = self.mapView.annotations
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func mapTapped(sender: AnyObject) {
        print("mapTapped")
       
      }
    
    @IBAction func longPressed(sender: UILongPressGestureRecognizer) {
        print("longPressed")
        
        let tappedLocation = sender.locationInView(mapView)
        print(tappedLocation)
        let tappedCoordinate = mapView.convertPoint(tappedLocation, toCoordinateFromView: mapView)
        print(tappedCoordinate)

        let annotation = MKPointAnnotation()

        annotation.coordinate = tappedCoordinate
        self.mapView.addAnnotation(annotation)
                
        
    }
    
    

}

