//
//  User.swift
//  iOS_UI_practice1
//
//  Created by Alex on 30.11.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var isFriend : Bool = true
    var firstName : String?
    var familyName : String?
    var fullName : String = "-"
    var avatar : UIImage?

    init(firstName : String, familyName : String) {
        self.firstName = firstName
        self.familyName = familyName
        self.fullName = firstName + " " + familyName
    }
    
    init(firstName : String, familyName : String, isFriend : Bool) {
        self.firstName = firstName
        self.familyName = familyName
        self.fullName = firstName + " " + familyName
        self.isFriend = isFriend
    }
}
