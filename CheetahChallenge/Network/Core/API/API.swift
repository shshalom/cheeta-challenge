//
//  API.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import Foundation

public struct API {
    internal static var provider: Networking!
    private init() {}
}

public extension API {
    
    static func setup(networking: Networking) {
        provider = networking
    }
    
    static var cart = CartAPI()
}
