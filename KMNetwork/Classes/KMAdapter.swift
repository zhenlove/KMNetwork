//
//  KMAdapter.swift
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/3.
//  Copyright © 2020 zhenlove. All rights reserved.
//

import Foundation
import Alamofire
class KMAdapter: RequestAdapter {
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            var urlRequest = urlRequest
            urlRequest.setValue(KMServiceModel.default.apptoken, forHTTPHeaderField: "apptoken")
            urlRequest.setValue(KMServiceModel.default.usertoken, forHTTPHeaderField: "usertoken")
            urlRequest.setValue(KMServiceModel.default.noncestr, forHTTPHeaderField: "noncestr")
            urlRequest.setValue(KMServiceModel.default.sign, forHTTPHeaderField: "sign")
            return urlRequest
    }
}
