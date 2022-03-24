//
//  BookDetailViewController.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import UIKit

final class BookDetailViewController: UIViewController {

    private let viewSource: BookDetailView = {
        let view = BookDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let bookDetailViewModel = BookDetailViewModel(apiService: BaseApiClient())

    init(with bookId: String) {
        super.init(nibName: nil, bundle: nil)

        observeUIElements()
        bookDetailViewModel.getBookDetail(with: bookId) { [unowned self] book in
            guard let book = book else { return }
            navigationItem.title = book.volumeInfo?.title ?? ""
            viewSource.populateUI(with: book)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle
    override func loadView() {
        super.loadView()

        arrangeViews()
    }
}

// MARK: - Arrange Views
private extension BookDetailViewController {

    func arrangeViews() {
        view.backgroundColor = .white
        view.addSubview(viewSource)
        NSLayoutConstraint.activate([
            viewSource.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewSource.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewSource.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 10.0),
            viewSource.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // MARK: - for remove back button title
        navigationController?.navigationBar.topItem?.title = ""
    }
}

// MARK: - UI Elements(for loading)
private extension BookDetailViewController {

    func observeUIElements() {
        bookDetailViewModel.isLoading = { isLoading in
            DispatchQueue.main.async {
                isLoading
                ? LoadingOverlay.shared.startLoader()
                : LoadingOverlay.shared.stopLoader()
            }
        }

        bookDetailViewModel.shouldDisplayError = { [unowned self] errorFromServer in
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
