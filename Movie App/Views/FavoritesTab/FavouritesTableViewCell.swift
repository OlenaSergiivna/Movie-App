//
//  FavouritesTableViewCell.swift
//  Movie App
//
//  Created by user on 06.10.2022.
//

import UIKit
import Kingfisher

class FavouritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var someBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
  
    }
    
    func configure(with data: MovieModel) {
        
        if let title = data.title, let overview = data.overview {
            
            movieTitleLabel.text = title
            overviewLabel.text = overview
            someBackView.layer.masksToBounds = true
            someBackView.layer.cornerRadius = 10
        }
          
            
       if let imagePath = data.posterPath {
            
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
                    .cacheOriginalImage
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
           
        } else {
            return
        }
    }
}
