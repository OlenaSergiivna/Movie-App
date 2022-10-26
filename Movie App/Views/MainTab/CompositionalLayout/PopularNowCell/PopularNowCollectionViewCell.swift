//
//  PopularNowCollectionViewCell.swift
//  Movie App
//
//  Created by user on 25.10.2022.
//

import UIKit
import Kingfisher

class PopularNowCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    
    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.movieImage.layer.masksToBounds = true
//        self.movieImage.clipsToBounds = true
//        self.movieImage.layer.cornerRadius = 15
    
    }
    

    
    func configure(with data: [TrendyMedia], indexPath: IndexPath) {
        
        // add case when name is empty but title is not
        if !data.isEmpty {
            
            movieImage.isHidden = false
            movieNameLabel.isHidden = false
            movieNameLabel.isEnabled = true
            
            if let movieName = data[indexPath.row].name {
                movieNameLabel.text = movieName
            } else {
                movieNameLabel.text = data[indexPath.row].title
            }
            
            
            if let imagePath = data[indexPath.row].backdropPath {
                
                let url = URL(string: "https://image.tmdb.org/t/p/original/\(imagePath)")
                let processor = DownsamplingImageProcessor(size: movieImage.bounds.size)
                             |> RoundCornerImageProcessor(cornerRadius: 10)
                movieImage.kf.indicatorType = .activity
                movieImage.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "loading"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        
                    ])
    //            {
    //                result in
    //                switch result {
    //                case .success(let value):
    //                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
    //                case .failure(let error):
    //                    print("Job failed: \(error.localizedDescription)")
    //                }
    //            }
                
//                let cashe = Kingfisher.ImageCache.default
//                cashe.memoryStorage.config.countLimit = 16
////                
//                self.movieImage.layer.masksToBounds = true
//                self.movieImage.layer.cornerRadius = 30
                
            } else {
                movieImage.image = .strokedCheckmark
                movieNameLabel.isHidden = false
                movieNameLabel.isEnabled = true
            }

        }
        
    }

}
