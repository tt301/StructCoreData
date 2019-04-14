//
//  StoresViewController.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/12.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import UIKit

class StoresViewController: UIViewController {
    
    // MARK: - Property
    
    let dataModel: StoresDataModelProtocol
    
    init(dataModel: StoresDataModelProtocol) {
        self.dataModel = dataModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var stores: [StoreModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Stores"
        
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name("Reload"), object: nil)
    }
    
    // MARK: - View
    
    lazy var storeTable: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(UITableViewCell.self)
        return tableView
    }()
    
    func setupViews() {
        view.addSubview(storeTable)
        view.addConstraints(format: "H:|[v0]|", views: storeTable)
        view.addConstraints(format: "V:|[v0]|", views: storeTable)
    }
    
    // MARK: - Method
    
    @objc func loadData() {
        dataModel.fetchStores { stores in
            DispatchQueue.main.async {
                self.stores = stores
                self.storeTable.reloadData()
                NSLog("Core Data reload")
            }
        }
    }
    
}

extension StoresViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = stores[indexPath.row].brand
        cell.selectionStyle = .none
        return cell
    }
    
}

extension StoresViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = stores[indexPath.row]
        let dataModel = BooksDataModel(store: store)
        let booksViewController = BooksViewController(dataModel: dataModel)
        navigationController?.pushViewController(booksViewController, animated: true)
    }
    
}
