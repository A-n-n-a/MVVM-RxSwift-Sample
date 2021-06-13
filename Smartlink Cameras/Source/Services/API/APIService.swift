//
//  APIService.swift
//  Smartlink Cameras
//
//  Created by SecureNet Mobile Team on 1/10/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    
    func call<T: Decodable>(requestData: RestApiData, completion: @escaping (_ result: Result<T, Error>) -> Void)
}

final class APIService: APIServiceProtocol {
    
    private let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    
    init() {
        
    }
    
    func call<T: Decodable>(requestData: RestApiData, completion: @escaping (_ result: Result<T, Error>) -> Void) {
            guard let request = request(requestData: requestData) else {
                return
            }
            
            let dataTask = session.dataTask(with: request) { (data, urlResponse, error) in
                if let data = data {
                    do {
                        let object = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(object))
                    } catch let error {
                        var scError = SCError()
                        if let err = try? JSONDecoder().decode(SCError.self, from: data) {
                            scError = err
                        } else {
                            let errorObject = error as NSError
                            scError.error = errorObject.localizedDescription
                        }
                        completion(.failure(scError))
                    }
                }
            }
            dataTask.resume()
        }
    
    private func request(requestData: RestApiData) -> URLRequest? {
        
        let urlString = requestData.httpMethod == .get ? requestData.urlWithParametersString : requestData.url
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 30.0
        urlRequest.httpMethod = requestData.httpMethod.rawValue
        if requestData.httpMethod != .get {
            urlRequest.addHttpBody(parameters: requestData.parameters)
        }
        return urlRequest
    }
    
    deinit {
        
    }
    
}
