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
        var firstNameTextField = createTextField(fieldName: "First Name")
        return firstNameTextField
    }()
    
    private lazy var lastNameTextField: UITextField = {
        var lastNameTextField = createTextField(fieldName: "Last Name")
        return lastNameTextField
    }()
    
    private lazy var phoneNumberTextField: UITextField = {
        var phoneNumberTextField = createTextField(fieldName: "Phone Number")
        return phoneNumberTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.presenter?.setContact()
        self.setupNavBar()
        self.setupAvatarUI()
        self.setupStackViewUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presenter?.checkUpdate(firstName: self.firstNameTextField.text, lastName: self.lastNameTextField.text, phoneNumber: self.phoneNumberTextField.text)
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
            self.stackViewForTextFields.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5)
        ])
    }
    
    private func setupNavBar() {
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func createTextField(fieldName: String) -> UITextField {
        let textField = UITextField()
        let fieldNameLabel = UILabel()
        fieldNameLabel.text = fieldName
        fieldNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        textField.leftViewMode = .always
        textField.leftView = fieldNameLabel
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = false
        return textField
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
    
    deinit {
        print("Detail VC deinit")
    }
}

extension DetailViewController: DetailViewProtocol {
    func setContact(firstName: String?, lastName: String?, phoneNumber: String?, photo: Data?) {
        self.firstNameTextField.text = firstName
        self.lastNameTextField.text = lastName
        self.phoneNumberTextField.text = phoneNumber
        
        if let photo = photo {
            self.avatar.image = UIImage(data: photo)
        } else {
            self.avatar.image = UIImage(systemName: "person")
        }
    }
}
