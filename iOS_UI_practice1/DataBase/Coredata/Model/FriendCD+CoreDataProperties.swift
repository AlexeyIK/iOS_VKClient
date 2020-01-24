//
//  FriendCD+CoreDataProperties.swift
//  
//
//  Created by Alexey on 23/01/2020.
//
//

import Foundation
import CoreData


extension FriendCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendCD> {
        return NSFetchRequest<FriendCD>(entityName: "FriendCD")
    }

    @NSManaged public var id: Int64
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var avatarPath: String?
    @NSManaged public var deactivated: String?
    @NSManaged public var isOnline: Int16

}

extension FriendCD {
    func toCommonItem() -> VKFriend {
        return VKFriend(id: Int(self.id), firstName: self.firstName ?? "", lastName: self.lastName ?? "", avatarPath: self.avatarPath ?? "", deactivated: self.deactivated ?? "", isOnline: Int(self.isOnline))
    }
}
