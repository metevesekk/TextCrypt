//
//  SettingsManager.swift
//  TextCrypt
//
//  Created by Mete Vesek on 27.12.2023.
//

import Foundation

class SettingsManager {
    
    static let shared = SettingsManager()
    private init() {}
    
    private let switchkey = "switchStatus"
    
    func setSwitchStatus(status: Bool){
        UserDefaults.standard.setValue(status, forKey: switchkey)
    }
    
    func getSwitchStatus() -> Bool{
        return UserDefaults.standard.bool(forKey: switchkey)
    }
    
}
