//
//  PersistentLocations.swift
//  ISSLive
//
//  Created by Alex on 08/02/22.
//

import UIKit
import Foundation
import CoreData

final class PersistentLocations {
    static let shared = PersistentLocations()
    var locations: [NSManagedObject] = []

    func saveLocation() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constant.Home.entityName)
        
        do {
            locations = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError(("Could not fetch. \(error), \(error.userInfo)"))
        }
    }
}
