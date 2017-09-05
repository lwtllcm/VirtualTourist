//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Laurie Wheeler on 8/3/16.
//  Copyright © 2016 Student. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var imageData: Data?
    @NSManaged var pin: Pin?

}
