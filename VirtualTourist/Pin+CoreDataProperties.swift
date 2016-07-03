//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Laurie Wheeler on 6/28/16.
//  Copyright © 2016 Student. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pin {

    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var location: String?
    @NSManaged var photos: NSSet?

}
