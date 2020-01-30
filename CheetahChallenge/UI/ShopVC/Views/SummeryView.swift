//
//  SummeryView.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 30/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SummeryView: VStack {
    
    private var subtotalView = SummeryItem(left: "Subtotal", right: "$0")
    private var taxFeeView = SummeryItem(left: "Tax & Fees", right: "$0")
    private var deliveryView = SummeryItem(left: "Delivery", right: "Free")
    private var promoView = SummeryItem(left: "You have no promo code", right: "")
    private var btnCheckout = "Checkout".button
        .font(AppFonts.regular.ofSize(20.0))
        .textColor(.white)
        .backgroundColor(ColorPalette.lightPink)
        .corner(radius: 30)
    
    private let separator = UIView().backgroundColor(UIColor.lightGray.withAlphaComponent(0.6))
    
    var disposeBag: DisposeBag!
    
    var viewModel: ShopVCViewModeling!
        
    override func setupViews() {
        addArrangedSubview(separator)
        addArrangedSubview(subtotalView)
        addArrangedSubview(taxFeeView)
        addArrangedSubview(deliveryView)
        addArrangedSubview(promoView)
        addArrangedSubview(UIView().hugContent(axis: .horizontal, priority: 1.priority))
        addArrangedSubview(btnCheckout)
        addArrangedSubview(UIView().hugContent(axis: .horizontal, priority: 1.priority))
        
        btnCheckout.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    init(with viewModel: inout ShopVCViewModeling) {
        super.init(frame: .zero)
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        
        setupObservables()
    }
    
    func setupObservables() {
        
        viewModel.outputs.cartTotal
        .drive(onNext: { [weak self] total in
            guard let self = self else { return }
            self.subtotalView.rightTitle.text = String(format: "$%.02f", total * 0.01)
        })
        .disposed(by: disposeBag)
        
        viewModel.outputs.deliveryFee
        .drive(onNext: { [weak self] total in
            guard let self = self else { return }
            self.deliveryView.rightTitle.text = String(format: "$%.02f", total * 0.01)
        })
        .disposed(by: disposeBag)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SummeryItem: HStack {
    
    lazy var leftTitle = "Title"
        .label
        .font(AppFonts.regular.ofSize(18.0))
        .letterSpacing(0.90)
        .textColor(UIColor.lightGray)
        .textAlignment(.left)
    
    lazy var rightTitle = "Text"
        .label
        .font(AppFonts.regular.ofSize(18.0))
        .letterSpacing(-0.26)
        .textColor(UIColor.lightGray)
        .textAlignment(.right)
    
    override func setupViews() {
        addArrangedSubview(leftTitle)
        addArrangedSubview(UIView().hugContent(axis: .horizontal, priority: 1.priority))
        addArrangedSubview(rightTitle)
    }
    
    init(left: String, right: String) {
        super.init(frame: .zero)
        leftTitle.text = left
        rightTitle.text = right
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
        setupViews()
    }
    
    func config() {}
    
    func setupViews() {}
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VStack: StackView {
    override func config() {
        distribution = .fill
        axis = .vertical
        spacing = 8
    }
}

class HStack: StackView {
    override func config() {
        distribution = .equalSpacing
        axis = .horizontal
    }
}
