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
    
    
    //photoAlbumViewController.mapLatitude = "52.247849103093301"
    //photoAlbumViewController.mapLongitude = "-105.589742638687"
    
    var mapLatitude = "12.820669628231199"
    var mapLongitude = "-84.372921928403002"
    

    /*
    var flickrPhotos:[FlickrPhotos] {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.flickrPhotos
    }
*/
    var returnedPhotos = []
    var returnedPhotosArray:NSMutableArray = []
    
    var fetchedResultsController:NSFetchedResultsController? {
        didSet {
            //fetchedResultsController?.delegate = self
            
            print("PhotoAlbumViewController fetchedResultsController ")
            executeSearch()
        }
    }
    
    
    func executeSearch() {
        print("executeSearch")
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
                print("fetched objects",fc.fetchedObjects)
            }
            catch {
                print ("error in performFetch")
            }
        }
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PhotoAlbumViewController viewDidLoad")
        print("mapLatitude", mapLatitude)
        print("mapLongitude", mapLongitude)
        
        let space: CGFloat = 3.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumLineSpacing = space        
        flowLayout.itemSize = CGSizeMake(100.0, 100.0)
        
      
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        
        let fr = NSFetchRequest(entityName: "Pin")
       //fr.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending:  true), NSSortDescriptor(key: "longitude", ascending:  true)]
        fr.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending:  true)]

        
        let testLatitudePredicate = 52.247849103093301
        //let latitudePredicate = NSPredicate(format: "latitude == 52.247849103093301")
        let latitudePredicate = NSPredicate(format: "latitude == 34.272264291400298")
        let longitudePredicate = NSPredicate(format: "longitude = %@", mapLongitude)
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [latitudePredicate, longitudePredicate])
        
        //fr.predicate = andPredicate
       
        fr.predicate = latitudePredicate

        print("fr", fr)

        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        print("PhotoAlbumViewController fetched results count",fetchedResultsController!.fetchedObjects?.count)
       
        //executeSearch()
        
        //print("after executeSearch", fetchedResultsController?.fetchedObjects)
        
        
        
        //let testURL:NSURL = NSURL(fileURLWithPath:"https://farm9.staticflickr.com/8619/28026418440_2b155fb1a4.jpg")
        //print(testURL)
        //var error:NSError?
        
        let testImage = UIImage(data: NSData(contentsOfURL: NSURL(string:"https://farm9.staticflickr.com/8619/28026418440_2b155fb1a4.jpg")!)!)
        self.returnedPhotosArray.addObject(testImage!)
        
        //var testImage:UIImage? = UIImage(data: testURL as NSURL, scale: &error)
        /*
        if let testReturnedPhotoImage:UIImage = UIImage(data: NSData(contentsOfURL:testURL)!){
            print("testReturnedPhotoImage OK")
            self.returnedPhotosArray.addObject(testReturnedPhotoImage)

        }
 */
        
        
        // let thisFlickrPhotoThumbnail = thisFlickrPhoto.objectForKey("url_m") as! UIImage
        //photoCell.photoImageView.image = thisReurnedPhotoImage
        
       // self.returnedPhotosArray.addObject(testReturnedPhotoImage)
        print("returnedPhotosArray with initial hard coded image",returnedPhotosArray.count)

        
        
        
        
        
        if fetchedResultsController?.fetchedObjects?.count == 0 {
            print("fetchedResultsController?.fetchedObjects?.count == 0")
        }
        else {
        
        for result in (fetchedResultsController?.fetchedObjects)! {
           // print(result.valueForKey("photos"))
           // print(result.valueForKey("latitude"))
            
            if let thisPhoto = result.valueForKey("photos") {
                print("photos found count", thisPhoto.count)
                if thisPhoto.count == 0 {
                    
                    getPhotos()
                    
                    print("viewDidLoad after getPhotos", self.returnedPhotosArray)

                    
                   // print("flickrPhotos.count",flickrPhotos.count)
                   // self.reloadInputViews()
                   // print(result.valueForKey("url_m"))
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.reloadInputViews()
                    }
                    
                }
                
            }
            else {
                print("photo not found")
            }
            
            /*
            if let photo = result.photos  as! Photo{
                returnedPhotos.append(photo)
            }
            else {
                print("no result photos")
            }
        }
 */
            //photos.append(result.photos as! Photo)
            //print("photos", photos)
        }
        
        /*
        print(fetchedResultsController.fetchedObjects)
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

        */
        
        //getPhotos()
        
        //FlickrPhotos.getPhotos().response
        
        //self.mapView.delegate = self
        
        // from legacy PersistentObjects & Core Data - Find the Context
       // let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let context = appDelegate.managedObjectContext
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("PhotoAlbumViewController viewWillAppear")
        
        /*
        dispatch_async(dispatch_get_main_queue()) {
            self.reloadInputViews()
        }

        */
    }
    
    func getPhotos() -> NSURLSessionDataTask {
        print("getPhotos")
        
        
        //var session = NSURLSession.sharedSession()
        /*
         let task =  session.dataTaskWithRequest(request) {data, response, error in
         print(response)
         var parsedResult: AnyObject!
         parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
         
         */
        let session = NSURLSession.sharedSession()
        
       // let request = NSMutableURLRequest(URL: NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.places.search&api_key=b0d07eb44e2ff9d792583e75b89f898a&query=california&format=rest&api_sig=7eeb526bfcb9f394c574d0a5c0930d52")!)
        
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d590bf9e37f0415994f25fa25cc23dc7&text=cats&safe_search=1&extras=url_m&format=json&nojsoncallback=1")!)
      
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d590bf9e37f0415994f25fa25cc23dc7&bbox=-123.8587455078125,46.35308398800007,-120.5518607421875,48.587958419830336&accuracy=1&safe_search=1&extras=url_m&format=json&nojsoncallback=1")!)
        //print(request)

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
            
            guard let data = data else {
                //displayError("No data was returned by the request!")
                print("No data was returned by the request!")
                
                return
            }
            print("data returned")
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
               // print("parsedResult", parsedResult)
                
                self.returnedPhotos = (parsedResult.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
                
           //     self.flickrPhotos = (parsedResult.valueForKey("photos")?.valueForKey("photo")!.valueForKey("url_m"))! as! NSArray
                
                
                print("returnedPhoto", self.returnedPhotos)
                
                for photo in self.returnedPhotos {
                    self.returnedPhotosArray.addObject(photo)
                    
                }
                
                print("returnedPhotosArray", self.returnedPhotosArray)

                
               //self.returnedPhotos.append(returnedPhoto) as! NSURL
                
              //  print("returnedPhotos", self.flickrPhotos)
                
                
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
 
         
        }
     
        

        
        task.resume()
        return task
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionView numberOfItemsInSection", self.returnedPhotosArray.count)

        //return self.returnedPhotosArray.count
        
        return 1
        //return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
      //  print("PhotoAlbumCollectionViewController cellForItemAtIndexPath - flickrPhotos.count",flickrPhotos.count)
        
        //let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
        
        
        
       let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
       print("self.returnedPhotosArray.count", self.returnedPhotosArray.count)
        if self.returnedPhotosArray.count > 0 {
            print("self.returnedPhotosArray.count > 0")
            let thisReturnedPhoto = self.returnedPhotosArray[indexPath.item]
            //let thisReturnedPhotoImage:UIImage = UIImage(data: NSData(contentsOfURL: thisReturnedPhoto as! NSURL)!)!
            
            
            
            print("thisFlickrPhoto", thisReturnedPhoto)
            
           // let thisFlickrPhotoThumbnail = thisFlickrPhoto.objectForKey("url_m") as! UIImage
           // photoCell.photoImageView.image = thisReturnedPhotoImage
            
            photoCell.photoImageView.image = thisReturnedPhoto as! UIImage
        }
      
        
        
        
        
        
       // let photo = returnedPhotos[indexPath.row] as! UIImage
        
        //let image = photo as! UIImage
        
        
      //  photoCell.photoImageView.image = photo
        
        
       /* dispatch_async(dispatch_get_main_queue()) {
            photoCell.photoImageView.image = photo
        }
*/
       
        
        //photoCell.photoImageView.image = meme.memedImage
        
        //photoCell.photoImageView.image = parsedResults.
        
        //print(fetchedResultsController?.fetchedObjects.)
        
        return photoCell
    }
}




