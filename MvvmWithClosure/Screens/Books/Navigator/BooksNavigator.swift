//
//  BooksNavigator.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 25.03.2022.
//

protocol BooksNavigator {}

extension BooksNavigator where Self: BooksViewController {

    func navigateToBookDetail(with bookId: String) {
        let viewController = BookDetailViewController(with: bookId)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
