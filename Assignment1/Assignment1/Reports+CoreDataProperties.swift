  //
//  Reports+CoreDataProperties.swift
//  Assignment1
//
//  Created by Niamh Gallagher on 20/03/2019.
//  Copyright © 2019 Niamh Gallagher. All rights reserved.
//
//

import Foundation
import CoreData


extension Reports {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reports> {
        return NSFetchRequest<Reports>(entityName: "Reports")
    }

    @NSManaged public var authors: String?
    @NSManaged public var document: String?
    @NSManaged public var email: String?
    @NSManaged public var title: String?
    @NSManaged public var id: String?
    @NSManaged public var owner: String?
    @NSManaged public var pdf: URL?
    @NSManaged public var comment: String?
    @NSManaged public var lastModified: String?
    @NSManaged public var year: String?

}
