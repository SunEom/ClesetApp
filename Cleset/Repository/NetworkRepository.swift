//
//  NetworkRepository.swift
//  Cleset
//
//  Created by 엄태양 on 4/23/24.
//

import UIKit
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
    
    func postData(withPath path: String, body: [String: Any] = [:], imageData: Data?, bodyName: String) -> AnyPublisher<Data, NetworkError> {
        return Future<Data, NetworkError> { [weak self] promise in
            guard let self = self else { return }
            
            let boundary = "Boundary-\(UUID().uuidString)"
            guard let url = createURL(withPath: path) else {
                promise(.failure(NetworkError.urlError))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var bodyData = Data()
            
            if let imageData = imageData {
                // Add image data
                bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
                bodyData.append("Content-Disposition: form-data; name=\"img\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
                bodyData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                bodyData.append(UIImage(data: imageData)!.jpegData(compressionQuality: 0.8)!)
                bodyData.append("\r\n".data(using: .utf8)!)
            }
            
            
            // Add JSON data
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"\(bodyName)\"\r\n".data(using: .utf8)!)
            bodyData.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
            
            guard let idToken = UserManager.getIdToken() else {
                promise(.failure(NetworkError.tokenError))
                return
            }
            
            var tokenBody = body
            tokenBody["idToken"] = idToken
            
            let jsonData = try! JSONSerialization.data(withJSONObject: tokenBody)
            bodyData.append(jsonData)
            bodyData.append("\r\n".data(using: .utf8)!)
            
            bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = bodyData
            
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
