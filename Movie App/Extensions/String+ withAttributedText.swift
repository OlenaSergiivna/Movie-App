//
//  String+ withAttributedText.swift
//  Movie App
//
//  Created by user on 05.05.2023.
//

import UIKit

extension String {

    func withAttributedText(text: String, font: UIFont? = nil, weight: UIFont.Weight, color: UIColor?) -> NSAttributedString {
      
        let _font = font ?? UIFont.systemFont(ofSize: 14, weight: weight)
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17) ]
        let range = (self as NSString).range(of: text)
        fullString.addAttributes(boldFontAttribute, range: range)
        
        if let textColor = color {
                fullString.addAttributes([NSAttributedString.Key.foregroundColor: textColor], range: range)
            }
        return fullString
    }}

