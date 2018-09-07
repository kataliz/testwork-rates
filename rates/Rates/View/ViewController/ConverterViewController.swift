//
//  ConverterViewController.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 29/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

typealias AnimatedDataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, ConvertCellViewModel>>

class ConverterViewController: UIViewController {

    // MARK: Outlet
    
    @IBOutlet private var table: UITableView!
    
    // MARK: Dependencies
    
    public var viewModel: IConverterViewModel!
    
    // MARK: Properties
    
    private let dispose = DisposeBag()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: Table
    
    private func configure() {
        table.register(cell: ConvertAmountCell.self)
        table.contentInset = UIEdgeInsetsMake(22.0, 0.0, 0.0, 0.0)
        bindTable()
    }
    
    private func bindTable() {
        let input = Input(didSelect: table.rx.modelSelected(ConvertCellViewModel.self).asObservable())
        let output = viewModel.transform(input: input)
        
        output.hold.subscribe(onNext: { _ in }).disposed(by: dispose)
        
        output.viewModels.map { [AnimatableSectionModel(model: 0, items: $0)] }
            .bind(to: table.rx.items(dataSource: dataSource))
            .disposed(by: dispose)
        
        table.rx.itemSelected.asObservable()
            .subscribe(onNext: {[unowned self] (indexPath) in
                self.table.animatedScrollToTop()
                self.table.focus(on: indexPath)})
            .disposed(by: dispose)
    }
    
    private var dataSource: AnimatedDataSource {
        return AnimatedDataSource(configureCell: {(dataSource, table, indexPath, item) -> UITableViewCell in
            let cell = table.dequeueCell(ConvertAmountCell.self, for: indexPath)
            cell.configure(viewModel: item)
            
            return cell
        })
    }
}

