//
//  Array+helpers.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 31/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
    
    var second: Element? {
        guard count > 1 else {
            return nil
        }
        
        return self[1]
    }
}

extension Array where Element: Equatable {
    mutating func rearrangeAtStart(_ item: Element) {
        guard let index = index(where: { $0 == item }) else {
            return
        }

        rearrange(from: index, to: 0)
    }
    
    func rarrangedAtStart(_ item: Element) -> Array {
        var copy = self
        copy.rearrangeAtStart(item)
        return copy
    }
}
