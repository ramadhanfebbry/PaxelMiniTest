//
//  ApiHelper.swift
//  PaxelMiniTest
//
//  Created by Febbry Ramadhan on 12/21/18.
//  Copyright © 2018 Febbry Ramadhan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias ParamClosure = [String: Any]?

class ApiHelper: NSObject {
    
    static let instance = ApiHelper()
    
    //MARK: - Base Params
    var baseParams : [String: Any] = [
        "action"            : "",
        "operatingSystem"   : ""
    ]
    
    //MARK: - Base Header
    var baseHeaders: [String: String] = [
        "Authorization"     : "Bearer",
        "Content-Type"      : "application/json"
    ]
    
    
    static let sessionManager: SessionManager = {
        return Alamofire.SessionManager()
    }()
    
    
    override init() {
        super.init()
    }
    
    static func postRequest(requestName: String, param: ParamClosure, token: Bool, success: @escaping(APIResult<JSON>) -> Void, failed: @escaping (String,Int)->Void) {
         let headers = [String:String]()
//        if token {
//            headers["token"] = CacheDefault.loadToken()?["access_token"]
//        }
        
        let urlRequest = Constants.ROOT_URL+requestName
        
        print("REQUEST \(urlRequest) \(String(describing: param)) with headers \(headers)")
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        sessionManager.request(urlRequest, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print("RESPONSE POST \(urlRequest) \(String(describing: response.result.value))")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            let statusCode = response.response?.statusCode ?? 0
            
            switch response.result {
            case .failure(let error):
                failed(error.localizedDescription, statusCode)
            case .success(let value):
                let json = JSON(value)
                if statusCode == 200 {
                    success(APIResult { return json })
                } else {
                    let message = json["message"].stringValue
                    failed(message, statusCode)
                }
            }
        }
    }
    
    
    
    static func getRequest(requestName: String, param: [String:String], token: Bool, success: @escaping(APIResult<JSON>) -> Void, failed: @escaping (String,Int)->Void) {
        let headers = [String:String]()
        var params: [String:String] = param
        params["api_key"] = Constants.THE_MOVIE_DB_KEY
        
        let urlRequest = Constants.ROOT_URL+requestName
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        sessionManager.request(urlRequest, method: .get, parameters: params, encoding: URLEncoding.queryString, headers: headers).responseJSON { response in
            print("RESPONSE \(urlRequest) \(String(describing: response.result.value))")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            let statusCode = response.response?.statusCode ?? 0
            
            switch response.result {
            case .failure(let error):
                failed(error.localizedDescription, statusCode)
            case .success(let value):
                let json = JSON(value)
                if statusCode == 200 {
                    success(APIResult { return json })
                } else {                    
                    let message = json["message"].stringValue
                    failed(message, statusCode)
                    
                }
            }
        }
    }
    
}

enum APIResult<Value> {
    case Success(value: Value)
    case Failure(error: NSError)
    init(_ f: () throws -> Value) {
        do {
            let value = try f()
            self = .Success(value: value)
        } catch let error as NSError {
            self = .Failure(error: error)
        }
    }
    func unwrap() throws -> Value {
        switch self {
        case .Success(let value):
            return value
        case .Failure(let error):
            throw error
        }
    }
}

