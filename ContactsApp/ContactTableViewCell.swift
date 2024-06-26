//
//  ContactTableViewCell.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 30.04.24.
//

import UIKit

protocol ContactViewControllerProtocol: AnyObject {
    func addContactToFavorite(cell: UITableViewCell)
}

class ContactTableViewCell: UITableViewCell {
    
    static let identifier = "ContactListTableViewCell"
    
    weak var delegate: ContactViewControllerProtocol?
    
    private lazy var avatar: UIImageView = {
        var avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.image = UIImage(systemName: "person.fill.checkmark.rtl")
        return avatar
    }()

    private lazy var stackViewForLabels: UIStackView = {
        var stackViewForLabels = UIStackView()
        stackViewForLabels.translatesAutoresizingMaskIntoConstraints = false
        stackViewForLabels.axis = .vertical
        stackViewForLabels.distribution = .fillProportionally
        stackViewForLabels.alignment = .leading
        stackViewForLabels.spacing = 2
        [self.fullNameLabel, self.phoneNumberLabel].forEach { stackViewForLabels.addArrangedSubview($0) }
        return stackViewForLabels
    }()

    private lazy var fullNameLabel: UILabel = {
        var fullNameLabel = UILabel()
        fullNameLabel.textColor = .darkGray
        return fullNameLabel
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        var phoneNumberLabel = UILabel()
        phoneNumberLabel.textColor = .darkGray
        return phoneNumberLabel
    }()
    
    private lazy var handler: UIButton.ConfigurationUpdateHandler = { button in
        switch button.state {
        case .selected:
            button.configuration?.baseForegroundColor = .systemRed
        default:
            button.configuration?.baseForegroundColor = .systemGray
        }
    }
    
    private lazy var favoriteButtonConfiguration: UIButton.Configuration = {
        var favoriteButtonConfiguration = UIButton.Configuration.borderless()
        favoriteButtonConfiguration.image = UIImage(systemName: "heart.fill")
        favoriteButtonConfiguration.imagePadding = 3
        favoriteButtonConfiguration.buttonSize = .mini
        favoriteButtonConfiguration.baseBackgroundColor = .clear
        return favoriteButtonConfiguration
    }()
    
    private lazy var favoriteСontactsButton: UIButton = {
        var favoriteСontactsButton = UIButton(configuration: self.favoriteButtonConfiguration)
        favoriteСontactsButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteСontactsButton.configurationUpdateHandler = handler
        favoriteСontactsButton.addTarget(self, action: #selector(self.addToFavorite), for: .touchUpInside)
        return favoriteСontactsButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.contentView.addSubview(self.avatar)
        self.contentView.addSubview(self.stackViewForLabels)
        self.contentView.addSubview(self.favoriteСontactsButton)

        NSLayoutConstraint.activate([
            self.avatar.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2),
            self.avatar.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2),
            self.avatar.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 2),
            self.avatar.trailingAnchor.constraint(equalTo: self.stackViewForLabels.leadingAnchor, constant: -2),
            self.avatar.widthAnchor.constraint(equalTo: self.contentView.heightAnchor),
            self.stackViewForLabels.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2),
            self.stackViewForLabels.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2),
            self.stackViewForLabels.trailingAnchor.constraint(equalTo: self.favoriteСontactsButton.leadingAnchor),
            self.favoriteСontactsButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2),
            self.favoriteСontactsButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2),
            self.favoriteСontactsButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -2)
        ])
    }
    
    public func configureCell(firstName: String, phoneNumber: String, photo: Data?, isSelected: Bool) {
        self.fullNameLabel.text = firstName
        self.phoneNumberLabel.text = phoneNumber
        
        if let photo = photo {
            self.avatar.image = UIImage(data: photo)
        } else {
            self.avatar.image = UIImage(systemName: "person")
        }
        
        isSelected ? (self.favoriteСontactsButton.isSelected = true) : (self.favoriteСontactsButton.isSelected = false)
        
    }
    
    @objc private func addToFavorite() {
        self.delegate?.addContactToFavorite(cell: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.fullNameLabel.text = nil
        self.phoneNumberLabel.text = nil
        self.avatar.image = nil
        self.favoriteСontactsButton.isSelected = false
    }
}
