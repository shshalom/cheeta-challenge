//
//  CartItemViewModel.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public protocol CartItemViewModelInputs {
    func loadContent()
}

public protocol CartItemViewModelOutputs {
    var name: String { get }
    var description: String { get }
    var price: Double { get }
    var quantity: Int { get }
    var subTotal: Double { get }
    var packgingType: PackagingType { get }
    var photoURL: String { get }
    var substitutable: Bool { get }
    
    var onDataReload: Observable<Void> { get }
}

public protocol CartItemViewModeling {
    var inputs: CartItemViewModelInputs { get }
    var outputs: CartItemViewModelOutputs { get }
}

public class CartItemViewModel: CartItemViewModeling {
    public var inputs: CartItemViewModelInputs { return self }
    public var outputs: CartItemViewModelOutputs { return self }
    
    public var name = ""
    public var description = ""
    public var packgingType = PackagingType.unit
    public var price: Double = 0
    public var quantity = 0
    public var subTotal: Double = 0
    public var photoURL: String = ""
    public var substitutable = false
    
    private var _onDataReload = PublishRelay<Void>()
    public lazy var onDataReload = self._onDataReload.asObservable()
    
    var orderItem: OrderItemsInformation
    
    init(with orderItem: OrderItemsInformation) {
        self.orderItem = orderItem
    }
    
    public func loadContent() {
        
        self.name = orderItem.product.name.components(separatedBy: " ").prefix(2).joined(separator: " ")
        self.description = orderItem.product.name
        self.packgingType = orderItem.packagingType
        self.quantity = orderItem.quantity
        self.substitutable = orderItem.substitutable
        
        switch packgingType {
        case .`case`:
            price = orderItem.product.casePrice * 0.01
            photoURL = orderItem.product.packPhotoHqURL
        case .unit:
            price = orderItem.product.unitPrice * 0.01
            photoURL = orderItem.product.unitPhotoHqURL
        case .weight:
            price = orderItem.product.weightPrice * 0.01
            photoURL = orderItem.product.weightPhotoHqURL
        }
        
        self.subTotal = price * Double(quantity)
        
        _onDataReload.accept(())
    }
}

extension CartItemViewModel: CartItemViewModelInputs, CartItemViewModelOutputs { }
