//
//  CustomExtensioon.swift
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/3.
//  Copyright © 2020 zhenlove. All rights reserved.
//

import Foundation
import CommonCrypto
import Alamofire
extension String  {
    //md5加密字符串
    func MD5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return hash.uppercased
    }

    //获取随机字符串
    static func generateRandomString(_ length:Int) -> String {
        let kRandomAlphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = String.init(repeating: "", count: length)
        for _ in 0 ..< length {
            let serialNumber = arc4random_uniform(UInt32(kRandomAlphabet.count))
            let range = Range.init(NSRange.init(location:Int(serialNumber) , length: 1), in: kRandomAlphabet)
            randomString += String(kRandomAlphabet[range!])
        }
        return randomString
    }
    
    //获取签名
    static func sign(_ appToken:String?, _ userToken:String?, _ appKey:String,_ random:String) -> String? {
        
        var string = "apptoken=\(appToken ?? "")&noncestr=\(random)"
        if let userToken = userToken {
            string += "&usertoken=\(userToken)"
        }
        string += "&appkey=\(appKey)"

        return string.MD5()
    }
    
    public func jsonToDictionary() -> Dictionary<String, AnyObject>? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
}

 public extension DataRequest {
    static func objectResponseSerializer<T: Codable>(_ type: T.Type, _ encoding: String.Encoding? = nil) -> DataResponseSerializer<T> {
         return DataResponseSerializer { (_, response, data, error) -> Result<T> in
             let result = Request.serializeResponseData(response: response, data: data, error: error)
             switch result {
             case .success(let valiData):
                 do {
                     return .success(try JSONDecoder().decode(T.self, from: valiData))
                 } catch {
                     return .failure(error)
                 }
             case .failure(let error):
                 return .failure(error)
             }
         }
     }
     
     @discardableResult
    func responseObject<T: Codable>(
         _ type: T.Type,
         queue: DispatchQueue? = nil,
         encoding: String.Encoding? = nil,
         completionHandler: @escaping (DataResponse<T>) -> Void)
         -> Self {
         return response(queue: queue, responseSerializer: DataRequest.objectResponseSerializer(type, encoding), completionHandler: completionHandler)
     }
     
     @discardableResult
    func validateDataStatus(statusCode acceptableStatusCodes: [Int]) -> Self {
         validate { (_, _, data) -> Request.ValidationResult in
             struct KMBaseClass: Codable {
                 let Msg: String?
                 let Status: Int?
             }
             if let theData = data {
                 let rootModel = try? JSONDecoder().decode(KMBaseClass.self, from: theData)
                 if let status = rootModel?.Status {
                     if acceptableStatusCodes.contains(status) {
                         return .failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: status)))
                     }
                 }
             }
             return .success
         }
     }
 }
