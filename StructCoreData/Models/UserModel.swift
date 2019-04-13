//
//  UserModel.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/12.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import Foundation

struct UserModel {
    let uuid: String
    var name: String?
    var email: String?
}

extension UserModel {
    init(uuid: String) {
        self.uuid = uuid
        name = nil
        email = nil
    }
}
