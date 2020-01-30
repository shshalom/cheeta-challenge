//
//  Utils.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import Foundation

struct Utils {
    static let jsonDecoder: JSONDecoder = {
       let decoder = JSONDecoder()
       if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
           decoder.dateDecodingStrategy = .iso8601
       }
       return decoder
    }()
}
