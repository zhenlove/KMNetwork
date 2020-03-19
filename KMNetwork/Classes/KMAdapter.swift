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
            let noncestr = String.generateRandomString(10)
            let sign = String.sign(KMServiceModel.default.apptoken,KMServiceModel.default.usertoken, KMServiceModel.default.appKey, noncestr)
            urlRequest.setValue(KMServiceModel.default.apptoken, forHTTPHeaderField: "apptoken")
            urlRequest.setValue(KMServiceModel.default.usertoken, forHTTPHeaderField: "usertoken")
            urlRequest.setValue(noncestr, forHTTPHeaderField: "noncestr")
            urlRequest.setValue(sign, forHTTPHeaderField: "sign")
            return urlRequest
    }
}
