//
//  ApiPath.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

enum ApiPath: IApiPath {
    case rates(String)
    
    var url: URL {
        guard let result = URL(string: path) else {
            fatalError("Some configurations go wrong")
        }
        
        return result
    }
    
    // MARK: Private
    
    private var path: String {
        switch self {
        case .rates(let currency):
            return String(format: "https://revolut.duckdns.org/latest?base=%@", currency)
        }
    }
}
