//
//  StoresDataModel.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/14.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import Foundation

protocol StoresDataModelProtocol {
    func fetchStores(completion: @escaping ([StoreModel]) -> Void)
}

struct StoresDataModel: StoresDataModelProtocol {
    
    let coreData = CoreDataService.shared
    
    func fetchStores(completion: @escaping ([StoreModel]) -> Void) {
        let sort = NSSortDescriptor(key: "brand", ascending: true)
        
        coreData.fetch(sortDescriptors: [sort]) { (result: Result<[StoreModel]>) in
            switch result {
            case .success(let stores):
                completion(stores)
            case .failure(let error):
                completion([])
                NSLog(error.localizedDescription)
            }
        }
    }
    
}
