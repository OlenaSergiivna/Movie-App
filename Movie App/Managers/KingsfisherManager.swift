//
//  KingsfisherManager.swift
//  Movie App
//
//  Created by user on 11.12.2022.
//

import Foundation
import Kingfisher

struct KingsfisherManager {
    
    static let shared = KingsfisherManager()
    
    private init() {}
    
    func setImage(profilePath: String, image: UIImageView, cornerRadius: CGFloat = 0) {
        
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(profilePath)")
        
        let processor = DownsamplingImageProcessor(size: image.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: cornerRadius)
        image.kf.indicatorType = .activity
        image.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),

            ])
//                    {
//                        result in
//                        switch result {
//                        case .success(let value):
//                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                        case .failure(let error):
//                            print("Job failed: \(error.localizedDescription)")
//                        }
//                    }
    }
}
