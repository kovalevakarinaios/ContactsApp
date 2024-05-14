//
//  FavoritePresenter.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 10.05.24.
//

import Foundation

protocol FavoriteViewProtocol {
    func success()
}

protocol FavoriteViewPresenterProtocol {
    init(view: FavoriteViewProtocol)
    var favoriteContacts: [Contact] { get set }
    func getFavoriteContacts()
    func configure(cell: ContactTableViewCell, indexPath: IndexPath)
}

class FavoritePresenter: FavoriteViewPresenterProtocol {

    private let view: FavoriteViewProtocol
    var favoriteContacts: [Contact] = []

    required init(view: FavoriteViewProtocol) {
        self.view = view
    }
    
    func getFavoriteContacts() {
        guard let contacts = Storage.readContacts() else { return }
        self.favoriteContacts = contacts.filter { $0.isFavorite }
        self.view.success()
    }
    
    func configure(cell: ContactTableViewCell, indexPath: IndexPath) {
        let favoriteContact = self.favoriteContacts[indexPath.row]
        cell.configureCell(firstName: favoriteContact.firstName,
                           phoneNumber: favoriteContact.phoneNumber,
                           photo: favoriteContact.photo, 
                           isSelected: favoriteContact.isFavorite)
    }
}
