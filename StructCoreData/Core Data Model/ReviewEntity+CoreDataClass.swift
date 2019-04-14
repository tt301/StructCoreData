//
//  ReviewEntity+CoreDataClass.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/13.
//  Copyright © 2019 Tian Tong. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ReviewEntity)
public class ReviewEntity: NSManagedObject {

}

extension ReviewEntity: EntityProtocol {
    
    func toModel() -> ReviewModel {
        var review = ReviewModel(uuid: uuid)
        review.bookId = bookId
        review.content = content
        review.createdAt = createdAt
        review.user = user?.toModel()
        return review
    }
    
}

extension ReviewModel: EntityConvertible {
    
    func toEntity(context: NSManagedObjectContext) -> ReviewEntity {
        let review = ReviewEntity.fetch(with: uuid, in: context)
        review.bookId = bookId
        review.content = content
        review.createdAt = createdAt
        review.user = user?.toEntity(context: context)
        return review
    }
    
}
