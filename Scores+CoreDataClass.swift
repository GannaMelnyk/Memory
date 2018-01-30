//
//  Scores+CoreDataClass.swift
//  Memory
//
//  Created by Ganna Melnyk on 1/30/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//
//

import Foundation
import CoreData


public class Scores: NSManagedObject {

    convenience init() {
        self.init(entity: CoreManager.instance.entityForName(entityName: "Scores"), insertInto: CoreManager.instance.managedObjectContext)
    }
}
