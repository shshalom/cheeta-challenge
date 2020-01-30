//
//  Error.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import Foundation

public enum Error: Swift.Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}
