//
//  Contact.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 29.04.24.
//

import Foundation

struct Contact: Codable {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    let photo: Data?
    var isFavorite: Bool
}
