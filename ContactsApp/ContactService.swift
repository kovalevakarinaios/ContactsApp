//
//  ContactService.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 29.04.24.
//

import Contacts

protocol ContactsServiceProtocol {
    func createPhoneNumbersList(phoneNumbers: [CNLabeledValue<CNPhoneNumber>]) -> String
    func getContacts(completion: @escaping (Result<[Contact], Error>) -> Void)
}

class ContactsService: ContactsServiceProtocol {
    
    func getContacts(completion: @escaping (Result<[Contact], Error>) -> Void) {
        var contacts = [Contact]()
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey, CNContactImageDataKey] as [CNKeyDescriptor]
        let contactsRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        do {
            try CNContactStore().enumerateContacts(with: contactsRequest) { contact, _ in
                
                contacts.append(Contact(firstName: contact.givenName,
                                        lastName: contact.familyName,
                                        phoneNumber: self.createPhoneNumbersList(phoneNumbers: contact.phoneNumbers),
                                        photo: contact.imageData,
                                        isFavorite: false))
                completion(.success(contacts))
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func createPhoneNumbersList(phoneNumbers: [CNLabeledValue<CNPhoneNumber>]) -> String {
        var numbers = String()
        phoneNumbers.forEach { number in
            numbers += number.value.stringValue
        }
        return numbers
    }
}
