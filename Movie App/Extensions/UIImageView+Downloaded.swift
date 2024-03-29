//
//  UIImageView+Downloaded.swift
//  Movie App
//
//  Created by user on 03.10.2022.
//

import UIKit

extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                
                return
            }
            
            DispatchQueue.main.async() { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
        
    }
}
