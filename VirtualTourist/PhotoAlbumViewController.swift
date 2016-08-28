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
    
    var theseReturnedPhotoURLs = []
    
    var testFetchedResultsController:NSFetchedResultsController?
   
    
    //latitude and longitude passed from view controller
    var selectedLatitude = ""
    var selectedLongitude = ""
    
    var flickrPage = 1
    var flickrTotPages = 1
    
    var newDownload = false
    
    //viewDidLoad
    override func viewDidLoad() {
        print("viewDidLoad")
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
        print("photo album viewwillappear")
        //show focused map for selected pin
        
        let mapSpan = MKCoordinateSpanMake(2.0, 2.0)
    
        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        
        for pin in fetchedObjects! {

            getLatLon(pin as! Pin)
        }
        
        let mapRegion =
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:CLLocationDegrees(selectedLatitude)!,
            longitude:CLLocationDegrees(selectedLongitude)!), span: mapSpan)
        
        mapView.setRegion(mapRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate =
            CLLocationCoordinate2D(latitude:CLLocationDegrees(selectedLatitude)!, longitude:CLLocationDegrees(selectedLongitude)!)

        mapView.addAnnotation(annotation)
        
       
      
        let  thisPin = fetchedObjects![0] as! Pin
        
        
        print("viewWillAppear",thisPin.photos?.count)
        if thisPin.photos?.count == 0 {
            
            GetPhotos.sharedInstance().getPhotos(selectedLatitude, selectedLongitude: selectedLongitude, page:flickrPage) {(results, error)   in
            
            if (error != nil) {
                
                let uiAlertController = UIAlertController(title: "download photos error", message: "error in downloadPhotos", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
                
            }
            else {

                self.newDownload = true

                self.theseReturnedPhotoURLs = (results.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
                print(self.theseReturnedPhotoURLs)
                print(self.theseReturnedPhotoURLs.count)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView.reloadData()
                }
                
            }
            
        }
        
    }
        else {
            
            
            print("already have photo")
            
            collectionView.reloadData()
        }
    }
    
    func downloadPhotos (thisURL:NSString, completionHandler:(result: AnyObject!, error:NSError?) -> Void) {
        
        
        
        print("downloadPhotos existing count", thisURL)
        
        let photoURLFromGetPhotos = NSURL(string: thisURL as String)

        let photoImageFromGetPhotos = NSData(contentsOfURL:photoURLFromGetPhotos!)
        
            
        
        completionHandler(result: photoImageFromGetPhotos, error: nil)
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
            presentViewController(uiAlertController, animated: true, completion: nil)

        }
        
     }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        
        let  thisPin = fetchedObjects![0] as! Pin
        
        if thisPin.photos!.count > 0 {
            print("thisPin.photos!.count",thisPin.photos!.count)

            return thisPin.photos!.count
        }
        else {
        print("numberOfItems",self.theseReturnedPhotoURLs.count)
        return self.theseReturnedPhotoURLs.count
        }
        
    }
   
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        photoCell.backgroundColor = UIColor.blueColor()
        photoCell.activityIndicator.startAnimating()
        
        let fetchedObjects = self.testFetchedResultsController?.fetchedObjects
        
        let  thisPin = fetchedObjects![0] as! Pin
        
        //print("newDownload", newDownload)
        
        if newDownload == false {
            
            let photoSet = (thisPin.photos as! Set<Photo>)
            
            let photoArray = Array(photoSet)
            if photoArray.count > 0 {
            
            let thisPhoto = photoArray[indexPath.item]
            
            dispatch_async(dispatch_get_main_queue()) {
                photoCell.activityIndicator.stopAnimating()
                photoCell.photoImageView.image = UIImage(data:thisPhoto.imageData!)
                }
                
            }
            
        }
        
        else {
            
            NewCollectionButton.enabled = false
            self.downloadPhotos(self.theseReturnedPhotoURLs[indexPath.item] as! NSString) {(results, error) in
                
                
                if (error != nil) {
                    
                    let uiAlertController = UIAlertController(title: "download photos error", message: "error in downloadPhotos", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    uiAlertController.addAction(defaultAction)
                    self.presentViewController(uiAlertController, animated: true, completion: nil)
                    
                }
                else {
                    self.newDownload == false
                    print("downloadPhotos")

                    self.addPhotos(thisPin, thisPhoto: results as! NSData )
                    

                    
                    dispatch_async(dispatch_get_main_queue()) {
                        let thisImage = UIImage(data:results as! NSData)
                        photoCell.activityIndicator.stopAnimating()

                        photoCell.photoImageView.image = thisImage
                        
                    }
                    self.NewCollectionButton.enabled = true

                }
                
            }
                
        }
            

        return photoCell
    }
    
  
    
    @IBAction func newCollectionPressed(sender: AnyObject) {
        
        
        //
        
        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        
        let  thisPin = fetchedObjects![0] as! Pin
        let photoSet = (thisPin.photos as! Set<Photo>)
        
        var photoArray = Array(photoSet)
        
        //photoArray.removeAll()
        
        //
        thisPin.photos = NSSet(array: photoArray)
        for photo in thisPin.photos!{
            if let context = testFetchedResultsController?.managedObjectContext {
                
                context.deleteObject(photo as! NSManagedObject)
            }
            
        }
        
        
        print("newCollectionPressed after delete - photoArray.count", photoArray.count)
        
        print("newCollectionPressed after delete - thisPin.photos count", thisPin.photos!.count)
        
        
        let randomPage = Int(arc4random_uniform(UInt32(max(40,flickrTotPages))))
        print("randomPage", randomPage)
        
        GetPhotos.sharedInstance().getPhotos(selectedLatitude, selectedLongitude: selectedLongitude, page: randomPage) {(results, error)   in
            
            if (error != nil) {
                
                let uiAlertController = UIAlertController(title: "download photos error", message: "error in downloadPhotos", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.presentViewController(uiAlertController, animated: true, completion: nil)
                
            }
            else {


                self.newDownload = true
                
                self.theseReturnedPhotoURLs = (results.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
                print(self.theseReturnedPhotoURLs)
                print(self.theseReturnedPhotoURLs.count)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView.reloadData()
                    
                }

            }
            
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
        newDownload = false

        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        
        let  thisPin = fetchedObjects![0] as! Pin
        let photoSet = (thisPin.photos as! Set<Photo>)
        
        var photoArray = Array(photoSet)
        
        thisPin.photos = NSSet(array: photoArray)
        
        
        do {
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let stack = delegate.stack
            stack.context.deleteObject(photoArray[indexPath.item])
            try stack.save()
            print("didSelectItemAtIndexPath count after deleteObject", thisPin.photos!.count)

            
        }
        catch {
            let uiAlertController = UIAlertController(title: "delete photos error", message: "error in deletePhotos", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            uiAlertController.addAction(defaultAction)
            presentViewController(uiAlertController, animated: true, completion: nil)
            
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            collectionView.reloadData()
            
            }
        
        }
 
    }




