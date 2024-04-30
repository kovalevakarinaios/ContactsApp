//
//  ModuleContactBuilder.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 29.04.24.
//

import UIKit

protocol Builder {
    static func createContactModule() -> UIViewController
}

class ModelBuilder: Builder {

    static func createContactModule() -> UIViewController {
        let contactService = ContactsService()
        let view = ContactViewController()
        let presenter = ContactPresenter(view: view, contactService: contactService)
        view.presenter = presenter
        return view
    }
}
