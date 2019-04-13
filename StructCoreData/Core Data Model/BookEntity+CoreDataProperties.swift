//
//  BookEntity+CoreDataProperties.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/13.
//  Copyright © 2019 Tian Tong. All rights reserved.
//
//

import Foundation
import CoreData

extension BookEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookEntity> {
        return NSFetchRequest<BookEntity>(entityName: "BookEntity")
    }

    @NSManaged public var uuid: String
    @NSManaged public var price: Double
    @NSManaged public var publisher: String?
    @NSManaged public var title: String?
    @NSManaged public var reviews: Set<ReviewEntity>?
    @NSManaged public var store: StoreEntity?
    @NSManaged public var author: AuthorEntity?

}

// MARK: Generated accessors for reviews
extension BookEntity {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: ReviewEntity)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: ReviewEntity)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}
