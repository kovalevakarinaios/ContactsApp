//
//  ModuleContactBuilder.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 29.04.24.
//

import UIKit

protocol Builder {
    static func createContactModule() -> UIViewController
    static func createDetailModule(contact: Contact, index: Int) -> UIViewController 
    static func createFavoriteModule() -> UIViewController
}

class ModelBuilder: Builder {
    
    init() {
        print("ModelBuilder init")
    }

    static func createContactModule() -> UIViewController {
        let contactService = ContactsService()
        let view = ContactViewController()
        let presenter = ContactPresenter(view: view, contactService: contactService)
        view.presenter = presenter
        return view
    }
    
    static func createDetailModule(contact: Contact, index: Int) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, contact: contact, index: index)
        view.presenter = presenter
        return view
    }
    
    static func createFavoriteModule() -> UIViewController {
        let view = FavoriteViewController()
        let presenter = FavoritePresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    deinit {
        print("ModelBuilder deinit")
    }
}
