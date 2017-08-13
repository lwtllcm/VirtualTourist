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

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var NewCollectionButton: UIButton!
    
    //var returnedPhotoURLs = []
    var returnedPhotosArray:NSMutableArray = []
    
    var theseReturnedPhotoURLs:NSMutableArray = []
    
    //var testFetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>?
    
    var testFetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            executeSearch()
        }
        
    }
    
    func executeSearch() {
        
        print("executeSearch")
        
        if let fc = testFetchedResultsController {
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
        //flowLayout.itemSize = CGSizeMake(100.0, 100.0)
        
        returnedPhotosArray.removeAllObjects()
        
    }
    
    
    //viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("photo album viewwillappear")
        //show focused map for selected pin
        
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "location", ascending:  true)]
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        testFetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        
        let mapSpan = MKCoordinateSpanMake(2.0, 2.0)
        
        let fetchedObjects = testFetchedResultsController?.fetchedObjects as! NSMutableArray
        print("fetchedObjects",fetchedObjects as Any)
        
        for pin in fetchedObjects {
            
            getLatLon(pin: pin as! Pin)
        }
        
        let mapRegion =
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:CLLocationDegrees(selectedLatitude)!,
                                                              longitude:CLLocationDegrees(selectedLongitude)!), span: mapSpan)
        
        mapView.setRegion(mapRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate =
            CLLocationCoordinate2D(latitude:CLLocationDegrees(selectedLatitude)!, longitude:CLLocationDegrees(selectedLongitude)!)
        
        mapView.addAnnotation(annotation)
        
        collectionView.reloadData()

        
        
        
        let  thisPin = fetchedObjects[0] as! Pin
        
        
        print("viewWillAppear",thisPin.photos?.count as Any)
        if thisPin.photos?.count == 0 {
            
            GetPhotos.sharedInstance().getPhotos(selectedLatitude: selectedLatitude, selectedLongitude: selectedLongitude, page:flickrPage) {(results, error)   in
                
                if (error != nil) {
                    
                    let uiAlertController = UIAlertController(title: "download photos error", message: "error in downloadPhotos", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    uiAlertController.addAction(defaultAction)
                    self.present(uiAlertController, animated: true, completion: nil)
                    
                }
                else {
                    
                    //print("results", results as! [String:AnyObject] )
                    //let resultsArray = (results?.value(forKey: "photos") )
                   
                    //print("resultsArray",resultsArray)
                    
                    
                                        
                    self.newDownload = true
                    
                    let resultsDictionary = results?["photos"] as! [String:Any]
                    let resultPhotoArray = resultsDictionary["photo"] as! NSArray
                   // let thisPhotoResult = resultPhotoArray[0] as! [String:Any]
                    
                    //print("url_m", thisPhotoResult["url_m"])

                    for index in resultPhotoArray  {
                        let thisPhotoResult = index as! [String:Any]
                        self.theseReturnedPhotoURLs.add(thisPhotoResult["url_m"] as! String)
                    }
                    
                    
                    //self.theseReturnedPhotoURLs = (results?.value(forKey: "photos")?.valueForKey("photo")?.valueForKey("url_m"))! as! NSArray
                    
                    
                     
                    print(self.theseReturnedPhotoURLs)
                    print(self.theseReturnedPhotoURLs.count)
                    
                    DispatchQueue.main.async() {
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
    
    func downloadPhotos (thisURL:NSString, completionHandler:(AnyObject?,
        NSError?) -> Void) {
        
        
        
        print("downloadPhotos existing count", thisURL)
        
        let photoURLFromGetPhotos = NSURL(string: thisURL as String)
        
        let photoImageFromGetPhotos = NSData(contentsOf:photoURLFromGetPhotos! as URL)
        
        
        
        completionHandler(photoImageFromGetPhotos, nil)
    }
    
    func getLatLon(pin:Pin) {
        selectedLatitude = pin.latitude!
        selectedLongitude = pin.longitude!
    }
    
    
    
    func addPhotos(thisPin:Pin, thisPhoto:NSData) {
        
        let photo = Photo(imageData: thisPhoto as Data, context: testFetchedResultsController!.managedObjectContext)
        
        photo.pin = thisPin
        
        do {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let stack = delegate.stack
            
            try stack.save()
        }catch{
            let uiAlertController = UIAlertController(title: "addPhotos error", message: "error in addPhotos", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            uiAlertController.addAction(defaultAction)
            present(uiAlertController, animated: true, completion: nil)
            
        }
        
    }
    
    
    func collectionView(_: UICollectionView, numberOfItemsInSection: Int) -> Int {
    
    //func numberOfItems(inSection: Int) -> Int {

    
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
    
    
    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath as IndexPath) as! PhotoCollectionViewCell
        
        photoCell.backgroundColor = UIColor.blue
        //photoCell.activityIndicator.startAnimating()
        photoCell.activityIndicator.stopAnimating()
        
        
        let fetchedObjects = self.testFetchedResultsController?.fetchedObjects
        
        let  thisPin = fetchedObjects![0] as! Pin
        
        //print("newDownload", newDownload)
        
        if newDownload == false {
            
            let photoSet = (thisPin.photos as! Set<Photo>)
            
            let photoArray = Array(photoSet)
            if photoArray.count > 0 {
                
                let thisPhoto = photoArray[indexPath.item]
                
                DispatchQueue.main.async() {
                    photoCell.activityIndicator.stopAnimating()
                    photoCell.photoImageView.image = UIImage(data:thisPhoto.imageData!)
                }
                
            }
            
        }
            
        else {
            
            NewCollectionButton.isEnabled = false
            photoCell.activityIndicator.startAnimating()
            
            DispatchQueue.global(qos: .background).async {
               
    //        DispatchQueue.global(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0).async(execute: {
                
                let photoURLFromGetPhotos = NSURL(string: self.theseReturnedPhotoURLs[indexPath.item] as! String)
                print(photoURLFromGetPhotos)
                
                let photoImageFromGetPhotos = NSData(contentsOf:photoURLFromGetPhotos! as URL)
                print(photoImageFromGetPhotos)
                
                
                let thisImage = UIImage(data:photoImageFromGetPhotos! as Data )
                
                DispatchQueue.main.async() {
                    self.addPhotos(thisPin: thisPin, thisPhoto: photoImageFromGetPhotos! )
                    
                    
                    photoCell.activityIndicator.stopAnimating()
                    
                    photoCell.photoImageView.image = thisImage
                    
                }
                self.NewCollectionButton.isEnabled = true
            }
 
        }
        
        
        return photoCell
    }
    
    
    
    @IBAction func newCollectionPressed(_ sender: AnyObject) {
        
        
        //
        /*
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "location", ascending:  true)]
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        testFetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let fetchedObjects = testFetchedResultsController?.fetchedObjects as! NSMutableArray

       */

        print("newCollectionPressed")
        
        
        let fetchedObjects = testFetchedResultsController?.fetchedObjects
        
        let  thisPin = fetchedObjects?[0] as! Pin
        let photoSet = (thisPin.photos as! Set<Photo>)
        
        var photoArray = Array(photoSet)
        
        //photoArray.removeAll()
        
        //
        thisPin.photos = NSSet(array: photoArray)
        for photo in thisPin.photos!{
            if let context = testFetchedResultsController?.managedObjectContext {
                
                context.delete(photo as! NSManagedObject)
            }
            
        }
        
        
        
        print("newCollectionPressed after delete - photoArray.count", photoArray.count)
        
        print("newCollectionPressed after delete - thisPin.photos count", thisPin.photos!.count)
        
        
        let randomPage = Int(arc4random_uniform(UInt32(max(40,flickrTotPages))))
        print("randomPage", randomPage)
        
        GetPhotos.sharedInstance().getPhotos(selectedLatitude: selectedLatitude, selectedLongitude: selectedLongitude, page: randomPage) {(results, error)   in
            
            if (error != nil) {
                
                let uiAlertController = UIAlertController(title: "download photos error", message: "error in downloadPhotos", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.present(uiAlertController, animated: true, completion: nil)
                
            }
            else {
                
                
                self.newDownload = true
                
                let resultsDictionary = results?["photos"] as! [String:Any]
                let resultPhotoArray = resultsDictionary["photo"] as! NSArray
                // let thisPhotoResult = resultPhotoArray[0] as! [String:Any]
                
                //print("url_m", thisPhotoResult["url_m"])
                
                for index in resultPhotoArray  {
                    let thisPhotoResult = index as! [String:Any]
                    self.theseReturnedPhotoURLs.add(thisPhotoResult["url_m"] as! String)
                }
                
                
            //    self.theseReturnedPhotoURLs = (((results?.value(forKey: "photos") as AnyObject).value(forKey: "photo") as AnyObject).value(forKey: "url_m"))! as! NSArray
                print(self.theseReturnedPhotoURLs)
                print(self.theseReturnedPhotoURLs.count)
                
                DispatchQueue.main.async() {
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
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let stack = delegate.stack
            stack.context.delete(photoArray[indexPath.item])
            try stack.save()
            print("didSelectItemAtIndexPath count after deleteObject", thisPin.photos!.count)
            
            
        }
        catch {
            let uiAlertController = UIAlertController(title: "delete photos error", message: "error in deletePhotos", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            uiAlertController.addAction(defaultAction)
            present(uiAlertController, animated: true, completion: nil)
            
        }
        
        DispatchQueue.main.async() {
            collectionView.reloadData()
            
        }
        
    }
    
}
