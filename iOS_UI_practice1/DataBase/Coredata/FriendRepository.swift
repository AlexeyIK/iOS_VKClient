//
//  FriendRepository.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 23/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import CoreData

protocol Repository {
    associatedtype Entity
    
    func getAll() -> [Entity]
    func get(id: Int) -> Entity?
    func update(entity: Entity) -> Bool
    func create(entity: Entity) -> Bool
    func delete(entity: Entity) -> Bool
}

class FriendCoreDataRepository: Repository {
    typealias Entity = VKFriend
    
    let context: NSManagedObjectContext
    
    init(stack: CoreDataStack) {
        self.context = stack.context
    }
    
    func getAll() -> [VKFriend] {
        return query(with: nil, sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)])
    }
    
    func get(id: Int) -> VKFriend? {
        return query(with: NSPredicate(format: "id = %@", "\(id)")).first
    }
    
    func update(entity: VKFriend) -> Bool {
        guard let objectToUpdate = queryCD(with: NSPredicate(format: "id = %@", "\(entity.id)")).first else {
            return false
        }
        
        if objectToUpdate.firstName != entity.firstName {
            friendEntity.setValue(entity.firstName, forKey: "firstName")
        }
        friendEntity.setValue(entity.lastName, forKey: "lastName")
        friendEntity.setValue(entity.avatarPath, forKey: "avatarPath")
        friendEntity.setValue(entity.deactivated, forKey: "deactivated")
        friendEntity.setValue(entity.isOnline, forKey: "isOnline")
    }
    
    func create(entity: VKFriend) -> Bool {
        guard let entityDescr = NSEntityDescription.entity(forEntityName: "FriendCD", in: context) else {
            return false
        }
        
        let friendEntity = NSManagedObject(entity: entityDescr, insertInto: context)
        friendEntity.setValue(entity.id, forKey: "id")
        friendEntity.setValue(entity.firstName, forKey: "firstName")
        friendEntity.setValue(entity.lastName, forKey: "lastName")
        friendEntity.setValue(entity.avatarPath, forKey: "avatarPath")
        friendEntity.setValue(entity.deactivated, forKey: "deactivated")
        friendEntity.setValue(entity.isOnline, forKey: "isOnline")
        
        return save()
    }
    
    func delete(entity: VKFriend) -> Bool {
        guard let objectToDelete = queryCD(with: NSPredicate(format: "id = %@", "\(entity.id)")).first else {
            return false
        }
        
        context.delete(objectToDelete)
        return true
    }
    
    private func query(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]? = nil) -> [VKFriend] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendCD")
        fetchRequest.predicate = predicate
        
        do {
            let objects = try context.fetch(fetchRequest) as? [FriendCD]
            return objects?.map { $0.toCommonItem() } ?? []
        } catch {
            return []
        }
    }
    
    private func queryCD(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]? = nil) -> [FriendCD] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendCD")
        fetchRequest.predicate = predicate
        
        do {
            return try (context.fetch(fetchRequest) as? [FriendCD] ?? [])
        } catch {
            return []
        }
    }
    
    private func save() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
}
