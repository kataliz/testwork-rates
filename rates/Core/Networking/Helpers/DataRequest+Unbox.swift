//
//  DataRequest+Unbox.swift
//  aximetria
//
//  Created by Chimit on 05.02.2018.
//  Copyright © 2018 Aximetria GmbH. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

extension Alamofire.DataRequest {
    func processResponse<T: Unboxable>(_ completion: @escaping ApiResponse<T>) {
        self.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let unboxed: T = Alamofire.DataRequest.tryUnbox(value: value) else {
                    completion(.failure(NetworkError.invalideParsing))
                    return
                }
                completion(.success(unboxed))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func tryUnbox<T: Unboxable>(value: Any) -> T? {
        guard let json = value as? [String: Any],
            let unboxed: T = try? unbox(dictionary: json) else {
                return nil
        }
        
        return unboxed
    }
}
