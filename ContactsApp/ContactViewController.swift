//
//  ViewController.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 29.04.24.
//

import UIKit

class ContactViewController: UIViewController {
    
    public var presenter: ContactViewPresenterProtocol?
    
    private lazy var accessButtonConfiguration: UIButton.Configuration = {
        var accessButtonConfiguration = UIButton.Configuration.tinted()
        accessButtonConfiguration.title = "Загрузить контакты"
        accessButtonConfiguration.image = UIImage(systemName: "icloud.and.arrow.down")
        accessButtonConfiguration.imagePadding = 3
        accessButtonConfiguration.buttonSize = .large
        return accessButtonConfiguration
    }()
    
    private lazy var accessСontactsButton: UIButton = {
        var accessСontactsButton = UIButton(configuration: self.accessButtonConfiguration)
        accessСontactsButton.translatesAutoresizingMaskIntoConstraints = false
        accessСontactsButton.addTarget(self, action: #selector(self.loadContacts), for: .touchUpInside)
        return accessСontactsButton
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        tableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu)))
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupNavigationBar()
        self.presenter?.checkContacts()
    }
    
    private func setupButtonUI() {
        self.view.addSubview(self.accessСontactsButton)
        
        NSLayoutConstraint.activate([
            self.accessСontactsButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.accessСontactsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func setupTableViewUI() {
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Контакты"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func loadContacts() {
        self.presenter?.requestAccess()
    }
    
    @objc func showMenu(sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: touchPoint) else { return }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Copy phone number", style: .default, handler: { _ in
            UIPasteboard.general.string = self.presenter?.contacts?[indexPath.row].phoneNumber
        }))
        alert.addAction(UIAlertAction(title: "Share contact", style: .default, handler: { _ in
            let activityController = UIActivityViewController(activityItems: [self.presenter?.contacts?[indexPath.row].phoneNumber], applicationActivities: nil)
            self.present(activityController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Delete contact", style: .destructive, handler: { _ in
            self.presenter?.contacts?.remove(at: indexPath.row)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
}

extension ContactViewController: ContactViewProtocol {

    func success() {
        self.accessСontactsButton.removeFromSuperview()
        self.setupTableViewUI()
        self.tableView.reloadData()
    }
    
    func failure(alertType: AlertType?) {
        switch alertType {
        case .restricted:
            let alert = UIAlertController(title: nil, message: alertType?.rawValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        case .denied:
            let alert = UIAlertController(title: nil, message: alertType?.rawValue, preferredStyle: .alert)
            if let settings = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(settings) {
                alert.addAction(UIAlertAction(title: "Open Settings", style: .destructive, handler: { _ in
                    UIApplication.shared.open(settings)
                })
                )
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        case .none:
            self.setupButtonUI()
        }
        
    }
}

extension ContactViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = self.presenter?.contacts?[indexPath.row]
        let detailViewController = ModelBuilder.createDetailModule(contact: contact)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ContactViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter?.contacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }
        // не по MVP заменить
        cell.fullNameLabel.text = self.presenter?.contacts?[indexPath.row].firstName
        cell.phoneNumberLabel.text = self.presenter?.contacts?[indexPath.row].phoneNumber
        
        if let photo = self.presenter?.contacts?[indexPath.row].photo {
            cell.avatar.image = UIImage(data: photo)
        } else {
            cell.avatar.image = UIImage(systemName: "person")
        }

        return cell
    }
}

extension ContactViewController: ContactViewControllerProtocol {

    func addContactToFavorite(cell: UITableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        self.presenter?.addToFavorite(indexPath: indexPath)
    }
}
