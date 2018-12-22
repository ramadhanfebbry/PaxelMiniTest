//
//  ApiRequest.swift
//  PaxelMiniTest
//
//  Created by Febbry Ramadhan on 12/21/18.
//  Copyright © 2018 Febbry Ramadhan. All rights reserved.
//

import UIKit
import SwiftyJSON

class ApiRequest: NSObject {
    static func nowPlaying(parameters: [String:String], success: @escaping (JSON)->Void, failed: @escaping (String?)->Void) {
        ApiHelper.getRequest(requestName: UrlConstants.NOW_PLAYING, param: parameters, token: false, success: { (result) in
            do {
                let json = try result.unwrap()
                success(json)
            } catch let error {
                failed(error.localizedDescription)
            }
        }) { (error,errorCode) in
            failed(error)
        }
    }
    
    static func configuration(parameters: [String:String], success: @escaping (JSON)->Void, failed: @escaping (String?)->Void) {
        ApiHelper.getRequest(requestName: UrlConstants.CONFIGURATION, param: parameters, token: false, success: { (result) in
            do {
                let json = try result.unwrap()
                success(json)
            } catch let error {
                failed(error.localizedDescription)
            }
        }) { (error,errorCode) in
            failed(error)
        }
    }

    static func movieImages(movieId: String, parameters: [String:String], success: @escaping (JSON)->Void, failed: @escaping (String?)->Void) {
        ApiHelper.getRequest(requestName: UrlConstants.MOVIE + "/\(movieId)/images", param: parameters, token: false, success: { (result) in
            do {
                let json = try result.unwrap()
                success(json)
            } catch let error {
                failed(error.localizedDescription)
            }
        }) { (error,errorCode) in
            failed(error)
        }
    }
    
    static func relatedMovies(movieId: String, parameters: [String:String], success: @escaping (JSON)->Void, failed: @escaping (String?)->Void) {
        ApiHelper.getRequest(requestName: UrlConstants.MOVIE + "/\(movieId)/similar", param: parameters, token: false, success: { (result) in
            do {
                let json = try result.unwrap()
                success(json)
            } catch let error {
                failed(error.localizedDescription)
            }
        }) { (error,errorCode) in
            failed(error)
        }
    }
    
    

}
