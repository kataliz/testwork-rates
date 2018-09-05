//
//  UITextField+style.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import UIKit

enum InputStyle {
    case numbers
}

extension UITextField {
    func apply(style: InputStyle) {
        switch style {
        case .numbers:
            font = UIFont.systemFont(ofSize: 22.0, weight: .regular)
            textColor = UIColor.darkText
            tintColor = UIColor.darkText
        }
    }
}
