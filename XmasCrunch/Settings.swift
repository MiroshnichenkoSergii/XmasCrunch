//
//  Settings.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 05.01.2023.
//

import Foundation

enum KeysUserDefaults {
    static let settings = "settings"
}

struct GameSetting: Codable {
    var level: Int
    var music: Bool
}

class Setting {
    
    static var shared = Setting()
    
    var defaultSettings = GameSetting(level: 0, music: true)
    
    var currentSettings: GameSetting {
        get {
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.settings) as? Data {
                return try! PropertyListDecoder().decode(GameSetting.self, from: data)
            } else {
                if let data = try? PropertyListEncoder().encode(defaultSettings) {
                    UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settings)
                }
                return defaultSettings
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settings)
            }
        }
    }
}
