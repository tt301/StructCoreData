//
//  StoreModel.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/12.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import Foundation

struct StoreModel {
    let uuid: String
    var brand: String?
    var books: [BookModel]?
}

extension StoreModel {
    init(uuid: String) {
        self.uuid = uuid
        brand = nil
        books = nil
    }
}
