//
//  GetBooksRequest.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import Foundation

final class GetBooksRequest: BaseApiRequest {

    typealias ResponseType = BaseResponseModel

    var query: String?
    var startIndex: Int = 0

    var method: HTTPMethod {
        return .GET
    }

    var path: String {
        return "volumes"
    }

    var parameters = [String: Any]()

    init(query: String, startedIndex: Int = 0) {
        parameters["q"] = query
        parameters["maxResults"] = "40"
        parameters["startIndex"] = String(startedIndex)
    }
}
