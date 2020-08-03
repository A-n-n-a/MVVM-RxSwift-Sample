//
//  RestApiData.swift
//  Smartlink Cameras
//
//  Created by Anna on 8/3/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import Foundation

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
