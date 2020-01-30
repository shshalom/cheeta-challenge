//
//  CartRouter.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import Foundation

enum CartRouter: Router {
    case getCart
}

extension CartRouter {
    var endpoint: Endpoint {
        switch self {
        case .getCart: return Endpoint(path: "59c791ed1100005300c39b93") //A better endpoint name could be something like `list`
        }
    }
}
