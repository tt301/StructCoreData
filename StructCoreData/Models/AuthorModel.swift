//
//  AuthorModel.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/12.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import Foundation

struct AuthorModel {
    let uuid: String
    var name: String?
}

extension AuthorModel {
    init(uuid: String) {
        self.uuid = uuid
        name = nil
    }
}
