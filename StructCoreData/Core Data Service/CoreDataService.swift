//
//  CoreDataService.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/12.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import Foundation
import CoreData

enum Result<T> {
    case success(T)
    case failure(Error)
}

protocol CoreDataServiceProtocol {
    func fetch<Model: EntityConvertible>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, completion: @escaping (Result<[Model]>) -> Void)
    func update<Model: EntityConvertible>(entities: [Model], completion: @escaping (Error?) -> Void)
    func delete<Model: EntityConvertible>(entities: [Model], completion: @escaping (Error?) -> Void)
}

extension CoreDataServiceProtocol {
    
    func fetch<Model: EntityConvertible>(with predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, completion: @escaping (Result<[Model]>) -> Void) {
        fetch(with: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, completion: completion)
    }
    
}

class CoreDataService: CoreDataServiceProtocol {
    
    static let shared = CoreDataService()
    
    private init() {}
    
    private let coreDataStack = CoreDataStack.shared
    
    func fetch<Model>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, completion: @escaping (Result<[Model]>) -> Void) where Model : EntityConvertible {
        coreDataStack.performForegroundTask { context in
            do {
                let fetchRequest = Model.Entity.fetchRequest()
                fetchRequest.predicate = predicate
                fetchRequest.sortDescriptors = sortDescriptors
                if let limit = fetchLimit {
                    fetchRequest.fetchLimit = limit
                }
                
                let result = try context.fetch(fetchRequest) as? [Model.Entity]
                let items = result?.compactMap { $0.toModel() as? Model } ?? []
                completion(.success(items))
            } catch {
                NSLog("Core Data fetch error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func update<Model>(entities: [Model], completion: @escaping (Error?) -> Void) where Model : EntityConvertible {
        coreDataStack.performBackgroundTask { context in
            _ = entities.map { $0.toEntity(context: context) }
            
            do {
                try context.save()
                completion(nil)
            } catch {
                NSLog("Core Data update error: \(error)")
                completion(error)
            }
        }
    }
    
    func delete<Model>(entities: [Model], completion: @escaping (Error?) -> Void) where Model : EntityConvertible {
        coreDataStack.performBackgroundTask { context in
            let objects = entities.map { $0.toEntity(context: context) }
            for object in objects {
                context.delete(object)
            }
            
            do {
                try context.save()
                completion(nil)
            } catch {
                NSLog("Core Data delete error: \(error)")
                completion(error)
            }
        }
    }
    
}
