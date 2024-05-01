//
//  DetailPresenter.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 1.05.24.
//

import Foundation

protocol DetailViewProtocol {
    func setContact(contact: Contact?)
}

protocol DetailViewPresenterProtocol {
    init(view: DetailViewProtocol, contact: Contact?)
    func setComment()
}

class DetailPresenter: DetailViewPresenterProtocol {
    
    let view: DetailViewProtocol
    var contact: Contact?
    
    required init(view: DetailViewProtocol, contact: Contact?) {
        self.view = view
        self.contact = contact
    }
    
    func setComment() {
        self.view.setContact(contact: contact)
    }
}
