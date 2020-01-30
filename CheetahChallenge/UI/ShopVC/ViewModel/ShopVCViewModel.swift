//
//  ShopVCViewModel.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - ShopVCViewModeling
protocol ShopVCViewModelingInputs {
    func loadCart()
    var query: PublishRelay<String> { get }
}
protocol ShopVCViewModelingOutputs {
    var cartTotal: Driver<Double> { get }
    var deliveryFee: Driver<Double> { get }
    var orderItems: Driver<[CartItemViewModeling]> { get }
}

protocol ShopVCViewModeling {
    var inputs: ShopVCViewModelingInputs { get }
    var outputs: ShopVCViewModelingOutputs { get }
}

class ShopVCViewModel: ShopVCViewModeling,
ShopVCViewModelingInputs, ShopVCViewModelingOutputs {
    
    var inputs: ShopVCViewModelingInputs { return self }
    var outputs: ShopVCViewModelingOutputs { return self }

    var network: ShopVCNetworking!
    var provider: ShopVCProviding!
    
    let query = PublishRelay<String>()
    
    private var _deliveryFee = BehaviorRelay<Double>(value: 0)
    lazy var deliveryFee = self._deliveryFee.asDriver()
    
    private var _cartTotal = BehaviorRelay<Double>(value: 0)
    lazy var cartTotal = self._cartTotal.asDriver()
    
    private var _cart = PublishRelay<[Cart]>()
    lazy var cart = self._cart.asDriver(onErrorJustReturn: [])
    
    private var unFilteredItems = [CartItemViewModeling]()
    private var _orderItems = PublishRelay<[CartItemViewModeling]>()
    lazy var orderItems = self._orderItems.asDriver(onErrorJustReturn: [])
    
    var disposeBag = DisposeBag()
    
    init(networking: ShopVCNetworking = ShopVCNetwork(), provider: ShopVCProviding = ShopVCProvider()) {
        self.network = networking
        self.provider = provider
        
        setupSearcher()
    }
}

extension ShopVCViewModel {
    
    func loadCart() {
        
        let cartObservable = network.getCart().share(replay: 1)
        
        cartObservable
            .flatMapLatest { cart -> Observable<[CartItemViewModeling]> in
                let items = cart.orderItemsInformation.map({ CartItemViewModel(with: $0) })
                return .just(items)
            }
            .do(onNext: { [weak self] items in
                self?.unFilteredItems = items
            })
            .bind(to: _orderItems)
            .disposed(by: disposeBag)
        
        cartObservable.map({ $0.cartTotal })
            .take(1)
            .bind(to: _cartTotal)
            .disposed(by: disposeBag)
        
        cartObservable.map({ $0.deliveryFee })
            .take(1)
            .bind(to: _deliveryFee)
            .disposed(by: disposeBag)
    }
    
    func setupSearcher() {
        //Observe search action
        query.map { [unowned self] query -> [CartItemViewModeling] in
            return query.isEmpty ? self.unFilteredItems :
            self.unFilteredItems.filter { cart -> Bool in
                return cart.outputs.name.lowercased().contains(query.lowercased()) ||
                    cart.outputs.packgingType.rawValue.lowercased().contains(query.lowercased()) ||
                    cart.outputs.description.lowercased().contains(query.lowercased()) ||
                    String(cart.outputs.price).contains(query.lowercased())
            }
        }
        .flatMapLatest({ Observable<[CartItemViewModeling]>.just($0) })
        .bind(to: _orderItems)
        .disposed(by: disposeBag)
    }
}
