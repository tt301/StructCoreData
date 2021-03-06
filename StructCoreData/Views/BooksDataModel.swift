//
//  BooksDataModel.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/14.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import Foundation

protocol BooksDataModelProtocol {
    var store: StoreModel { get }
    func fetchBooks(completion: @escaping ([BookModel]) -> Void)
}

struct BooksDataModel: BooksDataModelProtocol {
    
    let store: StoreModel
    
    let coreData = CoreDataService.shared
    
    func fetchBooks(completion: @escaping ([BookModel]) -> Void) {
        DispatchQueue.global().async {
            if let books = self.store.books {
                let sortedBooks = books.sorted { $0.title! < $1.title! }
                completion(sortedBooks)
            } else {
                completion([])
            }
        }
        
        /*
        let predicate = NSPredicate(format: "store.uuid == %@", store.uuid)
        let sort = NSSortDescriptor(key: "title", ascending: true)
        
        coreData.fetch(with: predicate, sortDescriptors: [sort]) { (result: Result<[BookModel]>) in
            switch result {
            case .success(let items):
                completion(items)
            case .failure(let error):
                completion([])
                NSLog(error.localizedDescription)
            }
        }
        */
    }

}
