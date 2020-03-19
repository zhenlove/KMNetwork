//
//  KMRetrier.swift
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/3.
//  Copyright © 2020 zhenlove. All rights reserved.
//

import Foundation
import Alamofire

struct RootClass<T:Codable> :Codable{
    let Data : T?
    let Msg : String?
    let Status : Int?
}

struct TokenModel:Codable {
    let Token:String?
}

typealias completion = (_ succeeded : Bool) -> Void

protocol InternalRequest {
    func refreshTokens(callBack:@escaping completion)
}

extension InternalRequest {
    func refreshTokens(callBack:@escaping completion) {
        
        let serviceString = KMServiceModel.default.baseURL + "/Token/get"
        let paramsDict:Parameters = ["appId":KMServiceModel.default.appId!,"appSecret":KMServiceModel.default.appSecret!]
        
        Alamofire
        .request(serviceString, method: .get, parameters: paramsDict)
        .responseObject { (dataResponse : DataResponse<RootClass<TokenModel>>) in
            if let data = dataResponse.result.value?.Data {
                KMServiceModel.default.apptoken = data.Token;
                callBack(true)
            }else{
                callBack(false)
            }
        }
    }
}

class KMRetrier: RequestRetrier,InternalRequest {
    private var isRefreshing = false
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let error = error as? AFError {
            if error.responseCode == 5 || error.responseCode == -5 {
                if !isRefreshing {
                    isRefreshing = true
                    refreshTokens{ [weak self] (succeeded) in
                        self?.isRefreshing = false
                        completion(succeeded,0.0)
                    }
                }
            }
        }else{
            completion(false, 0.0)
        }
    }
}
