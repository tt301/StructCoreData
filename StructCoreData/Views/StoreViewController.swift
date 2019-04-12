//
//  StoreViewController.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/12.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Book Store"
        
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.fromHEX("#ABCDEF")
    }
    
}
