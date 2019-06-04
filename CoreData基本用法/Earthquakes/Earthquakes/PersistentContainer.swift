//
//  PersistentContainer.swift
//  Earthquakes
//
//  Created by 胜的钱 on 2019/6/3.
//  Copyright © 2019 胜的钱. All rights reserved.
//

import UIKit
import CoreData
class PersistentContainer: NSPersistentContainer {
    
    func saveContext (backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
