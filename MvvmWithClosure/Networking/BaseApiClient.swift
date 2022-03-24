//
//  BaseApiClient.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import Foundation

protocol BaseApiClientProtocol: AnyObject {
    func request<T: BaseApiRequest>(bodyRequest: T, _
                                    completion: @escaping (Result<T.ResponseType, AppError>) -> Void)
}

final class BaseApiClient: BaseApiClientProtocol {

    func request<T: BaseApiRequest>(bodyRequest: T, _
                                completion: @escaping (Result<T.ResponseType, AppError>) -> Void) {

        let finalRequest = request(bodyRequest)
        URLSession.shared.dataTask(with: finalRequest) { (data, response, error) in

            if let _ = error {
                completion(.failure(.clientErrors))
                return
            }

            guard let response = response as? HTTPURLResponse,
                    200...299 ~= response.statusCode else {
                completion(.failure(.serverError))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            let decoder = JSONDecoder()
            if let decodedResponse = try? decoder.decode(T.ResponseType.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } else {
                completion(.failure(.notFound))
            }
        }.resume()
    }
}

// MARK: - Prepare to request
private extension BaseApiClient {

    func request<T: BaseApiRequest>(_ request: T) -> URLRequest {

        let baseUrl = URL(string: "https://www.googleapis.com/books/v1/")!

        guard var components = URLComponents(url: baseUrl.appendingPathComponent(request.path),
                                             resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        components.queryItems = request.parameters.map {
            guard let stringValue: String = $1 as? String else {
                return URLQueryItem(name: "", value: "")
            }
            return URLQueryItem(name: String($0), value: stringValue)
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var requestWithUrl = URLRequest(url: url)
        requestWithUrl.httpMethod = request.method.rawValue
        requestWithUrl.timeoutInterval = 20

        return requestWithUrl
    }
}
