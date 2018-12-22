//
//  Configuration.swift
//  PaxelMiniTest
//
//  Created by Febbry Ramadhan on 12/22/18.
//  Copyright © 2018 Febbry Ramadhan. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Configuration : NSObject, Codable{
    var base_url = ""
    var secure_base_url = ""
    var backdrop_sizes = [String]()
    var logo_sizes = [String]()
    var poster_sizes = [String]()
    var profile_sizes = [String]()
    var still_sizes = [String]()
    
    
    init(json: JSON) {
        base_url = json["base_url"].stringValue
        secure_base_url = json["secure_base_url"].stringValue
        var backdrop_sizes_tmp = [String]()
        json["backdrop_sizes"].arrayValue.forEach({
            backdrop_sizes_tmp.append($0.stringValue)
        })
        backdrop_sizes = backdrop_sizes_tmp
        
        var logo_sizes_tmp = [String]()
        json["logo_sizes"].arrayValue.forEach({
            logo_sizes_tmp.append($0.stringValue)
        })
        logo_sizes = logo_sizes_tmp
        
        var poster_sizes_tmp = [String]()
        json["poster_sizes"].arrayValue.forEach({
            poster_sizes_tmp.append($0.stringValue)
        })
        poster_sizes = poster_sizes_tmp
        
        var profile_sizes_tmp = [String]()
        json["profile_sizes"].arrayValue.forEach({
            profile_sizes_tmp.append($0.stringValue)
        })
        profile_sizes = profile_sizes_tmp
        
        
        var still_sizes_tmp = [String]()
        json["still_sizes"].arrayValue.forEach({
            still_sizes_tmp.append($0.stringValue)
        })
        still_sizes = still_sizes_tmp
        
    }
}


class ConfigRealm: Object {
    @objc dynamic var conf: Data?
}
