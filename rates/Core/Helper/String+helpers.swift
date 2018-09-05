//
//  String+helpers.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 31/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

extension String {
    var digits: String {
        return components(separatedBy:
            CharacterSet.decimalDigits.inverted).joined()
    }
    
    var integerVariant: String? {
        return Int(digits).map { String($0) }
    }
    
    var withoutSpaces: String {
        return trimmingCharacters(in: .whitespaces)
    }
}
