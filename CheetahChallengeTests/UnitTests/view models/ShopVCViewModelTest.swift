//
//  ShopVCViewModelTest.swift
//  CheetahChallengeTests
//
//  Created by Shalom Shwaitzer on 30/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift

@testable
import CheetahChallenge
class ShopVCViewModelTest: QuickSpec {
    
    class ShopNetworkMock: ShopVCNetworking {
        
        var cartToReturn = Cart.stub()
        
        func getCart() -> Observable<Cart> {
            return .just(cartToReturn)
        }
    }
    
    override func spec() {
        describe("shop view model") {

            var network: ShopNetworkMock!
            var shopViewModel: ShopVCViewModel!
        
            var disposeBag: DisposeBag!

            beforeEach {
                network = ShopNetworkMock()
                shopViewModel = ShopVCViewModel(networking: network)
                disposeBag = DisposeBag()
            }
            
            describe("load cart") {
                var cart: Cart!
                var results: [CartItemViewModeling]!

                beforeEach {
                    cart = Cart.stub(nonEmpty: true)
                    
                    shopViewModel.outputs
                        .orderItems
                        .drive(onNext: { results = $0 })
                        .disposed(by: disposeBag)
                }
                
                context("when items is NOT empty") {
                    it("item count shouldn't be 0") {
                        network.cartToReturn = cart
                        shopViewModel.inputs.loadCart()
                        
                        expect(results.count).toEventually(beGreaterThan(0))
                    }
                }
                
            }
            
            describe("Items data integrity ") {
                var cart: Cart!
                var itemPriceSum: Double = 0
                
                beforeEach {
                    cart = Cart.stub(nonEmpty: true)
                    
                    shopViewModel.outputs
                        .orderItems
                        .do(onNext: { items in
                            for item in items {
                                item.inputs.loadContent()
                            }
                        })
                        .drive(onNext: { items in
                            for item in items {
                                itemPriceSum += item.outputs.subTotal
                            }
                        })
                        .disposed(by: disposeBag)
                }
                
                context("when item is loaded") {
                    it("presented prices should summed up to the total value") {
                        network.cartToReturn = cart
                        shopViewModel.inputs.loadCart()
                        
                        expect(round(itemPriceSum)).toEventually(equal(round(cart.cartTotal * 0.01)))
                    }
                }
            }
            
            describe("searching items") {
                var cart: Cart!
                var results: [CartItemViewModeling]!

                beforeEach {
                    cart = Cart.stub(nonEmpty: true, injectedNames: ["Name1", "Title2", "Name3"])
                    
                    shopViewModel.outputs
                        .orderItems
                        .do(onNext: { items in
                            for item in items {
                                item.inputs.loadContent()
                            }
                        })
                        .drive(onNext: { results = $0 })
                        .disposed(by: disposeBag)
                }
                
                context("when searching Name1") {
                    it("result count should be exactly 1") {
                        network.cartToReturn = cart
                        shopViewModel.inputs.loadCart()
                        shopViewModel.inputs.query.accept("Name1")
                        
                        expect(results.count).toEventually(equal(1))
                    }
                }
                
                context("when searching Name") {
                    it("result count should be exactly 2") {
                        network.cartToReturn = cart
                        shopViewModel.inputs.loadCart()
                        shopViewModel.inputs.query.accept("Name")
                        
                        expect(results.count).toEventually(equal(2))
                    }
                }
                
                context("when searching something not in list") {
                    it("result count should be 0") {
                        network.cartToReturn = cart
                        shopViewModel.inputs.loadCart()
                        shopViewModel.inputs.query.accept("Caption")
                        
                        expect(results.count).toEventually(equal(0))
                    }
                }
            }
        }
    }
}
