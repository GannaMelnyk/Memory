//
//  Scores+CoreDataProperties.swift
//  Memory
//
//  Created by Ganna Melnyk on 1/30/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//
//

import Foundation
import CoreData


extension Scores {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scores> {
        return NSFetchRequest<Scores>(entityName: "Scores")
    }

    @NSManaged public var level: Int16
    @NSManaged public var score: Int16
    @NSManaged public var name: String?
    @NSManaged public var gameDate: Date?

}
