//
//  NSObject+className.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 03/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
