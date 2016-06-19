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
        self.mapView.delegate = self
          }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
       // let allAnnotations = self.mapView.annotations
        
    }
  
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print("viewForAnnotation")
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.pinTintColor = UIColor.greenColor()
            pinView?.canShowCallout = false
            
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
        
    }

    
  /*
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control == view.rightCalloutAccessoryView) {
        
        print("annotationTapped")
           // let photoAlbumViewController = PhotoAlbumViewController()
           // self.presentViewController(photoAlbumViewController, animated: true, completion: nil)
            
        }
    }
 */
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        print("annotationView selected")
        
        //let photoAlbumViewController = PhotoAlbumViewController()
        let photoAlbumViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoAlbumViewController")
        self.presentViewController(photoAlbumViewController!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
/*
    
   @IBAction func mapTapped(sender: AnyObject) {
        print("mapTapped")
    
    
      }
 */
    
    @IBAction func longPressed(sender: UILongPressGestureRecognizer) {
        print("longPressed")
        
        let tappedLocation = sender.locationInView(mapView)
        print(tappedLocation)
        let tappedCoordinate = mapView.convertPoint(tappedLocation, toCoordinateFromView: mapView)
        print(tappedCoordinate)

        let annotation = MKPointAnnotation()

        annotation.coordinate = tappedCoordinate
        
        annotation.title = "test annotation"
        
        
        //self.mapView.addAnnotation(annotation)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.addAnnotation(annotation)
            
        }
        
        
    }
 
}

