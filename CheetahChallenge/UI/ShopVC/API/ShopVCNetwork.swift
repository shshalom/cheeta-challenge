//
//  ShopVCNetwork.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Protocol

struct TestEnv: Environment {
    var type: EnvironmentType = .staging
    var scheme: String = "https://"
    var domain = "www.mocky.io"
    var version = "v2"
}

protocol ShopVCNetworking {
    func getCart() -> Observable<Cart>
}

class ShopVCNetwork: ShopVCNetworking {
    
    init() {
        let network = Network(environment: TestEnv())
        API.setup(networking: network)
    }
    
    func getCart() -> Observable<Cart> {
        Observable.create { observer -> Disposable in
            let requets = API.cart.getList { result in
                switch result {
                case let .failure(error):
                    observer.onError(error)
                case let .success(cart):
                    observer.onNext(cart)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create {
                requets?.cancel()
            }
        }
    }
}
