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
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name("Reload"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("View will appear")
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.fromHEX("#ABCDEF")
    }
    
    // MARK: - Method
    
    @objc func loadData() {
        NSLog("Core Data reload")
    }
    
}
