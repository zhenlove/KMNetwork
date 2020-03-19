//
//  KMNetwork.swift
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/2.
//  Copyright © 2020 zhenlove. All rights reserved.
//

import Foundation
import Alamofire

 public typealias KMURLRquestSucess = (_ response:HTTPURLResponse? ,_ reuslt : Dictionary<String, Any>? )-> Void
 public typealias KMURLRquestFailure = (_ response:HTTPURLResponse? ,_ error:Error?)-> Void

@objc(KMNetwork)
open class KMNetwork: NSObject {
     static var sessionManager: SessionManager = {
        let tSessionManager = SessionManager.default
        tSessionManager.adapter = KMAdapter()
        tSessionManager.retrier = KMRetrier()
        return tSessionManager
    }()
}

@objc
extension KMNetwork {

    @objc public static func request(url:String,
                        method:String,
                        parameters:[String: Any]?,
                        isHttpBody:Bool,
                        requestSucess sucess:@escaping KMURLRquestSucess,
                        requestFailure failure:@escaping KMURLRquestFailure) -> Void {
        KMNetwork
        .sessionManager
        .request(url, method: HTTPMethod(rawValue: method) ?? .get, parameters: parameters, encoding: isHttpBody ? JSONEncoding.default : URLEncoding.default)
        .validateDataStatus(statusCode: [5,-5])
        .responseJSON { (dataResponse) in
                if dataResponse.result.isSuccess{
                    sucess(dataResponse.response,dataResponse.result.value as? Dictionary<String, Any>)
                }
                if dataResponse.result.isFailure{
                    failure(dataResponse.response,dataResponse.result.error)
                }
        }
    }
}

