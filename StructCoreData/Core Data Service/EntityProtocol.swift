//
//  EntityProtocol.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/12.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import Foundation
import CoreData

protocol EntityProtocol {
    associatedtype Model
    func toModel() -> Model
}

extension EntityProtocol where Self: NSManagedObject {
    
    static func fetch(with uuid: String, in context: NSManagedObjectContext) -> Self {
        let fetchRequest = Self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        fetchRequest.sortDescriptors = nil
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchLimit = 1
        
        var result: [Self]?
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest) as? [Self]
            } catch {
                result = nil
                NSLog("Core Data fetch error: \(error)")
            }
        }
        
        // Return the existing object
        if let object = result?.first {
            return object
        }
        
        // Return the new created one
        let object = Self(context: context)
        object.setValue(uuid, forKey: "uuid")
        return object
    }
    
}
