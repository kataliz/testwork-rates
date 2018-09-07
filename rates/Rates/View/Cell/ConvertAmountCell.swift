//
//  ConvertAmountCell.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ConvertAmountCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: Outlet
    
    @IBOutlet private var code: UILabel!
    @IBOutlet private var name: UILabel!
    @IBOutlet private var input: UITextField!
    
    // MARK: Properties
    
    private var viewModel: ConvertCellViewModel?
    private var dispose = DisposeBag()
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dispose = DisposeBag()
    }
    
    // MARK: Configure
    
    public func configure(viewModel: ConvertCellViewModel) {
        self.viewModel = viewModel
        code.text = viewModel.currency
        name.text = viewModel.name
        
        dispose.insert(input.rx.text <-> viewModel.text)
    }
    
    private func configure() {
        code.apply(style: .title)
        name.apply(style: .subtitle)
        input.apply(style: .numbers)
        input.delegate = self
        input.placeholder = "0"
        input.keyboardType = .decimalPad
        input.isUserInteractionEnabled = false
    }
    
    override func becomeFirstResponder() -> Bool {
        input.isUserInteractionEnabled = true
        return input.becomeFirstResponder()
    }
    
    // MARK: UITextFieldDelegate implementation
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let viewModel = viewModel {
            let text: NSString = (textField.text ?? "") as NSString
            let resultString = text.replacingCharacters(in: range, with: string)
            viewModel.text.value = viewModel.formatInputed?(resultString, viewModel.currency)
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
    }
}
