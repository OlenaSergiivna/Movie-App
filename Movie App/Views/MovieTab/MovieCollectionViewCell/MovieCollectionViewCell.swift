//
//  MovieCollectionViewCell.swift
//  Movie App
//
//  Created by user on 28.09.2022.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.movieImage.layer.masksToBounds = true
        self.movieImage.layer.cornerRadius = 12
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movieImage.image = nil
        movieNameLabel.text = nil
    }
    
    
    func configure(with data: [MovieModel], indexPath: IndexPath) {
        
        // add case when name is empty but title is not
        guard !data.isEmpty else {
            movieImage.image = .strokedCheckmark
            return
        }
            movieImage.isHidden = false
            movieNameLabel.isHidden = false
            movieNameLabel.isEnabled = true
            
            if let title = data[indexPath.row].title {
                
                movieNameLabel.text = title
            }
            
            if let imagePath = data[indexPath.row].posterPath {
                
                let url = URL(string: "https://image.tmdb.org/t/p/w200/\(imagePath)")
                let processor = DownsamplingImageProcessor(size: movieImage.bounds.size)
                             |> RoundCornerImageProcessor(cornerRadius: 0)
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
                
                let cashe = Kingfisher.ImageCache.default
                cashe.memoryStorage.config.countLimit = 16
            } else {
                movieImage.image = .strokedCheckmark
                movieNameLabel.isHidden = false
                movieNameLabel.isEnabled = true
            }
    }
    
}
