//
//  CartProductCell.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftyAttributes

private let kPhotoSize: CGFloat = 80
private let kTitleSize: CGFloat = 17.0
private let kQuantityTitleSize: CGFloat = 80.0
private let kPriceTitleSize: CGFloat = 16.0

class CartProductCell: UITableViewCell {
    
    lazy var photo =  ColorPalette.darkGray.image().view
        .backgroundColor(ColorPalette.lightGray)
        .corner(radius: 13)
    
    lazy var lblTitle = "Item title"
        .label
        .font(AppFonts.bold.ofSize(16.0))
        .textColor(ColorPalette.blackish)
        .textAlignment(.left)
        
    lazy var lblPrice = "0$"
        .label
        .font(AppFonts.medium.ofSize(14.0))
        .textColor(ColorPalette.lightPink)
        .textAlignment(.left)
    
    lazy var lblDescription = "description"
        .label
        .textColor(ColorPalette.darkGray)
        .textAlignment(.left)
        .numberOfLines(0)
    
    lazy var lblQuantity = "xN"
        .label
        .textColor(ColorPalette.blackish)
        .numberOfLines(0)
        .textAlignment(.center)
        
    lazy var vDevider = UIView().backgroundColor(ColorPalette.lightPink)
        
    var viewModel: CartItemViewModeling!
    
    var disposeBag: DisposeBag!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: CartItemViewModeling) {
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        
        setupObservables()
    }
    
    func loadContent() {
        viewModel.inputs.loadContent()
    }
}

extension CartProductCell {
    func setupView() {
        
        selectionStyle = .none
        
        contentView.add(subviews: photo, vDevider, lblQuantity, lblTitle, lblPrice, lblDescription)
        
        photo.snp.makeConstraints { make in
            make.size.equalTo(kPhotoSize)
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        vDevider.snp.makeConstraints { make in
            make.width.equalTo(1.5)
            make.height.greaterThanOrEqualTo(kQuantityTitleSize)
            make.top.equalTo(photo)
            make.trailing.equalToSuperview().offset(-70)
        }
        
        lblQuantity.snp.makeConstraints { make in
            make.height.equalTo(kQuantityTitleSize)
            make.centerY.equalTo(vDevider)
            make.leading.equalTo(vDevider.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
        }
        
        lblTitle.snp.makeConstraints { make in
            make.leading.equalTo(photo.snp.trailing).offset(16)
            make.trailing.equalTo(vDevider.snp.trailing).inset(8)
            make.height.equalTo(kTitleSize)
            make.top.equalTo(photo)
        }
        
        lblPrice.snp.makeConstraints { make in
            make.leading.trailing.equalTo(lblTitle)
            make.top.equalTo(lblTitle.snp.bottom)
            make.height.equalTo(kPriceTitleSize)
        }
        
        lblDescription.snp.makeConstraints { make in
            make.leading.trailing.equalTo(lblPrice)
            make.top.equalTo(lblPrice.snp.bottom).offset(4)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}

extension CartProductCell {
    func setupObservables() {
        
        viewModel.outputs.onDataReload
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.lblTitle.text = self.viewModel.outputs.name
                self.lblPrice.text = String(format: "$%.02f", self.viewModel.outputs.price) + " Per \(self.viewModel.outputs.packgingType)"
                self.photo.loadImage(urlString: self.viewModel.outputs.photoURL)
                self.lblQuantity.attributedText = "\(self.viewModel.outputs.quantity)".withFont(AppFonts.medium.ofSize(24)) + "\nItems".withFont(AppFonts.regular.ofSize(10)) +
                    "\n\(String(format: "$%.02f", self.viewModel.outputs.subTotal))".withFont(AppFonts.regular.ofSize(10))
                
                let substitutableText = self.viewModel.outputs.substitutable ? "\n Replaceable".withFont(AppFonts.medium.ofSize(12)).withTextColor(ColorPalette.darkGreen) : "".attributedString
                
                self.lblDescription.attributedText = self.viewModel.outputs.description.withFont(AppFonts.regular.ofSize(10.0)).withTextColor(.lightGray) + substitutableText
            })
            .disposed(by: disposeBag)
    }
}
