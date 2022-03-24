//
//  ApiError.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

enum AppError: Error {
    case clientErrors
    case parsingError
    case serverError
    case noData
    case notFound

    var errorDescription: String {
        switch self {
        case .clientErrors:
            return "Client error responses"
        case .parsingError:
            return "Error parsing the request"
        case .serverError:
            return "Server got error"
        case .noData:
            return "There is no data from server"
        case .notFound:
            return "We cannot find this page, please try again"
        }
    }
}
