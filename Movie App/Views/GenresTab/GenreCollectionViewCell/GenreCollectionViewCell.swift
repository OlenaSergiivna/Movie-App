//
//  GenreCollectionViewCell.swift
//  Movie App
//
//  Created by user on 28.09.2022.
//

import UIKit
import Kingfisher

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with data: [MovieModel], indexPath: IndexPath) {
        if !data.isEmpty {
            
            guard let title =  data[indexPath.row].title, let imagePath = data[indexPath.row].posterPath  else {
                movieNameLabel.text = "empty"
                print("EMPTY")
                movieNameLabel.text = "NAFO"
                movieImage.image = UIImage(named: "nafo")
                movieImage.contentMode = .scaleAspectFill
                return
            }
            
            
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(imagePath)")
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
            
            movieNameLabel.text = title
        }
        
    }
    
}
