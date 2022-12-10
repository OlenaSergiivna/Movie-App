//
//  KeychainManager.swift
//  Movie App
//
//  Created by user on 30.11.2022.
//

import Foundation

class KeychainManager {
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    static func save(service: String, account: String, password: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
       guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
    }
    
    static func get() throws {
        
    }
}
