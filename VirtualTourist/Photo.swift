//
//  Photo.swift
//  VirtualTourist
//
//  Created by Laurie Wheeler on 6/28/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
class Photo: NSManagedObject {

    convenience init(imageData: String, context: NSManagedObjectContext) {
        
        print(" ")
        print("Photo init", imageData)
       
        var newPhoto = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: context) as! Photo
        self.init()
        self.imageData = imageData
        
       
        
        
       
       /*
        if let ent = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context) {
            self.init(entity:ent, insertIntoManagedObjectContext: context)
            self.imageData = imageData
        }else{
            fatalError("Unable to find Entity name!")
        }
        
       */
    }
 

}
