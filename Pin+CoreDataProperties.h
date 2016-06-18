//
//  Pin+CoreDataProperties.h
//  VirtualTourist
//
//  Created by Laurie Wheeler on 6/18/16.
//  Copyright © 2016 Student. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Pin.h"

NS_ASSUME_NONNULL_BEGIN

@interface Pin (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *latitude;
@property (nullable, nonatomic, retain) NSData *longitude;
@property (nullable, nonatomic, retain) NSSet<Photo *> *photo;

@end

@interface Pin (CoreDataGeneratedAccessors)

- (void)addPhotoObject:(Photo *)value;
- (void)removePhotoObject:(Photo *)value;
- (void)addPhoto:(NSSet<Photo *> *)values;
- (void)removePhoto:(NSSet<Photo *> *)values;

@end

NS_ASSUME_NONNULL_END
