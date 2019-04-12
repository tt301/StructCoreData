//
//  EntityConvertible.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/12.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import Foundation
import CoreData

protocol EntityConvertible {
    associatedtype Entity: NSManagedObject, EntityProtocol
    func toEntity(context: NSManagedObjectContext) -> Entity
}
