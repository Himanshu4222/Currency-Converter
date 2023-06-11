//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
//  MARK: Persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    lazy var persistentContainer: NSPersistentContainer =  {
        let container = NSPersistentContainer(name: "CurrencyConverter")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unesolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
//  MARK: Application window start
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)

        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()

        self.window = window
        self.appCoordinator = appCoordinator

        return true
    }
}

