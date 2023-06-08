//
//  TimeStamp.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 02/06/23.
//

import Foundation
import CoreData

@objc(TimeStamp)
class TimeStamp: NSManagedObject {
    @NSManaged var timeStamp: Int
}

extension TimeStamp {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeStamp> {
        return NSFetchRequest<TimeStamp>(entityName: "TimeStamp")
    }
}
