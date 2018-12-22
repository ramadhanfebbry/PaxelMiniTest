//
//  CacheDefault.swift
//  PaxelMiniTest
//
//  Created by Febbry Ramadhan on 12/22/18.
//  Copyright © 2018 Febbry Ramadhan. All rights reserved.
//

import Foundation
import RealmSwift

class CacheDefault {
    
    
    static func setConfig(config: Configuration) {
        let encoderData = try? JSONEncoder().encode(config)
        let config_realm = ConfigRealm()
        let realm = try! Realm()
        
        try! realm.write {
            config_realm.conf = encoderData
            realm.add(config_realm)
        }
        
    }
    
    static func loadConfig() -> Configuration? {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        
        
        if let result = realm.objects(ConfigRealm.self).first {
            let obj = try? JSONDecoder().decode(Configuration.self, from: result.conf!)
            
            return obj!
        }
        
        return nil
        
    }
    
    static func removeConfig() {
        let realm = try! Realm()
        try! realm.write {            
            let result = realm.objects(ConfigRealm.self)
            realm.delete(result)
        }
    }
    
}
