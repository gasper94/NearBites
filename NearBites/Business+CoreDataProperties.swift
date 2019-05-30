//
//  Business+CoreDataProperties.swift
//  
//
//  Created by Paul Ancajima on 12/12/18.
//
//

import Foundation
import CoreData


extension Business {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Business> {
        return NSFetchRequest<Business>(entityName: "Business")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: NSData?
    @NSManaged public var address: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var starRating: NSData?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double

}
