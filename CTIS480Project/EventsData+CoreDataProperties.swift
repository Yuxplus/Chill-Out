//
//  EventsData+CoreDataProperties.swift
//  CTIS480Project
//
//  Created by Mert Ekin & Yusuf Özcan on 19.05.2024.
//
//

import Foundation
import CoreData


extension EventsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventsData> {
        return NSFetchRequest<EventsData>(entityName: "EventsData")
    }

    @NSManaged public var location: String?
    @NSManaged public var time: Date?
    @NSManaged public var title: String?
    @NSManaged public var type: String?

}

extension EventsData : Identifiable {

}
