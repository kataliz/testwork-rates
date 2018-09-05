//
//  ResourceInfo.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import Alamofire

struct ResourceInfo: IResourceInfo {
    
    // MARK: Properties
    
    private(set) var path: IApiPath
    private(set) var parameters: Parameters?
    private(set) var method: HTTPMethod
    private(set) var headers: HTTPHeaders?
    
    // MARK: Lifecycle
    
    init(path: IApiPath, parameters: Parameters? = nil, method: HTTPMethod = .get, headers: HTTPHeaders? = nil) {
        self.path = path
        self.parameters = parameters
        self.method = method
        self.headers = headers
    }
    
    // MARK: Constructors
    
    public static func getBy(path: IApiPath) -> IResourceInfo {
        return ResourceInfo(path: path)
    }
}
