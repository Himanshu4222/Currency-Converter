//
//  CurrencyRate.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 02/06/23.
//

import Foundation
import CoreData

@objc(CurrencyRates)
class CurrencyRates: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var value: Double
}

extension CurrencyRates {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyRates> {
        return NSFetchRequest<CurrencyRates>(entityName: "CurrencyRates")
    }
}

