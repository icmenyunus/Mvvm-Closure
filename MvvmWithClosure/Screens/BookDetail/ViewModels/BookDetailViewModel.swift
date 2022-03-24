//
//  BookDetailViewModel.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import Foundation

final class BookDetailViewModel {

    private let apiService: BaseApiClientProtocol

    init(apiService: BaseApiClientProtocol) {
        self.apiService = apiService
    }

    var isLoading: ((Bool) -> Void)?

    // MARK: - for loading
    var updateLoadingStatus: (()->())?

    // MARK: - for error reading
    var shouldDisplayError: ((String)->())?

    func getBookDetail(with bookId: String, completion: @escaping (BookModel?) -> Void) {
        isLoading?(true)
        let request = BookDetailRequest(bookId: bookId)
        apiService.request(bodyRequest: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let book):
                completion(book)
                self.isLoading?(false)
            case .failure(let error):
                self.isLoading?(false)
                self.shouldDisplayError?(error.localizedDescription)
            }
        }
    }
}
