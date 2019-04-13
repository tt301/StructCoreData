//
//  ReviewModel.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/12.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import Foundation

struct ReviewModel {
    let uuid: String
    var content: String?
    var createdAt: Date?
    var user: UserModel?
}

extension ReviewModel {
    init(uuid: String) {
        self.uuid = uuid
        content = nil
        createdAt = nil
        user = nil
    }
}
