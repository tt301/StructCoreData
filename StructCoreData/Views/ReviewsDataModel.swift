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
    func deleteReview(_ review: ReviewModel, completion: @escaping (Bool) -> Void)
}

struct ReviewsDataModel: ReviewsDataModelProtocol {
    
    let book: BookModel
    
    let coreData = CoreDataService.shared
    
    func fetchReviews(completion: @escaping ([ReviewModel]) -> Void) {
        let predicate = NSPredicate(format: "bookId == %@", book.uuid)
        let sort = NSSortDescriptor(key: "createdAt", ascending: true)
        
        coreData.fetch(with: predicate, sortDescriptors: [sort]) { (result: Result<[ReviewModel]>) in
            switch result {
            case .success(let items):
                completion(items)
            case .failure(let error):
                completion([])
                NSLog(error.localizedDescription)
            }
        }
    }
    
    func deleteReview(_ review: ReviewModel, completion: @escaping (Bool) -> Void) {
        coreData.delete(entities: [review]) { error in
            if error == nil {
                completion(true)
            } else {
                completion(false)
                NSLog(error!.localizedDescription)
            }
        }
    }
    
}
