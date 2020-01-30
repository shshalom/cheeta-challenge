//
//  Endpoint.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import Foundation

protocol EndpointConvertible {
    var endpoint: Endpoint { get }
}

public class Endpoint {
    
    private var environment: Environment!
    public var path: String
    
    /// Main initializer for `Endpoint`.
    public init(path: String) {
        self.path = path
    }
    
    //Appling environment on which the endpoint will be executed
    internal func set(environment: Environment) -> Endpoint {
        self.environment = environment
        return self
    }
}

//Constract full endpoint url from provided environment
extension Endpoint {
    public var url: URL {
        return URL(string: self.environment.baseURL)!.appendingPathComponent(self.path)
    }
}
