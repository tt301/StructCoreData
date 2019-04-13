//
//  BookModel.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/12.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import Foundation

struct BookModel {
    let uuid: String
    var title: String?
    var price: Double?
    var publisher: String?
    var author: AuthorModel?
    var reviews: [ReviewModel]?
}

extension BookModel {
    init(uuid: String) {
        self.uuid = uuid
        title = nil
        price = nil
        publisher = nil
        author = nil
        reviews = nil
    }
}
