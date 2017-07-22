//
//  ViewController.swift
//  TestPS
//
//  Created by Dima Gubatenko on 22.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import SafariServices

fileprivate let cellReuseIdentifier = "RecipeListCell"

final class RecipesList: UIViewController {
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var tableView: UITableView!

    fileprivate var models = [RecipeModel]()
    // disable because server object created in viewDidLoad in initServer func
    // swiftlint:disable:next force_cast
    fileprivate var server: Server! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        initServer()
        initTableView()
        initSearchBar()
        server.getReceipts { [weak self] result in
            guard let welf = self else { return }
            switch result {
                case .failure(let error): showText(error.localizedDescription)
                case .success(let models):
                    welf.models = models
                    welf.tableView.reloadData()
            }
        }
    }
}

extension RecipesList : UITableViewDelegate, UITableViewDataSource {

    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 20
        tableView.register(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? RecipeListCell else { return UITableViewCell() }
        cell.model = models[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let model = models[indexPath.row]
        if let url = URL(string: model.siteURLPath), UIApplication.shared.canOpenURL(url) {
            let controller = SFSafariViewController(url: url)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            showText(NSLocalizedString("Can't create or open \(model.siteURLPath)", comment: "RecipesList tableView(_:didSelectRowAt:)"))
        }
    }
}

extension RecipesList : UISearchBarDelegate {

    func initSearchBar() {
        searchBar.delegate = self
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(serverSearchText(_:)), object: searchText)
        perform(#selector(serverSearchText), with: searchText, afterDelay: 0.5)
    }

    func serverSearchText(_ text: String) {
        server.getReceipts(text: text) { [weak self] result in
            guard let welf = self else { return }
            switch result {
            case .failure(let error): showText(error.localizedDescription)
            case .success(let models):
                welf.models = models
                welf.tableView.reloadData()
            }
        }
    }
}

extension RecipesList : ServerDelegate {

    func initServer() {
        server = Server(delegate: self)
    }

    func error(_ error: Error) {
        log(error.localizedDescription)
    }
}
