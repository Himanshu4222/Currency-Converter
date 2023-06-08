//
//  StorageService.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 01/06/23.
//

import UIKit
import CoreData

protocol StorageServiceProtocol {
    func saveCurrencyRates(currencyRates: [CurrencyDetailModel])
    func retrieveCurrencyRatesData() -> [CurrencyDetailModel]
    func saveCurrentTimeStamp()
    func retrieveSavedTimeStamp() -> Int?
}

class StorageService: StorageServiceProtocol {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func saveCurrencyRates(currencyRates: [CurrencyDetailModel]) {
        
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            try managedContext.performAndWait {
                let fetchRequest: NSFetchRequest<CurrencyRates> = CurrencyRates.fetchRequest()
                let existingNames = currencyRates.map { $0.name }
                fetchRequest.predicate = NSPredicate(format: "\(Constants.Strings.entity_CurrencyRates_Attribute_name) IN %@", existingNames)
                let existingCurrencyRates = try managedContext.fetch(fetchRequest)
                
                currencyRates.forEach { currency in
                    if let existingCurrencyRate = existingCurrencyRates.first(where: { ($0.value(forKey: Constants.Strings.entity_CurrencyRates_Attribute_name) as? String) == currency.name }) {
                        existingCurrencyRate.name = currency.name
                        existingCurrencyRate.value = currency.value
                        
                    } else {
                        let currencyRatesEntity = CurrencyRates(context: managedContext)
                        currencyRatesEntity.name = currency.name
                        currencyRatesEntity.value = currency.value
                    }
                }
                
                try managedContext.save()
                saveCurrentTimeStamp()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveCurrencyRatesData() -> [CurrencyDetailModel] {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CurrencyRates> = CurrencyRates.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: Constants.Strings.entity_CurrencyRates_Attribute_name, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as [CurrencyRates]
            return fetchedResults.map({CurrencyDetailModel(name: $0.name, value: $0.value)})
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
        }
        return []
    }
    
    func saveCurrentTimeStamp() {
        let managedContext = appDelegate.persistentContainer.viewContext
        let currentTimeStamp = Int(Date().timeIntervalSince1970)
        
        do {
            try managedContext.performAndWait {
                let fetchRequest: NSFetchRequest<TimeStamp> = TimeStamp.fetchRequest()
                let existingTimeStamp = try managedContext.fetch(fetchRequest)
                if existingTimeStamp.isEmpty {
                    let timeStampEntity = TimeStamp(context: managedContext)
                    timeStampEntity.timeStamp = currentTimeStamp
                } else {
                    existingTimeStamp.forEach { timeStamp in
                        timeStamp.timeStamp = currentTimeStamp
                    }
                }
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveSavedTimeStamp() -> Int? {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TimeStamp> = TimeStamp.fetchRequest()
        
        do {
            let result = try managedContext.fetch(fetchRequest) as [TimeStamp]
            return !result.isEmpty ? result.first!.timeStamp : 0
            
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
        }
        return nil
    }
}

extension StorageService {
    private struct Constants {
        struct Strings {
            static let entity_CurrencyRates = "CurrencyRates"
            static let entity_CurrencyRates_Attribute_name = "name"
            static let entity_CurrencyRates_Attribute_value = "value"
            
            static let entity_TimeStamp = "TimeStamp"
            static let entity_TimeStamp_Attribute_timeStamp = "timeStamp"
        }
    }
}
