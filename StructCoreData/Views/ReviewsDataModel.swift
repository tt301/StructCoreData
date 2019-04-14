//
//  ReviewsDataModel.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/14.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import Foundation

protocol ReviewsDataModelProtocol {
    var book: BookModel { get }
    func fetchReviews(completion: @escaping ([ReviewModel]) -> Void)
}

struct ReviewsDataModel: ReviewsDataModelProtocol {
    
    let book: BookModel
    
    let coreData = CoreDataService.shared
    
    func fetchReviews(completion: @escaping ([ReviewModel]) -> Void) {
        let predicate = NSPredicate(format: "book.uuid == %@", book.uuid)
        
        coreData.fetch(with: predicate) { (result: Result<[ReviewModel]>) in
            switch result {
            case .success(let items):
                completion(items)
            case .failure(let error):
                completion([])
                NSLog(error.localizedDescription)
            }
        }
    }
    
}
