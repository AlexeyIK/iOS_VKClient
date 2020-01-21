//
//  CoreData.swift
//  iOS_UI_practice1
//
//  Created by Alex on 20/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private let storeContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        storeContainer = NSPersistentContainer(name: "VKClient")
        storeContainer.loadPersistentStores { (_, error) in
            
        }
        
        context = storeContainer
    }
}
