//
//  NewReviewViewController.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/14.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import UIKit

class NewReviewViewController: UIViewController {
    
    // MARK: - Property
    
    let dataModel: NewReviewDataModelProtocol
    
    init(dataModel: NewReviewDataModelProtocol) {
        self.dataModel = dataModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: - View
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Review:"
        return label
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18.0)
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 3
        return textView
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(contentLabel)
        view.addConstraints(format: "H:|-18-[v0]", views: contentLabel)
        view.addConstraints(format: "V:[v0]", views: contentLabel)
        contentLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        view.addSubview(contentTextView)
        view.addConstraints(format: "H:|-18-[v0]-18-|", views: contentTextView)
        view.addConstraints(format: "V:[v0(80)]", views: contentTextView)
        contentTextView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(nameTextField)
        view.addConstraints(format: "H:|-18-[v0]-18-|", views: nameTextField)
        view.addConstraints(format: "V:[v0(44)]", views: nameTextField)
        nameTextField.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 40).isActive = true
        
        view.addSubview(emailTextField)
        view.addConstraints(format: "H:|-18-[v0]-18-|", views: emailTextField)
        view.addConstraints(format: "V:[v0(44)]", views: emailTextField)
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
    }
    
    // MARK: - Method
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleDone() {
        guard let content = contentTextView.text else { return }
        guard let name = nameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        
        if content.isEmpty || name.isEmpty || email.isEmpty {
            return
        }
        
        let user = UserModel(uuid: UUID().uuidString, name: name, email: email)
        let review = ReviewModel(uuid: UUID().uuidString, content: content, createdAt: Date(), user: user)
        
        dataModel.createReview(review) { success in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true)
                }
            }
        }
        
    }
    
}
