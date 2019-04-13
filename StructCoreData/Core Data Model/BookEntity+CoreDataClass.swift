//
//  BookEntity+CoreDataClass.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/13.
//  Copyright © 2019 Tian Tong. All rights reserved.
//
//

import Foundation
import CoreData

@objc(BookEntity)
public class BookEntity: NSManagedObject {

}

extension BookEntity: EntityProtocol {
    
    func toModel() -> BookModel {
        var book = BookModel(uuid: uuid)
        book.title = title
        book.price = price
        book.publisher = publisher
        book.author = author?.toModel()
        book.reviews = reviews?.compactMap { $0.toModel() }
        return book
    }
    
}

extension BookModel: EntityConvertible {
    
    func toEntity(context: NSManagedObjectContext) -> BookEntity {
        let book = BookEntity.fetch(with: uuid, in: context)
        book.title = title
        book.price = price ?? 0.0
        book.publisher = publisher
        book.author = author?.toEntity(context: context)
        book.reviews = Set(reviews?.compactMap { $0.toEntity(context: context) } ?? [])
        return book
    }
    
}
