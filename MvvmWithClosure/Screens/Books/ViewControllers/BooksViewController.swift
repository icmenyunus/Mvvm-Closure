//
//  BooksViewController.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import UIKit

final class BooksViewController: UIViewController, BooksNavigator {

    // MARK: - Properties
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Kitap, film, dizi, döküman ara..."
        return searchBar
    }()

    private let viewSource = BookView()

    private let booksViewModel: BooksViewModel

    // MARK: - initialization
    init(with bookViewModel: BooksViewModel) {
        booksViewModel = bookViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func loadView() {

        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        arrangeViews()
        observeUIElements()

        booksViewModel.getBooks(with: "Marvel") { [unowned self] _ in
            DispatchQueue.main.async {
                self.viewSource.tableView.reloadData()
            }
        }
    }
}

// MARK: - Arrange Views
private extension BooksViewController {

    func setupView() {
        view = viewSource
    }

    func arrangeViews() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        searchBar.delegate = self

        viewSource.tableView.delegate = self
        viewSource.tableView.dataSource = self
    }
}

// MARK: - UI Elements
private extension BooksViewController {

    func observeUIElements() {
        booksViewModel.isLoading = { isLoading in
            DispatchQueue.main.async {
                isLoading
                ? LoadingOverlay.shared.startLoader()
                : LoadingOverlay.shared.stopLoader()
            }
        }

        booksViewModel.shouldDisplayError = { [unowned self] errorFromServer in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Uyarı",
                                              message: errorFromServer,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam",
                                              style: .default,
                                              handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Helper Methods
private extension BooksViewController {

    @objc func searchAnything(_ searchBar: UISearchBar) {
        guard let searchQuery = searchBar.text else { return }
        booksViewModel.getBooks(with: searchQuery) { [weak self] _ in
            guard let self = self else { return }
            self.viewSource.tableView.reloadData()
        }
    }
}

// MARK: - SearchBar delegate
extension BooksViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text,
              query.trimmingCharacters(in: .whitespaces) != "",
              !query.isEmpty else {
                  booksViewModel.clearData()
                  viewSource.tableView.reloadData()
                  return
              }

        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(self.searchAnything(_:)),
                                               object: searchBar)
        perform(#selector(self.searchAnything(_:)),
                with: searchBar,
                afterDelay: 0.75)
    }
}

// MARK: - Tableview Datasource
extension BooksViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksViewModel.numberOfRow()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell",
                                                       for: indexPath) as? BookCell else { return UITableViewCell() }
        let item = booksViewModel.cellForRowAt(indexPath)
        cell.populateUI(with: item)
        return cell
    }
}

// MARK: - Tableview Delegate
extension BooksViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bookId = booksViewModel.didSelectRow(indexPath).id else { return }
        navigateToBookDetail(with: bookId)
    }
}
