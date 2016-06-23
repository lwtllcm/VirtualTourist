//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Laurie Wheeler on 6/18/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
       
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PhotoAlbumViewController viewDidLoad")
        
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
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b0d07eb44e2ff9d792583e75b89f898a&text=cats&safe_search=1&extras=url_m&format=json&nonsoncallback=1")!)
        
        let task = session.dataTaskWithRequest(request) {(data, response, error) in
            func displayError(error: String) {
                print(error)
            }
            
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
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
}




