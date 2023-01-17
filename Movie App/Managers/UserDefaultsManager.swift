//
//  UserDefaultsManager.swift
//  Movie App
//
//  Created by user on 14.12.2022.
//

import Foundation

struct UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    func saveUsersDataInUserDefaults(login: String? = nil, password: String? = nil, sesssionID: String, isGuestSession: Bool, userID: Int? = nil, username: String? = nil, userAvatar: String? = nil, sessionExpireDate: String? = nil) {
        
        UserDefaults.standard.set(login, forKey: "userlogin")
        UserDefaults.standard.set(password, forKey: "userpass")
        UserDefaults.standard.set(sesssionID, forKey: "usersessionid")
        UserDefaults.standard.set(isGuestSession, forKey: "isguestsession")
        
        UserDefaults.standard.set(userID, forKey: "userid")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(userAvatar, forKey: "useravatar")
    }
    
    
    func deleteUsersDataFromUserDefaults() {
    
        UserDefaults.standard.removeObject(forKey: "userlogin")
        UserDefaults.standard.removeObject(forKey: "userpass")
        UserDefaults.standard.removeObject(forKey: "usersessionid")
        UserDefaults.standard.removeObject(forKey: "isguestsession")
        
        UserDefaults.standard.removeObject(forKey: "userid")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "useravatar")
    }
    
    
    func getKeyFor(_ key: UserDefaultsKeys) -> String {
        switch key {
        case .login:
            return "userlogin"
        case .password:
            return "userpass"
        case .sessionID:
            return "usersessionid"
        case .isGuestSession:
            return "isguestsession"
        case .userID:
            return "userid"
        case .username:
            return "username"
        case .userAvatar:
            return "useravatar"
        case .searchResults:
            return "searchResults"
        }
    }
}


enum UserDefaultsKeys: String {
    
    case login
    case password
    case sessionID
    case isGuestSession
    
    case userID
    case username
    case userAvatar
    case searchResults
}

