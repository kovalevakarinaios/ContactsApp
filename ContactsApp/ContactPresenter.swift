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
    func failure(alertType: AlertType)
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
                            self.view.failure(alertType: .denied)
                        }
                    }
                }
            }
        case .restricted:
            self.view.failure(alertType: .restricted)
        case .denied:
            self.view.failure(alertType: .denied)
        case .authorized:
            self.contactService.getContacts { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let contacts):
                        self.contacts = contacts
                        self.view.success()
                    case .failure(let error):
                        self.view.failure(alertType: .denied)
                    }
                }
            }
        @unknown default:
            break
        }
    }
}
