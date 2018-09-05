//
//  ApiResponse+Unboxable.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import Unbox
import Alamofire

func unboxable<T, U: Unboxable>(completion: @escaping ApiResponse<T>) -> ApiResponse<U> {
    let transformCompletion: ApiResponse<U> = {(result) in
        switch result {
        case .failure(let error): completion(.failure(error))
        case .success(let value): completion(.success(value as! T))
        }
    }
    
    return transformCompletion
}
