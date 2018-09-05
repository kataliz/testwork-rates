//
//  UILabel+style.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import UIKit

enum LabelStyle {
    case title
    case subtitle
}

extension UILabel {
    func apply(style: LabelStyle) {
        switch style {
        case .title:
            font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
            textColor = UIColor.darkText
        case .subtitle:
            font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            textColor = UIColor.lightGray
        }
    }
}
