//
//  Poster.swift
//  PaxelMiniTest
//
//  Created by Febbry Ramadhan on 12/22/18.
//  Copyright © 2018 Febbry Ramadhan. All rights reserved.
//

import Foundation
import SwiftyJSON

class Poster: NSObject{
    var poster_path = ""
    var width: Float = 0
    var height: Float = 0
    var file_path = ""
    
    init(json: JSON) {
        poster_path = json["file_path"].stringValue
        width = json["width"].floatValue
        height = json["height"].floatValue
    }
    
    var image_url: String? {
        let config = CacheDefault.loadConfig()
        
        return (config?.base_url ?? "") + (config?.poster_sizes[2] ?? "") + self.poster_path
    }
}
