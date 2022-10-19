//
//  AlamofireConnectionService.swift
//  Movie App
//
//  Created by user on 17.10.2022.
//

import Alamofire

public struct Connectivity {
  static let shared = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.shared.isReachable
    }
}
