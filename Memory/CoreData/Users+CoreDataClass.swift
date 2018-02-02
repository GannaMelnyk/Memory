//
//  Users+CoreDataClass.swift
//  Memory
//
//  Created by Ganna Melnyk on 2/1/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//
//

import Foundation
import CoreData


public class Users: NSManagedObject {

    convenience init() {
        self.init(entity: CoreManager.instance.entityForName(entityName: "Users"), insertInto: CoreManager.instance.managedObjectContext)
    }
}
