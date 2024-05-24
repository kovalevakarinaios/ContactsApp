//
//  FavoriteViewController.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 29.04.24.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    var presenter: FavoriteViewPresenterProtocol!
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupTableViewUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.getFavoriteContacts()
    }
    
    private func setupTableViewUI() {
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    deinit {
        print("Favorite VC deinit")
    }
}

extension FavoriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.favoriteContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        self.presenter.configure(cell: cell, indexPath: indexPath)
        return cell
    }
}

extension FavoriteViewController: UITableViewDelegate {
   
}

extension FavoriteViewController: FavoriteViewProtocol {
    
    func success() {
        self.tableView.reloadData()
    }
}
