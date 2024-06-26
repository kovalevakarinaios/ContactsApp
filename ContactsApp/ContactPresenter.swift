//
//  ContactPresenter.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 29.04.24.
//

import Contacts

enum AlertType: String {
    case restricted = "Unfortunately, you cannot give the app access to your contacts due to parental control mode or something else"
    case denied = "Please go to settings to give the app access to your contacts"
}

protocol ContactViewProtocol: AnyObject {
    func success()
    func failure(alertType: AlertType?)
}

protocol ContactViewPresenterProtocol: AnyObject {
    init(view: ContactViewProtocol, contactService: ContactsServiceProtocol)
    var contacts: [Contact]? { get set }
    func requestAccess()
    func checkSaveContacts()
    func addToFavorite(indexPath: IndexPath)
    func configure(cell: ContactTableViewCell, indexPath: IndexPath)
    func deleteContact(indexPath: IndexPath)
}

class ContactPresenter: ContactViewPresenterProtocol {
    
    weak private var view: ContactViewProtocol?
    private let contactService: ContactsServiceProtocol
    
    var contacts: [Contact]?
    
    required init(view: ContactViewProtocol, contactService: ContactsServiceProtocol) {
        self.view = view
        self.contactService = contactService
    }
    
    public func requestAccess() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { _, _ in
                self.contactService.getContacts { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let contacts):
                            Storage.saveContacts(contacts: contacts)
                            self.contacts = Storage.readContacts()
                            self.view?.success()
                        case .failure(let error):
                            self.view?.failure(alertType: .denied)
                        }
                    }
                }
            }
        case .restricted:
            self.view?.failure(alertType: .restricted)
        case .denied:
            self.view?.failure(alertType: .denied)
        case .authorized:
            self.contactService.getContacts { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let contacts):
                        Storage.saveContacts(contacts: contacts)
                        self.contacts = Storage.readContacts()
                        self.view?.success()
                    case .failure(let error):
                        self.view?.failure(alertType: .denied)
                    }
                }
            }
        @unknown default:
            break
        }
    }
    
    func checkSaveContacts() {
        if let contacts = Storage.readContacts() {
            self.contacts = contacts
            self.view?.success()
        } else {
            self.view?.failure(alertType: nil)
        }
    }
    
    func addToFavorite(indexPath: IndexPath) {
        self.contacts?[indexPath.row].isFavorite.toggle()
        if let contacts = contacts {
            Storage.saveContacts(contacts: contacts)
        }
        self.view?.success()
    }
    
    func configure(cell: ContactTableViewCell, indexPath: IndexPath) {
        if let contact = self.contacts?[indexPath.row] {
            cell.configureCell(firstName: contact.firstName,
                               phoneNumber: contact.phoneNumber,
                               photo: contact.photo,
                               isSelected: contact.isFavorite)
        }
    }
    
    func deleteContact(indexPath: IndexPath) {
        self.contacts?.remove(at: indexPath.row)
        if let contacts = self.contacts {
            Storage.saveContacts(contacts: contacts)
            self.view?.success()
        }
        
        if let contacts = self.contacts,
           contacts.isEmpty {
            self.view?.failure(alertType: .none)
        }
    }
}
