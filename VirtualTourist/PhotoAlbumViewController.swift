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
    
    var mapLatitude = ""
    var mapLongitude = ""
    
    var fetchedResultsController:NSFetchedResultsController? {
        didSet {
            //fetchedResultsController?.delegate = self
            print("PhotoAlbumViewController fetchedResultsController ")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PhotoAlbumViewController viewDidLoad")
        
        print("mapLatitude", mapLatitude)
        print("mapLongitude", mapLongitude)
        
       /*
        
        let fr = NSFetchRequest(entityName: "Pin")
        fr.setValue(mapLatitude, forKey: latitude)
        fr.sortDescriptors = [NSSortDescriptor(key: "location", ascending:  true)]
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
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

        */
        
        getPhotos()
        
        //FlickrPhotos.getPhotos().response
        
        //self.mapView.delegate = self
        
        // from legacy PersistentObjects & Core Data - Find the Context
       // let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let context = appDelegate.managedObjectContext
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("PhotoAlbumViewController viewWillAppear")
        
        
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
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d590bf9e37f0415994f25fa25cc23dc7&text=cats&safe_search=1&extras=url_m&format=json&nojsoncallback=1")!)
        
        let task = session.dataTaskWithRequest(request) {(data, response, error) in
            func displayError(error: String) {
                print(error)
            }
            
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            print("data returned")
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                print(parsedResult)
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
 
         
        }
     
        

        
        task.resume()
        return task
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionView numberOfItemsInSection")
        //return memes.count
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("MemeCollectionViewController cellForItemAtIndexPath")
        let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
        
        
       // let memeCell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        //let meme = memes[indexPath.row]
        
        //photoCell.photoImageView.image = meme.memedImage
        
        //photoCell.photoImageView.image = par
        return photoCell
    }
}




