//
//  StoredPrayers+CoreDataProperties.swift
//  myPray
//
//  Created by Mohammed Owynat on 7/02/2016.
//  Copyright © 2016 Mohammed Owynat. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension StoredPrayers {

    @NSManaged var fajrTime: String?
    @NSManaged var sunriseTime: String?
    @NSManaged var dhuhurTime: String?
    @NSManaged var asrTime: String?
    @NSManaged var maaghribTime: String?
    @NSManaged var ishaTime: String?

}
