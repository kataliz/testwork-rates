//
//  INetworkService.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import Unbox
import Alamofire

typealias ApiResponse<T> = (Result<T>) -> Void

protocol INetworkService {
    func request<T: Unboxable>(info: IResourceInfo, completion: @escaping ApiResponse<T>)
}
