//
//  BookDetailRequest.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import Foundation

final class BookDetailRequest: BaseApiRequest {

    typealias ResponseType = BookModel

    var bookId: String

    var path: String {
        return "volumes/\(bookId)"
    }

    var method: HTTPMethod {
        return .GET
    }

    var parameters = [String: Any]()

    init(bookId: String) {
        self.bookId = bookId
    }
}
