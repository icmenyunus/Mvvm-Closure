//
//  BooksViewController.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import UIKit

final class BooksViewController: UIViewController {

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Kitap, film, dizi, döküman ara..."
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var viewSource: BookView = {
        let viewSource = BookView()
        viewSource.tableView.delegate = self
        viewSource.tableView.dataSource = self
        viewSource.translatesAutoresizingMaskIntoConstraints = false
        return viewSource
    }()

    private let booksViewModel: BooksViewModel

    init(with bookViewModel: BooksViewModel) {
        booksViewModel = bookViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func loadView() {
        super.loadView()

        arrangeViews()
        observeUIElements()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        booksViewModel.getBooks(with: "Marvel") { [unowned self] _ in
            DispatchQueue.main.async {
                self.viewSource.tableView.reloadData()
            }
        }
    }
}

// MARK: - Arrange Views
private extension BooksViewController {

    func arrangeViews() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        view.addSubview(viewSource)

        NSLayoutConstraint.activate([
            viewSource.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 10.0),
            viewSource.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewSource.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewSource.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
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
        let viewController = BookDetailViewController(with: bookId)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
