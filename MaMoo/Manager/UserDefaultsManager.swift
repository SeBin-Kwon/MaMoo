//
//  UserDefaultsManager.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/26/25.
//

import Foundation

enum UserDefaultsManager {
    
    enum Key: String {
        case isDisplayedOnboarding
        case nickname
        case profileImage
        case signUpDate
        case searchResults
        case like
    }
    
    static func removeObject<T: Hashable>(key: Key, type: T.Type) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

    @MaMooUserDefaults(key: Key.isDisplayedOnboarding.rawValue, defaultValue: false) static var isDisplayedOnboarding
    @MaMooUserDefaults(key: Key.nickname.rawValue, defaultValue: "No Name") static var nickname
    @MaMooUserDefaults(key: Key.profileImage.rawValue, defaultValue: 0) static var profileImage
    @MaMooUserDefaults(key: Key.signUpDate.rawValue, defaultValue: "No Date") static var signUpDate
    @MaMooUserDefaults(key: Key.searchResults.rawValue, defaultValue: [String]()) static var searchResults
    @MaMooUserDefaults(key: Key.like.rawValue, defaultValue:  [String: Bool]()) static var like
    
}

@propertyWrapper struct MaMooUserDefaults<T: Hashable> {
    let key: String
    let defaultValue: T
    private let userDefaults = UserDefaults.standard
    
    var wrappedValue: T {
        get { userDefaults.object(forKey: key) as? T ?? defaultValue }
        set { userDefaults.set(newValue, forKey: key) }
    }
}
