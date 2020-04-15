//
//  DataController.swift
//  Mooskine
//
//  Created by Kittikawin Sontinarakul on 14/4/2563 BE.
//  Copyright © 2563 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelname: String) {
        persistentContainer = NSPersistentContainer(name: modelname)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDiscription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSavingContext(interval: 3)
            completion?()
        }
    }
}

//MARK: - Auto Saving

extension DataController {
    func autoSavingContext(interval: TimeInterval = 30) {
        print("auto saving")
        guard interval > 0 else {
            print("Cannot use this negative countdown AutoSaving")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSavingContext(interval: interval)
        }
    }
}
