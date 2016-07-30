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
        
        //print("passed selectedLatitude ", self.selectedLatitude as NSString)
        //print("passed selectedLongitude ", self.selectedLongitude as NSString)
        
        print("passed testFetchedResultsController.fetchedObjects", testFetchedResultsController?.fetchedObjects)

        //collectionView setup
        let space: CGFloat = 3.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumLineSpacing = space        
        flowLayout.itemSize = CGSizeMake(100.0, 100.0)
        
        //fetch request setup
        /*
        let fr = NSFetchRequest(entityName: "Pin")
 
        fr.sortDescriptors = [NSSortDescriptor(key: "location", ascending:  true)]
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let stack = delegate.stack
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        
        fetchedResultsController?.fetchedObjects
       */
    }
    
    
    //viewWillAppear
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("PhotoAlbumViewController viewWillAppear")
        
        //show focused map for selected pin
        let mapSpan = MKCoordinateSpanMake(2.0, 2.0)
    
        
        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        print("fetchedObjects", fetchedObjects)
        
        for pin in fetchedObjects! {
            print(pin)
            self.getLatLon(pin as! Pin)
        }
        
     
        let mapRegion =
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:CLLocationDegrees(selectedLatitude)!,
            longitude:CLLocationDegrees(selectedLongitude)!), span: mapSpan)
        
        mapView.setRegion(mapRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate =
            CLLocationCoordinate2D(latitude:CLLocationDegrees(selectedLatitude)!, longitude:CLLocationDegrees(selectedLongitude)!)

        
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.addAnnotation(annotation)
        }
      
      
        
        let  thisPin = fetchedObjects![0] as! Pin
        print("thisPin", thisPin)
        print("thisPin.photos", thisPin.photos?.count)
        if (thisPin.photos?.count > 0) {
            print(thisPin.photos)
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
                
                
                for photoURL in theseReturnedPhotoURLs {
                    print("photoURL", photoURL)
                    self.returnedPhotosArray.addObject(photoURL)
                    print("self.returnedPhotosArray", self.returnedPhotosArray)
                    
                    //add new photos to core data
                    //self.addPhotos("location", latitude: self.selectedLatitude, longitude: self.selectedLongitude, photoURLString: (photoURL as!  String))
                    self.addPhotos(thisPin,photoURLString: (photoURL as!  String))
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView.reloadData()
                    }

            }
        }
                }
            //}
            
            
       // }
        
  /*
         if testFetchedResultsController?.fetchedObjects?.count == 0 {
            print("no fetched results")
         }
         else {
         
            for result in (testFetchedResultsController?.fetchedObjects)! {
                if let existingPhotosFound = result.valueForKey("photos") {
                    
                    print(" ")
                    print("existingPhotosFound ", existingPhotosFound)
                    if existingPhotosFound.count == 0 {
         
                        //getPhotos {(result, error) in
                        GetPhotos.sharedInstance().getPhotos(selectedLatitude, selectedLongitude: selectedLongitude) {(results, error)   in
         
                            if (error != nil) {
                                print("error returned from getPhotos")
                            }
                            else {
                                print("data after getPhotos - in completion handler", result)
                                var theseReturnedPhotoURLs = []
                                theseReturnedPhotoURLs = (result.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
         
            
                                for photoURL in theseReturnedPhotoURLs {
                                    print("photoURL", photoURL)
                                    self.returnedPhotosArray.addObject(photoURL)
                                    print("self.returnedPhotosArray", self.returnedPhotosArray)
            
                                    //add new photos to core data
                                    self.addPhotos("location", latitude: self.selectedLatitude, longitude: self.selectedLongitude, photoURLString: (photoURL as!  String))
         
            
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.collectionView.reloadData()
                                    }
                                }
                            }
   
                            
                        }
         
         
                        print("returnedPhotosArray.count after getPhotos",self.returnedPhotosArray.count)
                        
                        
         
                    }
         
                }
                else {
                    print("photo not found")
                }
            }
         
         }
        
        
        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView.reloadData()
        }
*/
    }
 
    }
    
    func getLatLon(pin:Pin) {
        print("getLatLon")
        selectedLatitude = pin.latitude!
        selectedLongitude = pin.longitude!
        print(selectedLatitude)
        print(selectedLongitude)
    }
    
    
    func addPhotos(thisPin:Pin, photoURLString:String) {
        print("addPhotos")
        
        print(thisPin)
        print("thisPin.photos", thisPin.photos)
        print(photoURLString)
        
        
        
        
       // let fetchedObjects = testFetchedResultsController?.fetchedObjects

       // let newPhoto = Photo(imageData: photoURLString, context: testFetchedResultsController!.managedObjectContext)
        
        
        
        let newPhoto = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: testFetchedResultsController!.managedObjectContext) as! Photo
        newPhoto.imageData = photoURLString
        
        
        
        
        print(thisPin)
        print("thisPin.photos", thisPin.photos)

        
        do {
            // try stack.save()
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let stack = delegate.stack
            
            try stack.saveContext()
        }catch{
            print("error while saving")
        }

        
        
        
        /*
        do {
            try thisPin.managedObjectContext?.save()
            print("thisPin after adding photos",thisPin)
        } catch {
         
            let saveError = error as NSError
            print(saveError)
        }
        */
        
        
        /*
        let entityPhoto = NSEntityDescription.entityForName("Photo", inManagedObjectContext: fetchedResultsController!.managedObjectContext)
        let newPhoto = NSManagedObject(entity: entityPhoto!, insertIntoManagedObjectContext: fetchedResultsController!.managedObjectContext)
        newPhoto.setValue(photoURLString, forKey: "imageData")
        
        thisPin.setValue(newPhoto, forKey: "photos")
         
         */
        
        /*
        
        do {
            try thisPin.managedObjectContext?.save()
            print(thisPin)
            print("thisPin.photos afer save", thisPin.photos)
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
 */
       
       
       /*
        for pin in fetchedObjects! {
            //print(pin)
            //self.getLatLon(pin as! Pin)
            
            
             print("about to add to thisPin", pin)
            print("adding this photoURLString", photoURLString)
            
            let newPhoto = Photo(imageData: photoURLString, context: fetchedResultsController!.managedObjectContext )
            newPhoto.pin = pin as! Pin
            print(pin)
            

        }
 */
       
        
        /*
        let pin = fetchedObjects![0]
        print(pin)
        let managedContext = fetchedResultsController!.managedObjectContext
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: managedContext)
        let newPhoto = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        newPhoto.setValue(photoURLString,forKey:"imageData")
        do {
            try managedContext.save()
            pin.photos.append(newPhoto)
        }
        catch let error as NSError {
            print("error in adding photo")
        }
        
 */
        //let newPhoto = Photo(entity: Photo() as! NSEntityDescription, insertIntoManagedObjectContext: fetchedResultsController!.managedObjectContext )
        
        }
    
    
/*
    func getPhotos(completionHandlerForGET:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        print("getPhotos")
        
        
        let session = NSURLSession.sharedSession()
        
        //let flickrSearchURL = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d590bf9e37f0415994f25fa25cc23dc7&bbox=-123.8587455078125,46.35308398800007,bbox=-123.8587455078125,46.35308398800007,48.587958419830336&accuracy=1&safe_search=1&extras=url_m&format=json&nojsoncallback=1&per_page=5")!
        
        var bboxString = "lon="
        var bboxSelectedLongitude:NSString = selectedLongitude
        print(bboxSelectedLongitude)
        
        bboxString = bboxString + (bboxSelectedLongitude as String)
        
        bboxString = bboxString + "&lat="
        
        var bboxSelectedLatitude:NSString = selectedLatitude

        print(bboxSelectedLatitude)
        bboxString = bboxString + (bboxSelectedLatitude as String)

        
        var flickrSearchURLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d590bf9e37f0415994f25fa25cc23dc7&"
        flickrSearchURLString = flickrSearchURLString + bboxString
        flickrSearchURLString = flickrSearchURLString + "&radius=20&accuracy=1&safe_search=1&extras=url_m&format=json&nojsoncallback=1&per_page=5"
        print(" ")
        print("flickrSearchURLString", flickrSearchURLString)
        
        
        var flickrSearchURL = NSURL(string: flickrSearchURLString)!
        print(" ")
        print("flickrSearchURL", flickrSearchURL)
        
        let request = NSMutableURLRequest(URL: flickrSearchURL)
        print(" ")
        print(request)

        let task = session.dataTaskWithRequest(request) {(data, response, error) in
            
            
            func displayError(error: String) {
                print(error)
            }
            
            guard (error == nil) else {
                //displayError("There was an error with your request: \(error)")
                print("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                //displayError("Your request returned a status code other than 2xx!")
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            guard data != nil else {
                //displayError("No data was returned by the request!")
                print("No data was returned by the request!")
                
                return
            }
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForGET)
            print("data returned")

        }
 

        task.resume()
        return task
    }
*/    
    
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
        print("collectionView returnedPhotosArray.count", self.returnedPhotosArray.count)
        
        
        let fetchedObjects = testFetchedResultsController?.fetchedObjects
       
        let  thisPin = fetchedObjects![0] as! Pin
        print("collectionView thisPin.photos.count", thisPin.photos?.count)
        
        
       

        //return (thisPin.photos?.count)!
        return (self.returnedPhotosArray.count)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("cellForItemAtIndexPath")
        
  
        let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
/*
       // let fetchedObjects = testFetchedResultsController?.fetchedObjects

        //let  thisPin = fetchedObjects![0] as! Pin

        let thisPin = testFetchedResultsController?.objectAtIndexPath(indexPath) as! Pin
        print("thisPin", thisPin)
        let thisPinPhotos = thisPin.photos
        print("thisPinPhotos",thisPinPhotos)
        
        
        
        //print("thisPin photo url",thisPin.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))
        if let thisPhotoString = thisPin.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m") {
        
        print("thisPhoto", thisPhotoString)
        let imageURL = NSURL(string: thisPhotoString as! String)
        
        if let imageData = NSData(contentsOfURL: imageURL!) {
            dispatch_async(dispatch_get_main_queue()) {
                photoCell.photoImageView.image = UIImage(data: imageData)
            }
            }
            
        }

 */


        if self.returnedPhotosArray.count > 0 {
            print("in cellForItemAtIndexPath self.returnedPhotosArray.count", self.returnedPhotosArray.count)
            
            let thisReturnedPhoto = self.returnedPhotosArray[indexPath.item]
            
            
            let imageURL = NSURL(string: 
             thisReturnedPhoto as! String)
            print("imageURL", imageURL)
            
       
            if let imageData = NSData(contentsOfURL: imageURL!) {
                dispatch_async(dispatch_get_main_queue()) {
                    photoCell.photoImageView.image = UIImage(data: imageData)
                }

            }
           
            
            /*
            
            let request  = NSURLRequest(URL: imageURL!)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, downloadError in
                if let error = downloadError {
                    print(error)
                }
                else {
                    let imageData = UIImage(data: data!)
                    dispatch_async(dispatch_get_main_queue()) {
                        photoCell.photoImageView.image = UIImage(data: imageData)
                }
            */
 
        }
 
 
     
        
        return photoCell
    }
    
    @IBAction func newCollectionPressed(sender: AnyObject) {
        print("newCollectionPressed")
    }
    
  /*
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
        let photo = fetchedResultsController!.objectAtIndexPath(indexPath) as! Photo
        CoreDataStackManager.sharedInstance().deleteObject(photo)
    }
 */
    
}




