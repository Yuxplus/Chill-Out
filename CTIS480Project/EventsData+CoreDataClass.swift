//
//  EventsData+CoreDataClass.swift
//  CTIS480Project
//
//  Created by Mert Ekin & Yusuf Özcan on 19.05.2024.
//
//

import Foundation
import CoreData

@objc(EventsData)
public class EventsData: NSManagedObject {
    class func createInManagedObjectContext(_ context: NSManagedObjectContext, location: String, time: Date, title: String, type: String) -> EventsData {
            let eventObject = NSEntityDescription.insertNewObject(forEntityName: "EventsData", into: context) as! EventsData
            eventObject.location = location
            eventObject.time = time
            eventObject.title = title
            eventObject.type = type
            
            return eventObject
        }
}
