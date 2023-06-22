//
//  KeychainManagerProtocol.swift
//  Movie App
//
//  Created by user on 01.04.2023.
//

import Foundation

protocol KeychainManagerProtocol {
    func savePasswordFor(login: String, password: String, completion: ((Result<Bool, Error>) -> Void)?)
    func getPasswordFor(login: String, completion: ((Result<String, Error>) -> Void)?)
    func deletePasswordFor(login: String, completion: ((Result<Bool, Error>) -> Void)?)
    func getAllKeys() -> [String]
    func removeAllItems(completion: ((Result<Bool,Error>)->Void)?)
}
