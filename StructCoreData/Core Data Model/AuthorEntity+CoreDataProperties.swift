//
//  AuthorEntity+CoreDataProperties.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/13.
//  Copyright © 2019 Tian Tong. All rights reserved.
//
//

import Foundation
import CoreData

extension AuthorEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthorEntity> {
        return NSFetchRequest<AuthorEntity>(entityName: "AuthorEntity")
    }

    @NSManaged public var uuid: String
    @NSManaged public var name: String?
    @NSManaged public var books: NSSet?

}

// MARK: Generated accessors for books
extension AuthorEntity {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: BookEntity)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: BookEntity)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

}
