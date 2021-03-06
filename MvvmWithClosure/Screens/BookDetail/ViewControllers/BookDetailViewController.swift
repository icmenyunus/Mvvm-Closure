//
//  BookDetailViewController.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import UIKit

final class BookDetailViewController: UIViewController {

    // MARK: - Properties
    private let viewSource = BookDetailView()

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

        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        arrangeViews()
    }
}

// MARK: - Arrange Views
private extension BookDetailViewController {

    func setupView() {
        view = viewSource
    }

    func arrangeViews() {
        view.backgroundColor = .white

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
