//
//  BooksViewModel.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import Foundation

final class BooksViewModel {

    private var apiService: BaseApiClientProtocol

    init(apiService: BaseApiClientProtocol) {
        self.apiService = apiService
    }

    private var books: [BookModel] = []

    var isLoading: ((Bool) -> Void)?

    // MARK: - for error reading
    var shouldDisplayError: ((String)->())?
    
    func getBooks(with query: String,
                  completion: @escaping ([BookModel]?) -> Void) {
        isLoading?(true)
        let request = GetBooksRequest(query: query)
        apiService.request(bodyRequest: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let books):
                if let items = books.items {
                    self.books = items
                    completion(items)
                    self.isLoading?(false)
                }
            case .failure(let error):
                self.isLoading?(false)
                self.shouldDisplayError?(error.localizedDescription)
            }
        }
    }
}

// MARK: - External Workers
extension BooksViewModel {

    func clearData() {
        books.removeAll()
    }

    func numberOfRow() -> Int {
        return books.count
    }

    func cellForRowAt(_ indexPath: IndexPath) -> BookModel {
        let item = books[indexPath.row]
        return item
    }

    func didSelectRow(_ indexPath: IndexPath) -> BookModel {
        let item = books[indexPath.row]
        return item
    }
}
