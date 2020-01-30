//
//  ShopVCView.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUI

class ShopVC: UIViewController {
    
    lazy var tableView: UITableView = {
        let v = UITableView()
        v.register(cell: CartProductCell.self)
        v.estimatedRowHeight = 50
        v.rowHeight = UITableView.automaticDimension
        v.sectionHeaderHeight = 36
        v.separatorStyle = .none
        v.contentInsetAdjustmentBehavior = .always
        v.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        return v
    }()
    
    var summeryView: SummeryView!
    
    var viewModel: ShopVCViewModeling!
    var disposeBag = DisposeBag()
    
    init(viewModel: ShopVCViewModeling = ShopVCViewModel()) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        setupViews()
    }
    
    override func loadView() {
        super.loadView()
        setupObservables()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        setupSearch()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShopVC {
    func setupViews() {
    
        summeryView = SummeryView(with: &viewModel)
        
        view.addSubview(tableView)
        view.addSubview(summeryView)
        
        summeryView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(250)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(summeryView.snp.top).offset(-8)
        }
    }
    
    func setupNavigation() {
        
        var attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: ColorPalette.blackish
        ]

        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        attrs[NSAttributedString.Key.font] = AppFonts.bold.ofSize(32)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.largeTitleTextAttributes = attrs
        self.navigationController?.navigationBar.backgroundColor = .white
        self.view.backgroundColor = UIColor.white
        title = "My Cart"
    }
    
    func setupSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
          
        search.searchBar.rx.text.orEmpty
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .takeUntil(rx.deallocated)
            .observeOn(MainScheduler.instance)
            .bind(to: viewModel.inputs.query)
            .disposed(by: disposeBag)
        
        search.rx.didDismiss
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.loadCart()
            })
            .disposed(by: disposeBag)
    }
    
    func setupObservables() {
        
        viewModel.outputs.orderItems
            .drive(tableView.rx.items(cellIdentifier: CartProductCell.identifierName,
                                      cellType: CartProductCell.self)) { index, viewModel, cell in
                cell.configure(viewModel: viewModel)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { cellInfo in
                let cell = cellInfo.cell as! CartProductCell
                cell.loadContent()
            })
            .disposed(by: disposeBag)
        
        viewModel.inputs.loadCart()
    }
}
