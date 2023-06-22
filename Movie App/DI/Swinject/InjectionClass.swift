//
//  Injection.swift
//  Movie App
//
//  Created by user on 26.03.2023.
//

import Foundation
import Swinject

final class Injection {
    
    static let shared = Injection()
    
    var container: Container {
        get {
            if _container == nil {
                _container = buildContainer()
            }
            return _container!
        }
        set {
            _container = newValue
        }
    }
    
    private var _container: Container?
    
    private func buildContainer() -> Container {
        let container = Container()
        container.register(DetailsServiceProtocol.self) { _ in return DetailsService() }
        container.register(KeychainManagerProtocol.self) { _ in return KeychainManager() }
        return container
    }
}
