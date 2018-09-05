//
//  IResourceInfo.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import Alamofire

protocol IResourceInfo {
    var path: IApiPath { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
}
