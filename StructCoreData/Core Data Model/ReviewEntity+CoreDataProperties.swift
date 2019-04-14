//
//  ReviewEntity+CoreDataProperties.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/13.
//  Copyright © 2019 Tian Tong. All rights reserved.
//
//

import Foundation
import CoreData

extension ReviewEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReviewEntity> {
        return NSFetchRequest<ReviewEntity>(entityName: "ReviewEntity")
    }

    @NSManaged public var uuid: String
    @NSManaged public var bookId: String?
    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var book: BookEntity?
    @NSManaged public var user: UserEntity?

}
