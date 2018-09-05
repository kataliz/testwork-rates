//
//  NetworkService.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 30/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

class NetworkService: INetworkService {
    
    // MARK: Dependencies
    
    private let sessionManager: SessionManager
    
    // MARK: Memory managment
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    // MARK: INetworkProvider implementation
    
    func request<T: Unboxable>(info: IResourceInfo, completion: @escaping ApiResponse<T>) {
        let request = constructRequest(info: info)
        
        request.validate().processResponse(completion)
    }
    
    private func constructRequest(info: IResourceInfo) -> DataRequest {
        let encoding: ParameterEncoding = (info.method == .get) ? URLEncoding.default : JSONEncoding.default
        
        return sessionManager.request(info.path.url, method: info.method,
                                      parameters: info.parameters, encoding: encoding,
                                      headers: info.headers)
    }
}
