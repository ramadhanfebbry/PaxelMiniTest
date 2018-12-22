//
//  Movie.swift
//  PaxelMiniTest
//
//  Created by Febbry Ramadhan on 12/22/18.
//  Copyright © 2018 Febbry Ramadhan. All rights reserved.
//

import Foundation
import SwiftyJSON

class Movie: NSObject{
    var id:String = ""
    var poster_path = ""
    var popularity = ""
    var video = false
    var overview = ""
    var genre_ids = [Int]()
    var vote_average: Float = 0
    var original_language = ""
    var backdrop_path = ""
    var original_title = ""
    var title = ""
    var adult = false
    var release_date = ""
    
    init(json: JSON) {
        id = json["id"].stringValue
        poster_path = json["poster_path"].stringValue
        popularity = json["popularity"].stringValue
        video = json["video"].boolValue
        overview = json["overview"].stringValue
        var genre_ids_tmp = [Int]()
        
        json["genre_ids"].arrayValue.forEach({
            genre_ids_tmp.append($0.intValue)
        })
        genre_ids = genre_ids_tmp
        vote_average = json["vote_average"].floatValue
        original_language = json["original_language"].stringValue
        backdrop_path = json["backdrop_path"].stringValue
        original_title = json["original_title"].stringValue
        title = json["title"].stringValue
        adult = json["adult"].boolValue
        release_date = json["release_date"].stringValue        
    }
    
    var image_url: String? {
        let config = CacheDefault.loadConfig()
        
        return (config?.base_url ?? "") + (config?.poster_sizes.first ?? "") + self.poster_path
    }
}


