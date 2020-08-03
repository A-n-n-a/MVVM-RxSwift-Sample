//
//  ParametersProtocol.swift
//  Smartlink Cameras
//
//  Created by Anna on 8/3/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import Foundation

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
