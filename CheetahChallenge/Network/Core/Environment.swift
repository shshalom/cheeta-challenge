//
//  Environment.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import Foundation

public enum EnvironmentType: String {
    case staging = "dev"
    case production = "production"
}

public protocol Environment {
    var type: EnvironmentType { get set }
    var scheme: String { get set }
    var domain: String { get set }
    var version: String { get set }
}

extension Environment {
    
    var baseURL: String {
        return "\(scheme)\(domain)/\(version)"
    }
}
