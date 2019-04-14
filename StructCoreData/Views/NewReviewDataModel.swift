//
//  NewReviewDataModel.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/14.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import Foundation

protocol NewReviewDataModelProtocol {
    var book: BookModel { get }
    func createReview(_ review: ReviewModel, completion: @escaping (Bool) -> Void)
}

struct NewReviewDataModel: NewReviewDataModelProtocol {
    
    let book: BookModel
    
    let coreData = CoreDataService.shared
    
    func createReview(_ review: ReviewModel, completion: @escaping (Bool) -> Void) {
//        review.book = book
        coreData.update(entities: [review]) { error in
            
        }
    }
    
}

