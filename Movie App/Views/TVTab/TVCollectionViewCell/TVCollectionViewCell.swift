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
        
        self.tvImage.layer.masksToBounds = true
        self.tvImage.layer.cornerRadius = 12
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tvImage.image = nil
        tvNameLabel.text = nil
    }
    
    
    func configure(with data: [TVModel], indexPath: IndexPath) {
        
        tvImage.isHidden = false
        tvNameLabel.isHidden = false
        tvNameLabel.isEnabled = true
        
        // add case when name is empty but title is not
        guard !data.isEmpty else { return }
        
        tvNameLabel.text = data[indexPath.row].name
        
        guard let imagePath = data[indexPath.row].posterPath else {
            
            tvImage.image = .strokedCheckmark
            return
        }
        
        let url = URL(string: "https://image.tmdb.org/t/p/w200/\(imagePath)")
        let processor = DownsamplingImageProcessor(size: tvImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 0)
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
        
    }
}
