//
//  SCError.swift
//  Smartlink Cameras
//
//  Created by Anna on 8/3/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import Foundation

class SCError: Error, Decodable {
    var error: String = ""
    
    init() {}
}
