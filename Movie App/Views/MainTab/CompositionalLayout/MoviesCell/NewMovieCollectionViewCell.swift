//
//  NewMovieCollectionViewCell.swift
//  Movie App
//
//  Created by user on 22.10.2022.
//

import UIKit
import Kingfisher

class NewMovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.movieImage.layer.masksToBounds = true
        self.movieImage.layer.cornerRadius = 12
    }

    
    func configure(with data: [MovieModel], indexPath: IndexPath) {
        
        // add case when name is empty but title is not
        if !data.isEmpty {
            
            movieImage.isHidden = false
            movieTitle.isHidden = false
            movieTitle.isEnabled = true
            
            if let title = data[indexPath.row].title {
                
                movieTitle.text = title
            }
            
            if let imagePath = data[indexPath.row].posterPath {
                
                let url = URL(string: "https://image.tmdb.org/t/p/w200/\(imagePath)")
                let processor = DownsamplingImageProcessor(size: movieImage.bounds.size)
                             |> RoundCornerImageProcessor(cornerRadius: 5)
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
                
                self.movieImage.layer.masksToBounds = true
                self.movieImage.layer.cornerRadius = 12
            } else {
                movieImage.image = .strokedCheckmark
                movieTitle.isHidden = false
                movieTitle.isEnabled = true
            }

        }
        
    }
    
}
