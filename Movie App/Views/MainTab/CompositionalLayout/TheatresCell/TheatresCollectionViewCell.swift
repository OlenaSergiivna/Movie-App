//
//  TheatresCollectionViewCell.swift
//  Movie App
//
//  Created by user on 29.10.2022.
//

import UIKit
import Kingfisher

class TheatresCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
//    override func layoutSublayers(of layer: CALayer) {
//        
//        movieImage.translatesAutoresizingMaskIntoConstraints = false
//        movieImage.backgroundColor = .systemBackground
//        movieImage.clipsToBounds = true
//        movieImage.contentMode = .scaleAspectFill
//        movieImage.layer.cornerRadius = 12
//    }
    
    func configure(with data: [MovieModel], indexPath: IndexPath) {
        
        // add case when name is empty but title is not
        if !data.isEmpty {
            
            movieImage.isHidden = false
            
            if let imagePath = data[indexPath.row].posterPath {
                
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
                
            } else {
                movieImage.image = .strokedCheckmark
            }

        }
        
    }
}
