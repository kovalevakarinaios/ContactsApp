//
//  ModuleContactBuilder.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 29.04.24.
//

import UIKit

protocol Builder {
    static func createContactModule() -> UIViewController
    static func createDetailModule(contact: Contact?) -> UIViewController
}

class ModelBuilder: Builder {

    static func createContactModule() -> UIViewController {
        let contactService = ContactsService()
        let view = ContactViewController()
        let presenter = ContactPresenter(view: view, contactService: contactService)
        view.presenter = presenter
        return view
    }
    
    static func createDetailModule(contact: Contact?) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, contact: contact)
        view.presenter = presenter
        return view
    }
    
    static func createFavoriteModule() -> UIViewController {
        let view = FavoriteViewController()
        let presenter = FavoritePresenter(view: view)
        view.presenter = presenter
        return view
    }
}
