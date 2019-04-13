//
//  UserEntity+CoreDataClass.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/13.
//  Copyright © 2019 Tian Tong. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UserEntity)
public class UserEntity: NSManagedObject {

}

extension UserEntity: EntityProtocol {
    
    func toModel() -> UserModel {
        return UserModel(uuid: uuid, name: name, email: email)
    }
    
}

extension UserModel: EntityConvertible {
    
    func toEntity(context: NSManagedObjectContext) -> UserEntity {
        let user = UserEntity.fetch(with: uuid, in: context)
        user.name = name
        user.email = email
        return user
    }
    
}
