//
//  KeychainManager.swift
//  Movie App
//
//  Created by user on 30.11.2022.
//

import Foundation
import KeychainAccess

enum KeychainErrors: String, Error {
    case noValue
}

class KeychainManager: KeychainManagerProtocol {
     
    let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")
        .accessibility(.whenUnlocked)
    
    
    func savePasswordFor(login: String, password: String, completion: ((Result<Bool, Error>)-> Void)? = nil) {
//        let prompt = "Enable FaceID to login?"
        
        DispatchQueue.global().async {
            do {
                try self.keychain
//                    .accessibility(.whenUnlocked, authenticationPolicy: [.biometryAny, .or, .devicePasscode])
//                    .authenticationPrompt(prompt)
                    .set(password, key: login)
                
                completion?(.success(true))
                
            } catch let error {
                completion?(.failure(error))
            }
        }
    }
    
    func getPasswordFor(login: String, completion: ((Result<String, Error>) -> Void)? = nil) {
        
        DispatchQueue.global().async {
            do {
                            
                guard let pass = try self.keychain
                    .accessibility(.whenUnlocked, authenticationPolicy: [.biometryAny, .or, .devicePasscode])
                    .get(login) else {
                    completion?(.failure(KeychainErrors.noValue))
                    return
                }
                
                completion?(.success(pass))

            } catch let error {
                completion?(.failure(error))
            }
        }
    }
    
    func deletePasswordFor(login: String, completion: ((Result<Bool,Error>) -> Void)? = nil) {
        
        do {
            try keychain.remove(login)
           completion?(.success(true))
        } catch let error {
            completion?(.failure(error))
        }
    }
    
    
    func getAllKeys() -> [String] {
        let keys = keychain.allKeys()
        return keys
    }
    
    
    func removeAllItems(completion: ((Result<Bool,Error>)->Void)? = nil) {
        do {
            try keychain.removeAll()
            completion?(.success(true))
        } catch let error {
            completion?(.failure(error))
        }
    }
}
