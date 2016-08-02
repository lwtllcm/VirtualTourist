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

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedLatitude:String!
    var selectedLongitude = ""
    
    var selectedCoordinateLatitudeString:String!
    var selectedCoordinateLongitudeString:String!

    
    var fetchedResultsController:NSFetchedResultsController? {
        didSet {
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
        
        if fetchedResultsController?.fetchedObjects?.count == 0 {
            print("no fetched results")

        }
        else {
            for pin in (fetchedResultsController?.fetchedObjects)! {
            //print(pin)
                self.setAnnotations(pin as! Pin)
                self.mapView.reloadInputViews()

            }
        }
        
  }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    func setAnnotations (pin:Pin) {
        //print("setAnnotations")
        //var annotations = [MKPointAnnotation]()
       
        let lat1 = CLLocationDegrees(pin.latitude!)

        let long1 = CLLocationDegrees(pin.longitude!)

        let coordinate1 = CLLocationCoordinate2D(latitude: lat1!, longitude: long1!)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate1
        
        
        self.mapView.addAnnotation(annotation)

        
    }
    
   
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("annotationView selected")
        
        var selectedCoordinateLatitude:CLLocationDegrees!
        selectedCoordinateLatitude  = view.annotation?.coordinate.latitude
        
        var selectedCoordinateLongitude:CLLocationDegrees!
        selectedCoordinateLongitude  = view.annotation?.coordinate.longitude

        selectedCoordinateLatitudeString = "\(selectedCoordinateLatitude)"

        
        selectedCoordinateLongitudeString = "\(selectedCoordinateLongitude)"

        
        var  photoAlbumViewController:PhotoAlbumViewController
        photoAlbumViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoAlbumViewController") as! PhotoAlbumViewController
        
        
        photoAlbumViewController.selectedLatitude = selectedCoordinateLatitudeString
        photoAlbumViewController.selectedLongitude = selectedCoordinateLongitudeString
        
        performSegueWithIdentifier("showPhotoAlbum", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func longPressed(sender: UILongPressGestureRecognizer) {
        print("longPressed")
        
        if (sender.state == .Began) {
            
            let tappedLocation = sender.locationInView(mapView)
            print(tappedLocation)
            let tappedCoordinate = mapView.convertPoint(tappedLocation, toCoordinateFromView: mapView)

            let tappedLatitude = String(tappedCoordinate.latitude)
            let tappedLongitude = String(tappedCoordinate.longitude)

            let annotation = MKPointAnnotation()

            annotation.coordinate = tappedCoordinate
        
        
            self.addPin("location", latitude: tappedLatitude , longitude: tappedLongitude )
        
            dispatch_async(dispatch_get_main_queue()) {
                self.mapView.addAnnotation(annotation)
            }
        }
        
    }
    
    func addPin(location:String, latitude:String, longitude:String) {
        
        let pin = Pin(location: location, latitude: latitude, longitude: longitude, context: fetchedResultsController!.managedObjectContext)
        //print("addPin", pin)
        
        do {
             let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let stack = delegate.stack
            
            try stack.save()
        }catch{
            print("error while saving")
        }
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepareForSegue")
        
        if segue.identifier == "showPhotoAlbum" {
            if let photoAlbumViewController = segue.destinationViewController as? PhotoAlbumViewController {
            
        
        let fr = NSFetchRequest(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending:  true), NSSortDescriptor(key: "longitude", ascending:  true)]
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack

        let pred1 = NSPredicate(format: "latitude = %@", selectedCoordinateLatitudeString)

        let pred2 = NSPredicate(format: "longitude = %@", selectedCoordinateLongitudeString)
        
        //http://stackoverflow.com/questions/24855159/nspredicate-with-swift-and-core-data
        let compoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: ([pred1, pred2]))
                
        fr.predicate = compoundPredicate

        //print(fr)
        
        
       fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        
        //print("testFetchedResultsController.fetchedObjects in prepareForSegue", fetchedResultsController!.fetchedObjects)
       
        photoAlbumViewController.testFetchedResultsController = fetchedResultsController
                
        
        
            }
        
        }
        
    }
    
    
   }

