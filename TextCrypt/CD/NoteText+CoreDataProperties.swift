//
//  NoteText+CoreDataProperties.swift
//  TextCrypt
//
//  Created by Mete Vesek on 15.12.2023.
//
//

import Foundation
import CoreData


extension NoteText {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteText> {
        return NSFetchRequest<NoteText>(entityName: "NoteText")
    }

    @NSManaged public var topic: String?
    @NSManaged public var text: String?

}

extension NoteText : Identifiable {

}
