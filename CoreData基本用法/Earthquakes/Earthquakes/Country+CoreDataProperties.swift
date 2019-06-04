//
//  Country+CoreDataProperties.swift
//  Earthquakes
//
//  Created by 胜的钱 on 2019/6/3.
//  Copyright © 2019 胜的钱. All rights reserved.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var name: String?
    @NSManaged public var quakes: Quake?

}
