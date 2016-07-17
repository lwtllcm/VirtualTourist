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
    
    
    var mapLatitude = "12.820669628231199"
    var mapLongitude = "-84.372921928403002"
    
    var returnedPhotoURLs = []
    var returnedPhotosArray:NSMutableArray = []
    
    var fetchedResultsController:NSFetchedResultsController? {
        didSet {
            
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
        
       // print("mapLatitude", mapLatitude)
       // print("mapLongitude", mapLongitude)
        
        let space: CGFloat = 3.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumLineSpacing = space        
        flowLayout.itemSize = CGSizeMake(100.0, 100.0)
        
      
        
       // let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
       // let stack = delegate.stack
        
        let fr = NSFetchRequest(entityName: "Pin")
 
        fr.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending:  true)]

        
        //let testLatitudePredicate = 52.247849103093301
                //let latitudePredicate = NSPredicate(format: "latitude == 52.247849103093301")
        
        let latitudePredicate = NSPredicate(format: "latitude == 34.272264291400298")
        
       // let longitudePredicate = NSPredicate(format: "longitude = %@", mapLongitude)
        
       // let andPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [latitudePredicate, longitudePredicate])
        
            //fr.predicate = andPredicate
     
        
        
        /*
        fr.predicate = latitudePredicate

        print("fr", fr)

        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        print("PhotoAlbumViewController fetched results count",fetchedResultsController!.fetchedObjects?.count)
       

        
        let testImage = UIImage(data: NSData(contentsOfURL: NSURL(string:"https://farm9.staticflickr.com/8619/28026418440_2b155fb1a4.jpg")!)!)
       // self.returnedPhotosArray.addObject(testImage!)
       // self.returnedPhotosArray.addObject(testImage!)
       // self.returnedPhotosArray.addObject(testImage!)

        //print("returnedPhotosArray with initial hard coded image",returnedPhotosArray.count)

        
        
        if fetchedResultsController?.fetchedObjects?.count == 0 {
            print("fetchedResultsController?.fetchedObjects?.count == 0")
        }
        else {
        
        for result in (fetchedResultsController?.fetchedObjects)! {
            
            if let thisPhoto = result.valueForKey("photos") {
                print("photos found count", thisPhoto.count)
                if thisPhoto.count == 0 {
                    
                   // getPhotos()
  
                    
                    getPhotos {(result, error) in
                    
                        if (error != nil) {
                            print("error returned from getPhotos")
                        }
                        else {
                        print("data after getPhotos - in completion handler", result)
                            var theseReturnedPhotoURLs = []
                            theseReturnedPhotoURLs = (result.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
                            //print("theseReturnedPhotoURLs", theseReturnedPhotoURLs)
                            for photoURL in theseReturnedPhotoURLs {
                                print("photoURL", photoURL)
                                self.returnedPhotosArray.addObject(photoURL)
                                print("self.returnedPhotosArray", self.returnedPhotosArray)
                            }
                        }
                        
                        
                    /*
                    let parsedResult: AnyObject!
                    do {
                        
                        parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                        
                        
                        self.returnedPhotoURLs = (parsedResult.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
                        print(self.returnedPhotoURLs)
                        
                        //var photoURLcount = 0
                        
                        for photoURL in self.returnedPhotoURLs {
                            
                            self.returnedPhotosArray.addObject(photoURL)
                            print("self.returnedPhotosArray", self.returnedPhotosArray)
                            
                            
                        }
                        
                        
                        
                    } catch {
                        displayError("Could not parse the data as JSON: '\(data)'")
                        return
                    }
                    
                    */
                }
                

                    
                    
                    
                    
                    //self.collectionView.reloadData()
                    print("returnedPhotosArray.count after getPhotos",self.returnedPhotosArray.count)
                    
                }
                
            }
            else {
                print("photo not found")
            }
        }
 
      }
 
 */
    }
    
    
    
    
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("PhotoAlbumViewController viewWillAppear")
        
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        
        let fr = NSFetchRequest(entityName: "Pin")
        
        fr.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending:  true)]
        
        
        //let testLatitudePredicate = 52.247849103093301
        //let latitudePredicate = NSPredicate(format: "latitude == 52.247849103093301")
        
        let latitudePredicate = NSPredicate(format: "latitude == 34.272264291400298")
        // let longitudePredicate = NSPredicate(format: "longitude = %@", mapLongitude)
        
        // let andPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [latitudePredicate, longitudePredicate])
        
        //fr.predicate = andPredicate
        
        
        
        
         fr.predicate = latitudePredicate
         
         print("fr", fr)
         
         
         fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
         
         print("PhotoAlbumViewController fetched results count",fetchedResultsController!.fetchedObjects?.count)
         
         
         
         let testImage = UIImage(data: NSData(contentsOfURL: NSURL(string:"https://farm9.staticflickr.com/8619/28026418440_2b155fb1a4.jpg")!)!)
         // self.returnedPhotosArray.addObject(testImage!)
         // self.returnedPhotosArray.addObject(testImage!)
         // self.returnedPhotosArray.addObject(testImage!)
         
         //print("returnedPhotosArray with initial hard coded image",returnedPhotosArray.count)
         
         
         
         if fetchedResultsController?.fetchedObjects?.count == 0 {
         print("fetchedResultsController?.fetchedObjects?.count == 0")
         }
         else {
         
         for result in (fetchedResultsController?.fetchedObjects)! {
         
         if let thisPhoto = result.valueForKey("photos") {
         print("photos found count", thisPhoto.count)
         if thisPhoto.count == 0 {
         
         // getPhotos()
         
         
         getPhotos {(result, error) in
         
         if (error != nil) {
         print("error returned from getPhotos")
         }
         else {
         print("data after getPhotos - in completion handler", result)
         var theseReturnedPhotoURLs = []
         theseReturnedPhotoURLs = (result.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
         //print("theseReturnedPhotoURLs", theseReturnedPhotoURLs)
         for photoURL in theseReturnedPhotoURLs {
         print("photoURL", photoURL)
         self.returnedPhotosArray.addObject(photoURL)
         print("self.returnedPhotosArray", self.returnedPhotosArray)
            
            
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.reloadData()
            }
         }
}
         
         
         /*
         let parsedResult: AnyObject!
         do {
         
         parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
         
         
         self.returnedPhotoURLs = (parsedResult.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
         print(self.returnedPhotoURLs)
         
         //var photoURLcount = 0
         
         for photoURL in self.returnedPhotoURLs {
         
         self.returnedPhotosArray.addObject(photoURL)
         print("self.returnedPhotosArray", self.returnedPhotosArray)
         
         
         }
         
         
         
         } catch {
         displayError("Could not parse the data as JSON: '\(data)'")
         return
         }
         
         */
         }
         
         
         
         
         
         
         //self.collectionView.reloadData()
         print("returnedPhotosArray.count after getPhotos",self.returnedPhotosArray.count)
         
         }
         
         }
         else {
         print("photo not found")
         }
         }
         
         }
         
        
        
        
        //self.collectionView.delegate = self
        //self.collectionView.reloadData()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView.reloadData()
        }
        
    }
 
    
    
    func getPhotos(completionHandlerForGET:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        print("getPhotos")
        
        
        let session = NSURLSession.sharedSession()
        
        let flickrSearchURL = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d590bf9e37f0415994f25fa25cc23dc7&bbox=-123.8587455078125,46.35308398800007,-120.5518607421875,48.587958419830336&accuracy=1&safe_search=1&extras=url_m&format=json&nojsoncallback=1&per_page=5")!
        
        let request = NSMutableURLRequest(URL: flickrSearchURL)

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
            
            guard data != nil else {
                //displayError("No data was returned by the request!")
                print("No data was returned by the request!")
                
                return
            }
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForGET)
            print("data returned")
          /*
            let parsedResult: AnyObject!
            do {
                
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)

                
                self.returnedPhotoURLs = (parsedResult.valueForKey("photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
                print(self.returnedPhotoURLs)

                //var photoURLcount = 0
                
                for photoURL in self.returnedPhotoURLs {
                    
                    self.returnedPhotosArray.addObject(photoURL)
                    print("self.returnedPhotosArray", self.returnedPhotosArray)
                    
                    
                               }
               

                
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
 
         */
        }
 

        task.resume()
        return task
    }
    
    
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
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
    

    
    
    func getImage(photoURLString:NSString) -> NSURLSessionDataTask {
        print("getImage")
        
        
        let session = NSURLSession.sharedSession()
        
        
        
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d590bf9e37f0415994f25fa25cc23dc7&bbox=-123.8587455078125,46.35308398800007,-120.5518607421875,48.587958419830336&accuracy=1&safe_search=1&extras=url_m&format=json&nojsoncallback=1&per_page=5")!)
        
        //print(request)
        
        let thisPhotoURL = NSURL(string:photoURLString as String)
        
        let task = session.dataTaskWithURL(thisPhotoURL!) {(data, response, error) in
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
            print("image returned")
            
            
            self.returnedPhotosArray.addObject(data)
            print(self.returnedPhotosArray.count)
            
            
        }
        
        
        task.resume()
        return task
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionView numberOfItemsInSection", self.returnedPhotosArray.count)

        
        //self.returnedPhotosArray
        return self.returnedPhotosArray.count
        
        //return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("cellForItemAtIndexPath")
        
        
        
        //self.returnedPhotosArray
        
        
       let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
       //print("self.returnedPhotosArray.count", returnedPhotosArray.count)
        
       if self.returnedPhotosArray.count > 0 {
            print("in cellForItemAtIndexPath self.returnedPhotosArray.count", self.returnedPhotosArray.count)
            
            let thisReturnedPhoto = self.returnedPhotosArray[indexPath.item]
            
            //print("thisFlickrPhoto", thisReturnedPhoto)
            
            
            let imageURL = NSURL(string: thisReturnedPhoto as! String)
            print("imageURL", imageURL)
        
            if let imageData = NSData(contentsOfURL: imageURL!) {
                dispatch_async(dispatch_get_main_queue()) {
                    photoCell.photoImageView.image = UIImage(data: imageData)
                }

            }
 
        }
        
        
        
        return photoCell
    }
}




