//
//  MPSImage+CoreDataProperties.swift
//  MyPhotoStream
//
//  Created by Pavan on 09/05/17.
//  Copyright © 2017 Pavan. All rights reserved.
//

import Foundation
import CoreData


extension MPSImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MPSImage> {
        return NSFetchRequest<MPSImage>(entityName: "MPSImage")
    }

    @NSManaged public var image: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var smallDescription: String?
    @NSManaged public var downloadURLStr: String?
    @NSManaged public var imageId: String?
}
