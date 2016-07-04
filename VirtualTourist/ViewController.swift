//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Laurie Wheeler on 6/16/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var fetchedResultsController:NSFetchedResultsController? {
        didSet {
            //fetchedResultsController?.delegate = self
            print("fetchedResultsController didSet")
            executeSearch()
        }
    }
    
    func executeSearch() {
        print("executeSearch")
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
                //print(fc.fetchedObjects)
            }
            catch {
                print ("error in performFetch")
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
        print("ViewController viewDidLoad")
        
        let fr = NSFetchRequest(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "location", ascending:  true)]
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        print("ViewController fr", fr)
        
        
        //print(fetchedResultsController.fetchedObjects)
        print("pin count",fetchedResultsController!.fetchedObjects?.count)
        
        if fetchedResultsController?.fetchedObjects?.count == 0 {
            print("no fetched results")
          //  self.setAnnotations((fetchedResultsController?.fetchedObjects as Pin!)!)
        }
        else {
            for pin in (fetchedResultsController?.fetchedObjects)! {
            print(pin)
                self.setAnnotations(pin as! Pin)
                self.mapView.reloadInputViews()

            }
        }
        
        
        /*
        var thisCoordinate = CLLocationCoordinate2D()
        thisCoordinate.latitude = 33.955190025712511
        thisCoordinate.longitude = -118.07473099889084
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = thisCoordinate
        self.mapView.addAnnotation(annotation)
        */
        
  }
    
    func setAnnotations (pin:Pin) {
        print("setAnnotations")
        //var annotations = [MKPointAnnotation]()
        let lat1 = CLLocationDegrees(pin.latitude!)
        print(lat1)
        let long1 = CLLocationDegrees(pin.longitude!)
        print(long1)
        let coordinate1 = CLLocationCoordinate2D(latitude: lat1!, longitude: long1!)
        print(coordinate1)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate1
        
        
        self.mapView.addAnnotation(annotation)

        /*
        dispatch_async(dispatch_get_main_queue()) {
            //self.mapView.addAnnotations(annotations)
            self.mapView.addAnnotation(annotation)
        }
 */
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
       // let allAnnotations = self.mapView.annotations
        
        
        
        
    }

    /*
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
            print("pinView not nil")
            //let index = 0
            //pinView?.annotation?.latitude = "33.955190025712511"
            //pinView?.annotation?.coordinate.longitude = "-118.07473099889084"
            //pinView?.annotation = annotation
            
            var thisCoordinate = CLLocationCoordinate2D()
            thisCoordinate.latitude = 33.955190025712511
            thisCoordinate.longitude = -118.07473099889084
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = thisCoordinate
            self.mapView.addAnnotation(annotation)
        }
        return pinView
        
    }
*/
    
  /*
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control == view.rightCalloutAccessoryView) {
        
        print("annotationTapped")
           // let photoAlbumViewController = PhotoAlbumViewController()
           // self.presentViewController(photoAlbumViewController, animated: true, completion: nil)
            
        }
    }
 */
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("annotationView selected")
        
        let photoAlbumViewController = PhotoAlbumViewController()
        
        //let photoAlbumViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoAlbumViewController")
        
        photoAlbumViewController.mapLatitude = "52.247849103093301"
        photoAlbumViewController.mapLongitude = "-105.589742638687"
        self.presentViewController(photoAlbumViewController, animated: true, completion: nil)
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

        let tappedLatitude = String(tappedCoordinate.latitude)
        let tappedLongitude = String(tappedCoordinate.longitude)
        print(tappedCoordinate)
        print(tappedLatitude)
        print(tappedLongitude)

        let annotation = MKPointAnnotation()

        annotation.coordinate = tappedCoordinate
        
        annotation.title = "test annotation"
        
        
        //self.mapView.addAnnotation(annotation)
        
        //self.addPin("newPin")
        
        self.addPin("location", latitude: tappedLatitude , longitude: tappedLongitude )
        
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.addAnnotation(annotation)
            
        }
        
        
        
    }
    
    func addPin(location:String, latitude:String, longitude:String) {
        
        //let pin = Pin(location: location, context:fetchedResultsController!.managedObjectContext)
        let pin = Pin(location: location, latitude: latitude, longitude: longitude, context: fetchedResultsController!.managedObjectContext)
        print("addPin", pin)
    }
 
}

