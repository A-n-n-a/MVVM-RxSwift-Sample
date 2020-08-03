//
//  URLRequest.swift
//  Smartlink Cameras
//
//  Created by Anna on 8/3/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import UIKit

extension URLRequest {
    
    mutating func addHttpBody(parameters: [String: Any]) {
        do {
            let jsonObject = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            httpBody = jsonObject
        } catch let error {
            #if DEBUG
            print(error)
            #endif
        }
    }
}
