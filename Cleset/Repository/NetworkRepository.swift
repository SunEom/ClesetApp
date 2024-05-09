//
//  NetworkRepository.swift
//  Cleset
//
//  Created by 엄태양 on 4/23/24.
//

import Foundation
import Combine
import Firebase

enum NetworkError: Error {
    case notFBLogin
    case encodingError
    case urlError
    case urlRequestError
    case responseError
    case decodeError
    case serverError(statusCode: Int)
    case customError(Error)
    case tokenError
}

class NetworkRepository {
    
    //MARK: - General
    
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func createURL(withPath path: String) -> URL? {
        let urlString = "\(K.serverURL)/\(path)"
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    //MARK: - GET
    
    func fetchData(withPath path: String) -> AnyPublisher<Data, NetworkError> {
        if let url = self.createURL(withPath: path) {
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { (data, response) in data }
                .mapError { _ in NetworkError.urlError }
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.urlError)
                .eraseToAnyPublisher()
        }
    }
    
    //MARK: - POST
    
    func createPostRequest(withPath path: String, bodyData: Any) -> URLRequest? {
        do {
            let data = try JSONSerialization.data(
                withJSONObject: bodyData,
                options: .fragmentsAllowed
            )
            guard let url = createURL(withPath: path) else { return nil }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            return request
        } catch {
            return nil
        }
        
    }
    
    func postData(withPath path: String, body: [String: Any] = [:]) -> AnyPublisher<Data, NetworkError> {
        return Future<Data, NetworkError> { [weak self] promise in
            guard let self = self else { return }
            
            guard let idToken = UserManager.getIdToken() else {
                promise(.failure(NetworkError.tokenError))
                return
            }
            
            var tokenBody = body
            tokenBody["idToken"] = idToken
            
            guard let request = createPostRequest(withPath: path, bodyData: tokenBody) else {
                promise(.failure(NetworkError.urlRequestError))
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: request)
                .map { (data, response) in data }
                .mapError { NetworkError.customError($0) }
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                }, receiveValue: { data in
                    promise(.success(data))
                })
                .store(in: &subscriptions)
        }
        .eraseToAnyPublisher()
        
    }
    
}
