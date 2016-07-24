//
//  CoreDataController.swift
//  VirtualTourist
//
//  Created by Laurie Wheeler on 7/3/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import CoreData

//class  CoreDataController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
 /*
    var fetchedResultsController : NSFetchedResultsController?{
        didSet{
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
            executeSearch()
           // tableView.reloadData()
        }
    }
    
    init(fetchedResultsController fc : NSFetchedResultsController,
                                  style : UICollectionViewStyle = .Plain){
        fetchedResultsController = fc
        super.init(style: style)
        
        
    }
    
    // Do not worry about this initializer. I has to be implemented
    // because of the way Swift interfaces with an Objective C
    // protocol called NSArchiving. It's not relevant.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}

func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    print("cellForItemAtIndexPath")
    
    
    let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
    
    
    return photoCell
}


// MARK:  - Fetches
extension CoreDataController{
    
    func executeSearch(){
        if let fc = fetchedResultsController{
            do{
                try fc.performFetch()
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
}


// MARK:  - Delegate
extension CoreDataController: NSFetchedResultsControllerDelegate{
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        collectionView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                                     atIndex sectionIndex: Int,
                                             forChangeType type: NSFetchedResultsChangeType) {
        
        let set = NSIndexSet(index: sectionIndex)
        
        switch (type){
            
        case .Insert:
            tableView.insertSections(set, withRowAnimation: .Fade)
            
        case .Delete:
            tableView.deleteSections(set, withRowAnimation: .Fade)
            
        default:
            // irrelevant in our case
            break
            
        }
    }
    
    
    func controller(controller: NSFetchedResultsController,
                    didChangeObject anObject: AnyObject,
                                    atIndexPath indexPath: NSIndexPath?,
                                                forChangeType type: NSFetchedResultsChangeType,
                                                              newIndexPath: NSIndexPath?) {
        
        guard let newIndexPath = newIndexPath else{
            fatalError("No indexPath received")
        }
        switch(type){
            
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            
        case .Delete:
            tableView.deleteRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            
        case .Update:
            tableView.reloadRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
 */
//}


