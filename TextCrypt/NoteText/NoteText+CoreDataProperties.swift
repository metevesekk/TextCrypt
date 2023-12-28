//
//  NoteText+CoreDataProperties.swift
//  
//
//  Created by Mete Vesek on 22.12.2023.
//
//

import Foundation
import CoreData


extension NoteText {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteText> {
        return NSFetchRequest<NoteText>(entityName: "NoteText")
    }

    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var time: Date?
    @NSManaged public var date: Date?

}
