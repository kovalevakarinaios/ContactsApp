//
//  DetailPresenter.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 1.05.24.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    func setContact(firstName: String?, lastName: String?, phoneNumber: String?, photo: Data?)
}

protocol DetailViewPresenterProtocol {
    init(view: DetailViewProtocol, contact: Contact, index: Int)
    func setContact()
    func checkUpdate(firstName: String?, lastName: String?, phoneNumber: String?)
}

class DetailPresenter: DetailViewPresenterProtocol {

    weak private var view: DetailViewProtocol?
    var contact: Contact
    var index: Int
    
    required init(view: DetailViewProtocol, contact: Contact, index: Int) {
        self.view = view
        self.index = index
        self.contact = contact
    }
    
    func setContact() {
        self.view?.setContact(firstName: self.contact.firstName, lastName: self.contact.lastName, phoneNumber: self.contact.phoneNumber, photo: self.contact.photo)
    }
    
    func checkUpdate(firstName: String?, lastName: String?, phoneNumber: String?) {
        if self.contact.firstName != firstName ||
            self.contact.lastName != lastName ||
            self.contact.phoneNumber != phoneNumber {
            if var contacts = Storage.readContacts() {
                contacts[self.index].firstName = firstName ?? "Не указано"
                contacts[self.index].lastName = lastName ?? "Не указано"
                contacts[self.index].phoneNumber = phoneNumber ?? "Не указано"
                Storage.saveContacts(contacts: contacts)
            }
        } else {
            print("No any updates")
        }
    }

    deinit {
        print("DetailPresenter deinit")
    }
}
