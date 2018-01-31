//
//  Login+CoreDataClass.swift
//  Memory
//
//  Created by Ganna Melnyk on 1/28/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//
//

import Foundation
import CoreData


public class Login: NSManagedObject {
    
    convenience init() {
        self.init(entity: CoreManager.instance.entityForName(entityName: "Login"), insertInto: CoreManager.instance.managedObjectContext)
    }
}
