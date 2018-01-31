//
//  Login+CoreDataProperties.swift
//  Memory
//
//  Created by Ganna Melnyk on 1/28/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//
//

import Foundation
import CoreData


extension Login {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Login> {
        return NSFetchRequest<Login>(entityName: "Login")
    }

    @NSManaged public var login: String?
    @NSManaged public var password: String?

}
