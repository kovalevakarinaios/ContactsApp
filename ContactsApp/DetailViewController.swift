//
//  DetailViewController.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 1.05.24.
//

import UIKit

class DetailViewController: UIViewController {
    
    public var presenter: DetailViewPresenterProtocol?
    
    private lazy var avatar: UIImageView = {
        var avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    }()

    private lazy var stackViewForTextFields: UIStackView = {
        var stackViewForTextFields = UIStackView()
        stackViewForTextFields.translatesAutoresizingMaskIntoConstraints = false
        stackViewForTextFields.axis = .vertical
        stackViewForTextFields.spacing = 2
        [self.firstNameTextField, self.lastNameTextField, self.phoneNumberTextField].forEach { stackViewForTextFields.addArrangedSubview($0) }
        return stackViewForTextFields
    }()
    
    private lazy var firstNameTextField: UITextField = {
        var firstNameTextField = UITextField()
        let fieldName = UILabel()
        fieldName.text = "First Name"
        fieldName.font = UIFont.boldSystemFont(ofSize: 17)
        firstNameTextField.leftViewMode = .always
        firstNameTextField.leftView = fieldName
        firstNameTextField.borderStyle = .roundedRect
        firstNameTextField.isUserInteractionEnabled = false
        return firstNameTextField
    }()
    
    private lazy var lastNameTextField: UITextField = {
        var lastNameTextField = UITextField()
        let fieldName = UILabel()
        fieldName.text = "Last Name"
        fieldName.font = UIFont.boldSystemFont(ofSize: 17)
        lastNameTextField.leftViewMode = .always
        lastNameTextField.leftView = fieldName
        lastNameTextField.borderStyle = .roundedRect
        lastNameTextField.isUserInteractionEnabled = false
        return lastNameTextField
    }()
    
    private lazy var phoneNumberTextField: UITextField = {
        var phoneNumberTextField = UITextField()
        let fieldName = UILabel()
        fieldName.text = "Phone Number"
        fieldName.font = UIFont.boldSystemFont(ofSize: 17)
        phoneNumberTextField.leftViewMode = .always
        phoneNumberTextField.leftView = fieldName
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.isUserInteractionEnabled = false
        return phoneNumberTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.presenter?.setComment()
        self.setupNavBar()
        self.setupAvatarUI()
        self.setupStackViewUI()
    }
    
    private func setupAvatarUI() {
        self.view.addSubview(self.avatar)
        
        NSLayoutConstraint.activate([
            self.avatar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.avatar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.avatar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            self.avatar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            self.avatar.heightAnchor.constraint(equalTo: self.view.widthAnchor, constant: -10)
        ])
    }
    
    private func setupStackViewUI() {
        self.view.addSubview(self.stackViewForTextFields)
        
        NSLayoutConstraint.activate([
            self.stackViewForTextFields.topAnchor.constraint(equalTo: self.avatar.bottomAnchor, constant: 5),
            self.stackViewForTextFields.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            self.stackViewForTextFields.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            self.stackViewForTextFields.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor, constant: -10)
        ])
    }
    
    private func setupNavBar() {
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if isEditing {
            [self.firstNameTextField, self.lastNameTextField, self.phoneNumberTextField].forEach { $0.isUserInteractionEnabled = true }
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        } else {
            [self.firstNameTextField, self.lastNameTextField, self.phoneNumberTextField].forEach { $0.isUserInteractionEnabled = false }
            self.navigationItem.setHidesBackButton(false, animated: true)
            self.tabBarController?.tabBar.isHidden = false
        }
    }
}

extension DetailViewController: DetailViewProtocol {
    func setContact(contact: Contact?) {
        self.firstNameTextField.text = contact?.firstName
        self.lastNameTextField.text = contact?.lastName
        self.phoneNumberTextField.text = contact?.phoneNumber
        
        if let photo = contact?.photo {
            self.avatar.image = UIImage(data: photo)
        } else {
            self.avatar.image = UIImage(systemName: "person")
        }
    }
}

extension DetailViewController: UITextViewDelegate {
    
}
