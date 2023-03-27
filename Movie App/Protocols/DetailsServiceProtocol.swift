//
//  DetailsServiceProtocol.swift
//  Movie App
//
//  Created by user on 25.03.2023.
//

import UIKit

protocol DetailsServiceProtocol {
    var isSecondaryScreen: Bool { get set }
    func openDetailsScreen<T>(with data: T, viewController: UIViewController)
}
