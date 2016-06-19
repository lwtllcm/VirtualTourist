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
        //self.mapView.delegate = self
        
        // from legacy PersistentObjects & Core Data - Find the Context
       // let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let context = appDelegate.managedObjectContext
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("PhotoAlbumViewController viewWillAppear")
        
        
    }
    
  
    
}


