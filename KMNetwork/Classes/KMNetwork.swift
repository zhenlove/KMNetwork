//
//  KMNetwork.swift
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/2.
//  Copyright © 2020 zhenlove. All rights reserved.
//

import Foundation
import Alamofire

@objc(KMNetwork)
open class KMNetwork: NSObject {
     public static var sessionManager: SessionManager = {
        let tSessionManager = SessionManager.default
        tSessionManager.adapter = KMAdapter()
        tSessionManager.retrier = KMRetrier()
        return tSessionManager
    }()
}

extension KMNetwork {

    @objc public static func request(url:String,
                                     method:String,
                                     parameters:[String: Any]?,
                                     isHttpBody:Bool,
                                     callBack:@escaping (Any?,Error?)-> Void) -> Void {
            KMNetwork
            .sessionManager
            .request(url, method: HTTPMethod(rawValue: method) ?? .get, parameters: parameters, encoding: isHttpBody ? JSONEncoding.default : URLEncoding.default)
            .validateDataStatus(statusCode: [5,-5])
            .responseJSON { (dataResponse) in
                callBack(dataResponse.result.value,dataResponse.result.error)
            }
        }
    
    @objc public static func upload(url:String,
                                    imageData: Data,
                                    callBack:@escaping (Any?,Error?)-> Void) -> Void {
            KMNetwork
            .sessionManager
            .upload(multipartFormData: { (data) in
                data.append(imageData, withName: String.generateRandomString(5) + Date.timeIntervalBetween1970AndReferenceDate.description, mimeType: "image/jpeg")
            }, to: url) { (result) in
                switch result {
                case .success(let upload,_,_):
                    upload.responseJSON { (dataResponse) in
                        callBack(dataResponse.result.value,nil)
                    }
                case .failure(let encodingError):
                    callBack(nil,encodingError)
                }
        }
    }
}
