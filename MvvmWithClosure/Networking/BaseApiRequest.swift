//
//  BaseApiRequest.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import Foundation

protocol BaseApiRequest: AnyObject {

    associatedtype ResponseType: Codable

    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
}

extension BaseApiRequest {

    var method: HTTPMethod {
        return .GET
    }

    var parameters: [String: Any] {
        return [:]
    }
}
