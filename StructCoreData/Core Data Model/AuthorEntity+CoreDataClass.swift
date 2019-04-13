//
//  AuthorEntity+CoreDataClass.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/13.
//  Copyright © 2019 Tian Tong. All rights reserved.
//
//

import Foundation
import CoreData

@objc(AuthorEntity)
public class AuthorEntity: NSManagedObject {

}

extension AuthorEntity: EntityProtocol {
    
    func toModel() -> AuthorModel {
        return AuthorModel(uuid: uuid, name: name)
    }
    
}

extension AuthorModel: EntityConvertible {
    
    func toEntity(context: NSManagedObjectContext) -> AuthorEntity {
        let author = AuthorEntity.fetch(with: uuid, in: context)
        author.name = name
        return author
    }
    
}
