//
//  CoreDataStack.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 23/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private let storeContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        storeContainer = NSPersistentContainer(name: "VKDatabase")
        storeContainer.loadPersistentStores { (_, error) in }
        context = storeContainer.viewContext
    }
}
