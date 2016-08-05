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
            print("PhotoAlbumViewController fetchedResultsController ")
            executeSearch()
        }
    }
    
    //executeSearch
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
   
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PhotoAlbumViewController viewDidLoad")
        
        print("passed testFetchedResultsController.fetchedObjects", testFetchedResultsController?.fetchedObjects)

        //collectionView setup
        let space: CGFloat = 3.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumLineSpacing = space        
        flowLayout.itemSize = CGSizeMake(100.0, 100.0)
        
     }
    
    
    //viewWillAppear
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("PhotoAlbumViewController viewWillAppear")
        
        //show focused map for selected pin
        let mapSpan = MKCoordinateSpanMake(2.0, 2.0)
    
        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        
        for pin in fetchedObjects! {
            //print(pin)
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

        
        
        if (thisPin.photos?.count > 0) {
            
            print("found photos for this pin,  thisPin.photos?.count", thisPin.photos?.count)
            
           // http://stackoverflow.com/questions/33576113/proper-syntax-to-loop-through-core-data-nsset
            for photoURL:Photo in thisPin.photos as! Set<Photo>  {
                print(photoURL.imageData)
                self.returnedPhotosArray.addObject(photoURL)
            }
        }
        else {
        GetPhotos.sharedInstance().getPhotos(selectedLatitude, selectedLongitude: selectedLongitude) {(results, error)   in
            
            if (error != nil) {
                print("error returned from getPhotos")
            }
            else {
                print("data after getPhotos - in completion handler", results)
                
                var theseReturnedPhotoURLs = []
                theseReturnedPhotoURLs = (results.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
                
                
                for photoURLStringFromGetPhotos in theseReturnedPhotoURLs {
                    self.returnedPhotosArray.addObject(photoURLStringFromGetPhotos)
                    
                    print(photoURLStringFromGetPhotos)
                    
                    
                    let photoURLFromGetPhotos = NSURL(string: photoURLStringFromGetPhotos as! String)
                    print(photoURLFromGetPhotos)

                    let photoImageFromGetPhotos = NSData(contentsOfURL:photoURLFromGetPhotos!)
                    print(photoImageFromGetPhotos)
                    
                    self.addPhotos(thisPin, thisPhoto: photoImageFromGetPhotos!)
                    

                }
                }
            }
        }
 
    }
    
    func getLatLon(pin:Pin) {
        print("getLatLon")
        selectedLatitude = pin.latitude!
        selectedLongitude = pin.longitude!
    }
    
    
    //func addPhotos(thisPin:Pin, photoURLString:String) {
    
    func addPhotos(thisPin:Pin, thisPhoto:NSData) {
        print("addPhotos")
        
        //print(thisPin)
        print("thisPin.photos", thisPin.photos)
        //print(photoURLString)
        
        let photo = Photo(imageData: thisPhoto, context: testFetchedResultsController!.managedObjectContext)

        photo.pin = thisPin
        
        do {
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let stack = delegate.stack
            
            try stack.save()
        }catch{
            print("error while saving")
        }
     }
    
    
    
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        print("convertDataWithCompletionHandler")
        var parsedResult: AnyObject!
        
        do {
            
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            
        }
        catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
        
    }
    

  
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection")
        
        //return (self.returnedPhotosArray.count)
        

        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        
        
        let  thisPin = fetchedObjects![0] as! Pin
        print("thisPin.photos!.count", thisPin.photos!.count)
        return thisPin.photos!.count
        
        
    }
   
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("cellForItemAtIndexPath")
        
  
        let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        
        
        let  thisPin = fetchedObjects![0] as! Pin
        let photoSet = (thisPin.photos as! Set<Photo>)
        print("photoSet", photoSet)

        let photoArray = Array(photoSet)
        print("photoArray", photoArray)
        
        let thisPhoto = photoArray[indexPath.item]
        print("thisPhoto", thisPhoto)
        
        
            dispatch_async(dispatch_get_main_queue()) {
                photoCell.photoImageView.image = UIImage(data:thisPhoto.imageData!)
            }
            
       
        
        return photoCell
    }
    
    
    
    
    
    @IBAction func newCollectionPressed(sender: AnyObject) {
        print("newCollectionPressed")
        
        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        
        let  thisPin = fetchedObjects![0] as! Pin
        let photoSet = (thisPin.photos as! Set<Photo>)

        let photoArray = Array(photoSet)

        for photo in photoArray {
            if let context = fetchedResultsController?.managedObjectContext {
             
            context.deleteObject(photo)
            }
        }
        
        print(thisPin.photos?.count)
        
       // let  thisPin = fetchedObjects![0] as! Pin

        GetPhotos.sharedInstance().getPhotos(selectedLatitude, selectedLongitude: selectedLongitude) {(results, error)   in
            
            if (error != nil) {
                print("error returned from getPhotos")
            }
            else {
                //print("data after getPhotos - in completion handler", results)
                
                var theseReturnedPhotoURLs = []
                theseReturnedPhotoURLs = (results.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
               
                
                
                for photoURL in theseReturnedPhotoURLs {
                    
                    //self.returnedPhotosArray.addObject(photoURL)
                    self.returnedPhotosArray.addObject(NSData(contentsOfURL: photoURL as! NSURL)!)
                    print("self.returnedPhotosArray", self.returnedPhotosArray)
                    
                    //add new photos to core data
                    
                    //self.addPhotos(thisPin,photoURLString: (photoURL as!  String))
                    
                    self.addPhotos(thisPin,thisPhoto: NSData(contentsOfURL: photoURL as! NSURL)!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView.reloadData()
                    }
                }

                /*
                for photoURL in theseReturnedPhotoURLs {

                    self.returnedPhotosArray.addObject(photoURL)
                    
                    //add new photos to core data
 
                    self.addPhotos(thisPin,photoURLString: (photoURL as!  String))
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView.reloadData()
                    }
                    
                }
                */
            }
        }
    }
    
/*
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
        let photo = fetchedResultsController!.objectAtIndexPath(indexPath) as! Photo
        let context = testFetchedResultsController?.managedObjectContext
        context?.deleteObject(photo)
        }
        CoreDataStackManager.sharedInstance().deleteObject(photo)
    }
*/
 
}




