//
//  StoreEntity+CoreDataClass.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/13.
//  Copyright © 2019 Tian Tong. All rights reserved.
//
//

import Foundation
import CoreData

@objc(StoreEntity)
public class StoreEntity: NSManagedObject {

}

extension StoreEntity: EntityProtocol {
    
    func toModel() -> StoreModel {
        var store = StoreModel(uuid: uuid)
        store.brand = brand
        store.books = books?.compactMap { $0.toModel() }
        return store
    }
    
}

extension StoreModel: EntityConvertible {
    
    func toEntity(context: NSManagedObjectContext) -> StoreEntity {
        let store = StoreEntity.fetch(with: uuid, in: context)
        store.brand = brand
        store.books = Set(books?.compactMap { $0.toEntity(context: context) } ?? [])
        return store
    }
    
}
