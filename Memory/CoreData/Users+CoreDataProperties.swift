//
//  Users+CoreDataProperties.swift
//  Memory
//
//  Created by Ganna Melnyk on 2/1/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var user: String?
    @NSManaged public var level: Int16

}
