//
//  String+ Extension.swift
//  Movie App
//
//  Created by user on 13.10.2022.
//

import Foundation

extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}
