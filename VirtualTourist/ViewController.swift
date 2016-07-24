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
    
    var selectedLatitude:String!
    var selectedLongitude = ""
    
    var selectedCoordinateLatitudeString:String!
    var selectedCoordinateLongitudeString:String!

    
    var fetchedResultsController:NSFetchedResultsController? {
        didSet {
            //fetchedResultsController?.delegate = self
            //print("fetchedResultsController didSet")
            executeSearch()
        }
    }
    
    func executeSearch() {
        print("executeSearch")
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()

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
        //print("ViewController fr", fr)
        
        
        //print(fetchedResultsController.fetchedObjects)
        //print("pin count",fetchedResultsController!.fetchedObjects?.count)
        
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
        
  }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
    func setAnnotations (pin:Pin) {
        print("setAnnotations")
        //var annotations = [MKPointAnnotation]()
        let lat1 = CLLocationDegrees(pin.latitude!)
        print(lat1)
        let long1 = CLLocationDegrees(pin.longitude!)
        print(long1)
        let coordinate1 = CLLocationCoordinate2D(latitude: lat1!, longitude: long1!)
        //print(coordinate1)
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
    
    

   
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("annotationView selected")
        
        var selectedCoordinateLatitude:CLLocationDegrees!
        selectedCoordinateLatitude  = view.annotation?.coordinate.latitude
        
        var selectedCoordinateLongitude:CLLocationDegrees!
        selectedCoordinateLongitude  = view.annotation?.coordinate.longitude
        
        
        //print("selectedCoordinateLatitude", selectedCoordinateLatitude)
        //print("selectedCoordinateLongitude", selectedCoordinateLongitude)

        
        
        //http://stackoverflow.com/questions/26142441/cllocationdegrees-to-string-variable-in-swift
        //http://stackoverflow.com/questions/26347777/swift-how-to-remove-optional-string-character
        
       // var selectedCoordinateLatitudeString:String!
        selectedCoordinateLatitudeString = "\(selectedCoordinateLatitude)"
       // print("selectedCoordinateLatitudeString", selectedCoordinateLatitudeString)
        
        selectedCoordinateLongitudeString = "\(selectedCoordinateLongitude)"
        //print("selectedCoordinateLongitudeString", selectedCoordinateLongitudeString)

        
        //let photoAlbumViewController = PhotoAlbumViewController()
        
        //let photoAlbumViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoAlbumViewController") as! PhotoAlbumViewController
        
        var  photoAlbumViewController:PhotoAlbumViewController
        photoAlbumViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoAlbumViewController") as! PhotoAlbumViewController
        
        //photoAlbumViewController.mapLatitude = "52.247849103093301"
        //photoAlbumViewController.mapLongitude = "-105.589742638687"
        
        
       // self.presentViewController(photoAlbumViewController, animated: true, completion: nil)
        
        /*
        //photoAlbumViewController.selectedLatitude = view.annotation?.coordinate.latitude
        var selectedCoordinateLatitude:CLLocationDegrees!
        selectedCoordinateLatitude  = view.annotation?.coordinate.latitude
        
        
        print("selectedCoordinateLatitude", selectedCoordinateLatitude)
        
        
        //http://stackoverflow.com/questions/26142441/cllocationdegrees-to-string-variable-in-swift
        //http://stackoverflow.com/questions/26347777/swift-how-to-remove-optional-string-character
        
        var selectedCoordinateLatitudeString:String!
            selectedCoordinateLatitudeString = "\(selectedCoordinateLatitude)"
        print("selectedCoordinateLatitudeString", selectedCoordinateLatitudeString)
       */
        
        
        photoAlbumViewController.selectedLatitude = selectedCoordinateLatitudeString
        photoAlbumViewController.selectedLongitude = selectedCoordinateLongitudeString

        //photoAlbumViewController.selectedLongitude = self.selectedLongitude
        
        
        
        performSegueWithIdentifier("showPhotoAlbum", sender: self)
        
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
        //print("tappedCoordinate",tappedCoordinate)
        //print("tappedLatitude", tappedLatitude)
        //print("tappedLongitude", tappedLongitude)

        let annotation = MKPointAnnotation()

        annotation.coordinate = tappedCoordinate
        
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepareForSegue")
        
        if segue.identifier == "showPhotoAlbum" {
            if let photoAlbumViewController = segue.destinationViewController as? PhotoAlbumViewController {
            
        
        //let controller = segue.destinationViewController as! PhotoAlbumViewController
        
        //controller.selectedLatitude = selectedCoordinateLatitudeString
        //controller.selectedLongitude = selectedCoordinateLongitudeString

        //print("controller.selectedLatitude", controller.selectedLatitude)
        //print("controller.selectedLongitude", controller.selectedLongitude)
        
        
        //let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let stack = delegate.stack
        
        let fr = NSFetchRequest(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending:  true), NSSortDescriptor(key: "longitude", ascending:  true)]
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack

        let pred1 = NSPredicate(format: "latitude like %@", selectedCoordinateLatitudeString)
         //       print(pred1)
        let pred2 = NSPredicate(format: "longitude like %@", selectedCoordinateLongitudeString)
        //print(pred2)
                
        
        //http://stackoverflow.com/questions/24855159/nspredicate-with-swift-and-core-data
        let compoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: ([pred1, pred2]))
                
        fr.predicate = compoundPredicate
          //      fr.predicate = pred1
         print(fr)
        
        //let pin = fetchedResultsController?.objectAtIndexPath(<#T##indexPath: NSIndexPath##NSIndexPath#>)
        
        //print("fr", fr)
                
                
        
       fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        ////////
        
        
        
        //print("PhotoAlbumViewController fetched results count",fetchedResultsController!.fetchedObjects?.count)
        
                print("testFetchedResultsController.fetchedObjects in prepareForSegue", fetchedResultsController!.fetchedObjects)
       
                photoAlbumViewController.testFetchedResultsController = fetchedResultsController
                
        
        
            }
        
        }
        
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
    
 
}

