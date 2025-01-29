//
//  UserDefaultsManager.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/26/25.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    private let userDefaults = UserDefaults.standard
    
    enum UserDefaultsKey: String {
        case isDisplayedOnboarding
        case nickname
        case profileImage
        case signUpDate
        case searchResults
        case like
    }
    
    func getter<T>(key: UserDefaultsKey, defaultValue: T) -> T {
        userDefaults.object(forKey: key.rawValue) as? T ?? defaultValue
    }
    
    func setter<T>(value: T, key: UserDefaultsKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    var isDisplayedOnboarding: Bool {
        get { getter(key: .isDisplayedOnboarding, defaultValue: false) }
        set { setter(value: newValue, key: .isDisplayedOnboarding) }
    }
    
    var nickname: String {
        get { getter(key: .nickname, defaultValue: "No Name") }
        set { setter(value: newValue, key: .nickname) }
    }
    
    var profileImage: Int {
        get { getter(key: .profileImage, defaultValue: 0) }
        set { setter(value: newValue, key: .profileImage) }
    }
    
    var signUpDate: String {
        get { getter(key: .signUpDate, defaultValue: "No Date") }
        set { setter(value: newValue, key: .signUpDate) }
    }
    
    var searchResults: [String] {
        get { getter(key: .searchResults, defaultValue: [String]()) }
        set { setter(value: newValue, key: .searchResults) }
    }
    
}
