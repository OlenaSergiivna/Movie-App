//
//  TVCollectionViewCell.swift
//  Movie App
//
//  Created by user on 15.10.2022.
//

import UIKit
import Kingfisher

class TVCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tvImage: UIImageView!
    
    @IBOutlet weak var tvNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func configure(with data: [TVModel], indexPath: IndexPath) {
        
        // add case when name is empty but title is not
        if !data.isEmpty {
            
            tvImage.isHidden = false
            tvNameLabel.isHidden = false
            tvNameLabel.isEnabled = true
            
            tvNameLabel.text = data[indexPath.row].name
        
            
            if let imagePath = data[indexPath.row].posterPath {
                
                let url = URL(string: "https://image.tmdb.org/t/p/w200/\(imagePath)")
                let processor = DownsamplingImageProcessor(size: tvImage.bounds.size)
                             |> RoundCornerImageProcessor(cornerRadius: 10)
                tvImage.kf.indicatorType = .activity
                tvImage.kf.setImage(
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
                tvImage.image = .strokedCheckmark
                tvNameLabel.isHidden = false
                tvNameLabel.isEnabled = true
            }

        }
        
    }

}
