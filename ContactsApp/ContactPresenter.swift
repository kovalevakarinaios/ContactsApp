//
//  ContactPresenter.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 29.04.24.
//

import Contacts

protocol ContactViewProtocol: AnyObject {
    func success()
    func failure()
    func showAlert(title: String, message: String)
}

protocol ContactViewPresenterProtocol: AnyObject {
    init(view: ContactViewProtocol, contactService: ContactsServiceProtocol)
    var contacts: [Contact]? { get set }
    func requestAccess()
}

class ContactPresenter: ContactViewPresenterProtocol {
    
    private let view: ContactViewProtocol
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
                            self.contacts = contacts
                            self.view.success()
                        case .failure(let error):
                            self.view.failure()
                        }
                    }
                }
            }
        case .restricted:
            self.view.showAlert(title: "Restrict", message: "Please")
        case .denied:
            self.view.showAlert(title: "Denied", message: "Please")
        case .authorized:
            self.contactService.getContacts { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let contacts):
                        self.contacts = contacts
                        self.view.success()
                    case .failure(let error):
                        self.view.failure()
                    }
                }
            }
        @unknown default:
            break
        }
    }
}
