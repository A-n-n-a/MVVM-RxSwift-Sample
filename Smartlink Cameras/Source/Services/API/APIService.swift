//
//  APIService.swift
//  Smartlink Cameras
//
//  Created by SecureNet Mobile Team on 1/10/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    
    func call<T: Decodable>(requestData: RestApiData, completion: @escaping (_ result: Result<T>) -> Void)
}

final class APIService: APIServiceProtocol {
    
    private let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    
    init() {
        
    }
    
    func call<T: Decodable>(requestData: RestApiData, completion: @escaping (_ result: Result<T>) -> Void) {
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


struct RestApiData {
    var url: String
    var httpMethod: HttpMethod
    var parameters: [String: Any]
    
    init(url: String,
         httpMethod: HttpMethod,
         parameters: ParametersProtocol? = nil) {
        self.url = url
        self.httpMethod = httpMethod
        self.parameters = parameters?.dictionaryValue ?? [:]
    }
}

extension RestApiData {
    var urlWithParametersString: String {
        var parametersString = ""
        for (offset: index, element: (key: key, value: value)) in parameters.enumerated() {
            parametersString += "\(key)=\(value)"
            if index < parameters.count - 1 {
                parametersString += "&"
            }
        }
        parametersString = parametersString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        if !parametersString.isEmpty {
            parametersString = "?" + parametersString
        }
        return url + parametersString
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}


protocol ParametersProtocol {
    typealias Parameters = [String: Any]
    
    var dictionaryValue: Parameters { get }
}

struct UsernameParameters: ParametersProtocol {
    
    var username: String
    
    var dictionaryValue: Parameters {
        let data:[String : Any] = ["method" : "getPartnerEnvironment",
                                   "environment" : "PRODUCTION",
                                   "username" : username]
        
        return data
    }
}

enum Result<T> {
    case success(T)
    case failure(SCError)
}

struct UsernameExistsResponse: Codable {
    var exists: Bool
    
    enum CodingKeys: String, CodingKey {
        case exists = "data"
    }
}

struct EnvironmentResponse: Decodable {
    let server: Server
    let platform: Platform
}

struct Server: Decodable {
    let partner: String
    let environment: String
}

struct Platform: Decodable {
    let baseURL: String
}

class SCError: Error, Decodable {
    var error: String = ""
    
    init() {}
}
