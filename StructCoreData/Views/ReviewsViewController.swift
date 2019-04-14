//
//  ReviewsViewController.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/14.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController {
    
    // MARK: - Property
    
    let dataModel: ReviewsDataModelProtocol
    
    var reviews: [ReviewModel] = []
    
    init(dataModel: ReviewsDataModelProtocol) {
        self.dataModel = dataModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }
    
    // MARK: - View
    
    let bookView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let bookTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let bookAuthor: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let bookPublisher: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    let bookPrice: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var reviewTable: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.registerCell(ReviewTableViewCell.self)
        return tableView
    }()
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(bookView)
        view.addConstraints(format: "H:|[v0]|", views: bookView)
        view.addConstraints(format: "V:[v0(140)]", views: bookView)
        bookView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        bookView.addSubview(bookTitle)
        bookView.addSubview(bookAuthor)
        bookView.addSubview(bookPublisher)
        bookView.addSubview(bookPrice)
        bookView.addConstraints(format: "H:|-15-[v0]-15-|", views: bookTitle)
        bookView.addConstraints(format: "H:|-15-[v0]-15-|", views: bookAuthor)
        bookView.addConstraints(format: "H:|-15-[v0]", views: bookPublisher)
        bookView.addConstraints(format: "H:[v0]-15-|", views: bookPrice)
        bookView.addConstraints(format: "V:|[v0(60)][v1(40)]-10-[v2(20)]-10-|", views: bookTitle, bookAuthor, bookPublisher)
        bookPrice.centerYAnchor.constraint(equalTo: bookPublisher.centerYAnchor).isActive = true
        
        view.addSubview(reviewTable)
        view.addConstraints(format: "H:|[v0]|", views: reviewTable)
        view.addConstraints(format: "V:[v0]|", views: reviewTable)
        reviewTable.topAnchor.constraint(equalTo: bookView.bottomAnchor).isActive = true
    }
    
    // MARK: - Method
    
    func loadData() {
        bookTitle.text = dataModel.book.title
        bookAuthor.text = dataModel.book.author?.name
        bookPublisher.text = dataModel.book.publisher
        bookPrice.text = "$\(dataModel.book.price ?? 0.0)"
        
        dataModel.fetchReviews { reviews in
            DispatchQueue.main.async {
                self.reviews = reviews
                self.reviewTable.reloadData()
            }
        }
    }
    
    @objc func handleAdd() {
        let newReviewDataModel = NewReviewDataModel(book: dataModel.book)
        let newReviewViewController = NewReviewViewController(dataModel: newReviewDataModel)
        
        let noteEditingNavigation = UINavigationController(rootViewController: newReviewViewController)
        navigationController?.present(noteEditingNavigation, animated: true)
    }
    
}

extension ReviewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ReviewTableViewCell
        let review = reviews[indexPath.row]
        
        cell.content.text = review.content
        cell.name.text = review.user?.name
        cell.email.text = review.user?.email
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.fromHEX("#EAEAEA")
        } else {
            cell.backgroundColor = UIColor.fromHEX("#FAFAFA")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let review = reviews.remove(at: indexPath.row)
            self.reviewTable.deleteRows(at: [indexPath], with: .fade)
            
            dataModel.deleteReview(review) { success in
                DispatchQueue.main.async {
                    self.reviewTable.reloadData()
                }
            }
        }
    }
    
}

class ReviewTableViewCell: UITableViewCell {
    
    // MARK: - Property
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    
    let content: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let email: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    func setupViews() {
        addSubview(content)
        addConstraints(format: "H:|-15-[v0]-15-|", views: content)
        addConstraints(format: "V:|-10-[v0]", views: content)
        
        addSubview(name)
        addConstraints(format: "H:|-15-[v0]", views: name)
        addConstraints(format: "V:[v0]-5-|", views: name)
        name.topAnchor.constraint(equalTo: content.bottomAnchor, constant: 10).isActive = true
        
        addSubview(email)
        addConstraints(format: "H:[v0]-15-|", views: email)
        email.centerYAnchor.constraint(equalTo: name.centerYAnchor).isActive = true
    }
    
}
