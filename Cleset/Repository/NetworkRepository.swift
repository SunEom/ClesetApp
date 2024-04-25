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
    case encodingError
    case urlError
    case urlRequestError
    case responseError
    case decodeError
    case serverError(statusCode: Int)
    case customError(Error)
    case tokenError
}

final class NetworkRepository {
    static let shared: NetworkRepository = NetworkRepository()
    
    private let hostURL = "http://127.0.0.1:8000"
    
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private func createURL(withPath path: String) -> URL? {
        let urlString = "\(hostURL)/\(path)"
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    private func createPostRequest(withPath path: String, bodyData: Any) -> URLRequest? {
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
    
    private func fetchData(from url: URL) -> AnyPublisher<Data, NetworkError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) in data }
            .mapError { _ in NetworkError.urlError }
            .eraseToAnyPublisher()
    }
    
    private func postData(from urlRequest: URLRequest) -> AnyPublisher<Data, NetworkError> {
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map { (data, response) in data }
            .mapError { _ in NetworkError.urlError }
            .eraseToAnyPublisher()
    }
      
    
    func getUserData() -> AnyPublisher<UserObject, NetworkError> {
        return Future<UserObject, NetworkError> { [weak self] promise in
            guard let self = self else { return }
            guard let token = UserManager.getIdToken() else {
                promise(.failure(NetworkError.tokenError))
                return
            }
            guard let request = createPostRequest(withPath: "user/userinfo", bodyData: ["idToken": token]) else {
                promise(.failure(NetworkError.urlRequestError))
                return
            }
            
            postData(from: request)
                .decode(type: UserObject.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(NetworkError.customError(error)))
                    }
                }, receiveValue: { userData in
                    promise(.success(userData))
                })
                .store(in: &subscriptions)
        }
        .eraseToAnyPublisher()

    }
    
}
