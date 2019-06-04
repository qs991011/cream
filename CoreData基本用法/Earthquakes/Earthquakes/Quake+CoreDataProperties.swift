//
//  Quake+CoreDataProperties.swift
//  Earthquakes
//
//  Created by 胜的钱 on 2019/6/3.
//  Copyright © 2019 胜的钱. All rights reserved.
//
//

import Foundation
import CoreData


extension Quake {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quake> {
        return NSFetchRequest<Quake>(entityName: "Quake")
    }

    @NSManaged public var magnitude: Float
    @NSManaged public var place: String?
    @NSManaged public var time: NSDate?
    @NSManaged public var coutries: Country?

}
