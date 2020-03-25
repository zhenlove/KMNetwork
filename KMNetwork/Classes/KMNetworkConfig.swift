//
//  KMNetworkConfig.swift
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/3.
//  Copyright © 2020 zhenlove. All rights reserved.
//

import Foundation

@objc(Environment)
public enum Environment : NSInteger{
    case Testing1 //测试环境
    case Testing2 //41测试环境
    case Testing3 //42测试环境
    case Release1 //预发布环境
    case Release2 //预发布环境2
    case Production //生产环境
}

protocol SetupEnvironment {
    @discardableResult
    static func setEnvironment(_ reason: Environment) -> String
}

class BaseUrl:SetupEnvironment {
   static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tapi.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tapi1.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tapi2.kmwlyy.com:8015/"
        case .Release1:
            return "https://prapi.kmwlyy.com/"
        case .Release2:
            return "https://prapi1.kmwlyy.com/"
        case .Production:
            return "https://api.kmwlyy.com/"
        }
    }
}

class DoctorBaseUrl:SetupEnvironment {
    static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tapi.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tdoctorapi.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tdoctorapi2.kmwlyy.com:8015/"
        case .Release1:
            return "https://prdoctorapi.kmwlyy.com/"
        case .Release2:
            return "https://prdoctorapi1.kmwlyy.com/"
        case .Production:
            return "https://doctorapi.kmwlyy.com/"
        }
    }
}

class CommonBaseUrl:SetupEnvironment {
    static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tcommonapi.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tcommonapi1.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tcommonapi2.kmwlyy.com:8015/"
        case .Release1:
            return "https://prcommonapi.kmwlyy.com/"
        case .Release2:
            return "https://prcommonapi1.kmwlyy.com/"
        case .Production:
            return "https://commonapi.kmwlyy.com/"
        }
    }
}

class UserBaseUrl:SetupEnvironment {
    static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tuserapi.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tuserapi1.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tuserapi2.kmwlyy.com:8015/"
        case .Release1:
            return "https://pruserapi.kmwlyy.com/"
        case .Release2:
            return "https://pruserapi1.kmwlyy.com/"
        case .Production:
            return "https://userapi.kmwlyy.com/"
        }
    }
}
class FileStoreUrl:SetupEnvironment {
    static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tstore.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tstore1.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tstore2.kmwlyy.com:8015/"
        case .Release1:
            return "https://prstore.kmwlyy.com/"
        case .Release2:
            return "https://prstore1.kmwlyy.com/"
        case .Production:
            return "https://store.kmwlyy.com/"
        }
    }
}
class DrugstoreBaseUrl:SetupEnvironment {
    static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tydapi.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tydapi1.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tydapi2.kmwlyy.com:8015/"
        case .Release1:
            return "https://prydapi.kmwlyy.com/"
        case .Release2:
            return "https://prydapi1.kmwlyy.com/"
        case .Production:
            return "https://ydapi.kmwlyy.com/"
        }
    }
}

class RemoteAuditUrl:SetupEnvironment {
    static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tysapi.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tysapi1.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tysapi2.kmwlyy.com:8015/"
        case .Release1:
            return "https://prysapi.kmwlyy.com/"
        case .Release2:
            return "https://prysapi2.kmwlyy.com/"
        case .Production:
            return "https://ysapi.kmwlyy.com/"
        }
    }
}





@objc(KMServiceModel)
open class KMServiceModel: NSObject {
    
    static var AppId:String!
    static var AppSecret:String!
    static var AppKey:String!
    static var OrgId:String!
    static var Environment:Environment!
    
    @objc public var apptoken : String?
    @objc public var usertoken: String?
    
    @objc public var appId:String!{ get{ KMServiceModel.AppId }}
    @objc public var appSecret:String!{ get{ KMServiceModel.AppSecret }}
    @objc public var appKey:String!{ get{ KMServiceModel.AppKey }}
    @objc public var orgId:String!{ get{ KMServiceModel.OrgId }}
    
    @objc public var baseURL:String!{ get{ BaseUrl.setEnvironment(KMServiceModel.Environment) }}
    @objc public var doctorBaseUrl:String!{ get{ DoctorBaseUrl.setEnvironment(KMServiceModel.Environment) }}
    @objc public var commonBaseUrl:String!{ get{ CommonBaseUrl.setEnvironment(KMServiceModel.Environment) }}
    @objc public var userBaseUrl:String!{ get{ UserBaseUrl.setEnvironment(KMServiceModel.Environment) }}
    @objc public var fileStoreUrl:String!{ get{ FileStoreUrl.setEnvironment(KMServiceModel.Environment) }}
    @objc public var drugstoreBaseUrl:String!{ get{ DrugstoreBaseUrl.setEnvironment(KMServiceModel.Environment) }}
    @objc public var remoteAuditUrl:String!{ get{ RemoteAuditUrl.setEnvironment(KMServiceModel.Environment) }}
    
    
    private var nonce:String!
    @objc public var noncestr:String!{
        get{
            nonce = String.generateRandomString(10)
            return nonce
        }
    }
    @objc public var sign:String!{ get{ String.sign(apptoken,usertoken, appKey, nonce)}}

    static let `default`: KMServiceModel = { return KMServiceModel() }()
    
    
    @objc public static func sharedInstance()->KMServiceModel{
        return `default`
    }

    @objc public static func setupParameter(appid:String,
                                            appsecret:String,
                                            appkey:String,
                                            orgid:String,
                                            environment:Environment) {
        AppId = appid
        AppSecret = appsecret
        AppKey = appkey
        OrgId = orgid
        Environment = environment
    }

}
