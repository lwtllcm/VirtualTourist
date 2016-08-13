//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Laurie Wheeler on 6/18/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
       
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var NewCollectionButton: UIButton!
    
    var returnedPhotoURLs = []
   var returnedPhotosArray:NSMutableArray = []
    
    var testFetchedResultsController:NSFetchedResultsController?
   
    
    //latitude and longitude passed from view controller
    var selectedLatitude = ""
    var selectedLongitude = ""
    
    //fetchedResultsController
    var fetchedResultsController:NSFetchedResultsController? {
        didSet {

            executeSearch()
        }
    }
    
    //executeSearch
    func executeSearch() {

        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            }
            catch {
                let uiAlertController = UIAlertController(title: "performFetch error", message: "error in performFetch", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
            }
        }
    }
   
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        //collectionView setup
        let space: CGFloat = 3.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumLineSpacing = space        
        flowLayout.itemSize = CGSizeMake(100.0, 100.0)

        returnedPhotosArray.removeAllObjects()
      
     }
    
    
    //viewWillAppear
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //show focused map for selected pin
        let mapSpan = MKCoordinateSpanMake(2.0, 2.0)
    
        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        
        for pin in fetchedObjects! {

            self.getLatLon(pin as! Pin)
        }
        
        let mapRegion =
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:CLLocationDegrees(selectedLatitude)!,
            longitude:CLLocationDegrees(selectedLongitude)!), span: mapSpan)
        
        mapView.setRegion(mapRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate =
            CLLocationCoordinate2D(latitude:CLLocationDegrees(selectedLatitude)!, longitude:CLLocationDegrees(selectedLongitude)!)

        self.mapView.addAnnotation(annotation)
        
       
      
        let  thisPin = fetchedObjects![0] as! Pin
        
        GetPhotos.sharedInstance().getPhotos(selectedLatitude, selectedLongitude: selectedLongitude) {(results, error)   in
            
            if (error != nil) {
                
                let uiAlertController = UIAlertController(title: "download photos error", message: "error in downloadPhotos", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
                
            }
            else {
                var theseReturnedPhotoURLs = []
                theseReturnedPhotoURLs = (results.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
                
                
                for photoURLStringFromGetPhotos in theseReturnedPhotoURLs {
                    
                    let photoURLFromGetPhotos = NSURL(string: photoURLStringFromGetPhotos as! String)
                    
                    let photoImageFromGetPhotos = NSData(contentsOfURL:photoURLFromGetPhotos!)
                    
                    self.addPhotos(thisPin, thisPhoto: photoImageFromGetPhotos!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView.reloadData()
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func downloadPhotos (thisPin:Pin, completionHandler:(result: AnyObject!, error:NSError?) -> Void) {
        
        print("downloadPhotos existing count", thisPin.photos?.count)

        GetPhotos.sharedInstance().getPhotos(selectedLatitude, selectedLongitude: selectedLongitude) {(results, error)   in
            
            if (error != nil) {

                let uiAlertController = UIAlertController(title: "download photos error", message: "error in downloadPhotos", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)

            }
            else {
                var theseReturnedPhotoURLs = []
                theseReturnedPhotoURLs = (results.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
                
                
                for photoURLStringFromGetPhotos in theseReturnedPhotoURLs {
                    //self.returnedPhotosArray.addObject(photoURLStringFromGetPhotos)
                    
                    let photoURLFromGetPhotos = NSURL(string: photoURLStringFromGetPhotos as! String)
                    
                    let photoImageFromGetPhotos = NSData(contentsOfURL:photoURLFromGetPhotos!)
                    
                    self.addPhotos(thisPin, thisPhoto: photoImageFromGetPhotos!)
                    
                }
                
            }
            
        }
        
        completionHandler(result: thisPin, error: nil)
    }
    
    func getLatLon(pin:Pin) {
        selectedLatitude = pin.latitude!
        selectedLongitude = pin.longitude!
    }
    
    
    
    func addPhotos(thisPin:Pin, thisPhoto:NSData) {
        
        let photo = Photo(imageData: thisPhoto, context: testFetchedResultsController!.managedObjectContext)

        photo.pin = thisPin
        
        do {
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let stack = delegate.stack
            
            try stack.save()
        }catch{
            let uiAlertController = UIAlertController(title: "addPhotos error", message: "error in addPhotos", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            uiAlertController.addAction(defaultAction)
            self.presentViewController(uiAlertController, animated: true, completion: nil)

        }
        
     }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return (self.returnedPhotosArray.count)
        

        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        
        let  thisPin = fetchedObjects![0] as! Pin

        return thisPin.photos!.count
        
    }
   
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("cellForItemAtIndexPath")
        
        let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        photoCell.backgroundColor = UIColor.blueColor()
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
        
        let fetchedObjects = self.testFetchedResultsController?.fetchedObjects
        
        let  thisPin = fetchedObjects![0] as! Pin
            
            
           if thisPin.photos?.count == 0 {
            self.downloadPhotos(thisPin, completionHandler: {(results, error)   in
                
                if (error != nil) {
                    print("error result from downloadPhotos")
                }
                    
                else {
                    print("**3")
                    dispatch_async(dispatch_get_main_queue()) {
                        
                       
                        self.collectionView.reloadData()
                        
                        print("**4")
                    }
                    
                }
                
            })
            
        }
           
            
            let photoSet = (thisPin.photos as! Set<Photo>)
            
            
            
            let photoArray = Array(photoSet)
            
            
            
            let thisPhoto = photoArray[indexPath.item]

            dispatch_async(dispatch_get_main_queue()) {
                photoCell.photoImageView.image = UIImage(data:thisPhoto.imageData!)

            }
       
        })
        
        return photoCell
    }
    
    
    @IBAction func newCollectionPressed(sender: AnyObject) {
        
        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        
        let  thisPin = fetchedObjects![0] as! Pin
        let photoSet = (thisPin.photos as! Set<Photo>)

        var photoArray = Array(photoSet)
        
        photoArray.removeAll()
        thisPin.photos = NSSet(array: photoArray)
        
        for photo in photoArray {
            if let context = fetchedResultsController?.managedObjectContext {
             
            context.deleteObject(photo)
            }
            
        }
        
        
        GetPhotos.sharedInstance().getPhotos(selectedLatitude, selectedLongitude: selectedLongitude) {(results, error)   in
            
            if (error != nil) {
                
                let uiAlertController = UIAlertController(title: "download photos error", message: "error in downloadPhotos", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
                
            }
            else {
                var theseReturnedPhotoURLs = []
                theseReturnedPhotoURLs = (results.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
                
                
                for photoURLStringFromGetPhotos in theseReturnedPhotoURLs {
                    //self.returnedPhotosArray.addObject(photoURLStringFromGetPhotos)
                    
                    let photoURLFromGetPhotos = NSURL(string: photoURLStringFromGetPhotos as! String)
                    
                    let photoImageFromGetPhotos = NSData(contentsOfURL:photoURLFromGetPhotos!)
                    
                    self.addPhotos(thisPin, thisPhoto: photoImageFromGetPhotos!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView.reloadData()
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
        
        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        
        let  thisPin = fetchedObjects![0] as! Pin
        let photoSet = (thisPin.photos as! Set<Photo>)
        
        var photoArray = Array(photoSet)
        
        photoArray.removeAtIndex(indexPath.item)
        
        
        thisPin.photos = NSSet(array: photoArray)
        
        let context = testFetchedResultsController!.managedObjectContext
        print("thisPin.photos.count before delete", thisPin.photos!.count)
        context.deleteObject(photoArray[indexPath.item])
        do {
            try context.save()
            
        }
        catch {
            let uiAlertController = UIAlertController(title: "delete photos error", message: "error in deletePhotos", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            uiAlertController.addAction(defaultAction)
            self.presentViewController(uiAlertController, animated: true, completion: nil)

        }
        
        print("thisPin.photos.count after delete", thisPin.photos!.count)

        
        
        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView.reloadData()
            }
        
        }
 
    }




