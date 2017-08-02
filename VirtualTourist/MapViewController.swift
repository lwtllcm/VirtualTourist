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
    
    var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>? {
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
                let uiAlertController = UIAlertController(title: "performFetch error", message: "error in performFetch", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                uiAlertController.addAction(defaultAction)
                present(uiAlertController, animated: true, completion: nil)

            }
            
        }
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "location", ascending:  true)]
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        if fetchedResultsController?.fetchedObjects?.count == 0 {

            let uiAlertController = UIAlertController(title: "no fetched results", message: "no fetched results", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            uiAlertController.addAction(defaultAction)
            present(uiAlertController, animated: true, completion: nil)

        }
        else {
            for pin in (fetchedResultsController?.fetchedObjects)! {

                print(fetchedResultsController?.fetchedObjects as Any)
                setAnnotations(pin as! Pin)
                mapView.reloadInputViews()

            }
            
        }
        
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func setAnnotations (_ pin:Pin) {
       
        let lat1 = CLLocationDegrees(pin.latitude!)

        let long1 = CLLocationDegrees(pin.longitude!)

        let coordinate1 = CLLocationCoordinate2D(latitude: lat1!, longitude: long1!)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate1
        
        mapView.addAnnotation(annotation)
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        var selectedCoordinateLatitude:CLLocationDegrees!
        selectedCoordinateLatitude  = view.annotation?.coordinate.latitude
        
        var selectedCoordinateLongitude:CLLocationDegrees!
        selectedCoordinateLongitude  = view.annotation?.coordinate.longitude
        
        
        mapView.deselectAnnotation(view.annotation, animated: true )

        selectedCoordinateLatitudeString = "\(selectedCoordinateLatitude)"

        selectedCoordinateLongitudeString = "\(selectedCoordinateLongitude)"
        
        print(selectedCoordinateLatitudeString)
        print(selectedCoordinateLongitudeString)

       var  photoAlbumViewController:PhotoAlbumViewController
       photoAlbumViewController = storyboard?.instantiateViewController(withIdentifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
        
        performSegue(withIdentifier: "showPhotoAlbum", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func longPressed(_ sender: UILongPressGestureRecognizer) {
        
        if (sender.state == .began) {
            
            let tappedLocation = sender.location(in: mapView)

            let tappedCoordinate = mapView.convert(tappedLocation, toCoordinateFrom: mapView)

            let tappedLatitude = String(tappedCoordinate.latitude)
            let tappedLongitude = String(tappedCoordinate.longitude)

            let annotation = MKPointAnnotation()

            annotation.coordinate = tappedCoordinate
        
            addPin("location", latitude: tappedLatitude , longitude: tappedLongitude )
        
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
            }
            
        }
        
    }
    
    func addPin(_ location:String, latitude:String, longitude:String) {
        
        let pin = Pin(location: location, latitude: latitude, longitude: longitude, context: fetchedResultsController!.managedObjectContext)
        print(pin)
        
        do {
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let stack = delegate.stack
            /*
            try stack.save()
            }catch{
            let uiAlertController = UIAlertController(title: "error in addPin", message: "error in addPin", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            uiAlertController.addAction(defaultAction)
            present(uiAlertController, animated: true, completion: nil)

          */
           stack.save()
            //print(")

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for seque")
        
        if segue.identifier == "showPhotoAlbum" {
            if let photoAlbumViewController = segue.destination as? PhotoAlbumViewController {
            
        
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending:  true), NSSortDescriptor(key: "longitude", ascending:  true)]
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack

        let pred1 = NSPredicate(format: "latitude = %@", selectedCoordinateLatitudeString)

        let pred2 = NSPredicate(format: "longitude = %@", selectedCoordinateLongitudeString)
        
        //http://stackoverflow.com/questions/24855159/nspredicate-with-swift-and-core-data
        let compoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: ([pred1, pred2]))
                
        fr.predicate = compoundPredicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
       
        print(fr as Any)
                    
        photoAlbumViewController.testFetchedResultsController = fetchedResultsController
        
                }
        
            }
        
        }
    
   }

