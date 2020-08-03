//
//  Server.swift
//  Smartlink Cameras
//
//  Created by Anna on 8/3/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import Foundation

struct Server: Decodable {
    let partner: String
    let environment: String
}
