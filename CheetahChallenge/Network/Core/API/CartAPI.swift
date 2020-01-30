//
//  CartAPI.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import Foundation

public struct CartAPI {
    func getList(completion: @escaping (Result<Cart, Error>) -> Void) -> Cancellable? {
        let endpoint = CartRouter.getCart.endpoint
        return API.provider.request(endpoint, completion: completion)
    }
}
