//
//  BooksViewController.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/14.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController {
    
    // MARK: - Property
    
    let dataModel: BooksDataModelProtocol
    
    init(dataModel: BooksDataModelProtocol) {
        self.dataModel = dataModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var books: [BookModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = dataModel.store.brand
        
        setupViews()
        loadData()
    }
    
    // MARK: - View
    
    lazy var bookTable: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.registerCell(UITableViewCell.self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(bookTable)
        view.addConstraints(format: "H:|[v0]|", views: bookTable)
        view.addConstraints(format: "V:|[v0]|", views: bookTable)
    }
    
    // MARK: - Method
    
    func loadData() {
        dataModel.fetchBooks { books in
            DispatchQueue.main.async {
                self.books = books
                self.bookTable.reloadData()
            }
        }
    }
    
}

extension BooksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let book = books[indexPath.row]
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author?.name
        cell.selectionStyle = .none
        return cell
    }
    
}

extension BooksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        let dataModel = ReviewsDataModel(book: book)
        let reviewsViewController = ReviewsViewController(dataModel: dataModel)
        navigationController?.pushViewController(reviewsViewController, animated: true)
    }
    
}
