//
//  @Injected .swift
//  Movie App
//
//  Created by user on 26.03.2023.
//

import Foundation

@propertyWrapper struct Injected<Dependency> {
  var wrappedValue: Dependency
 
  init() {
    self.wrappedValue =
            Injection.shared.container.resolve(Dependency.self)!
  }
}
