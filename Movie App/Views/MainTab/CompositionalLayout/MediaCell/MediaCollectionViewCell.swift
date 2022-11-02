//
//  MediaCollectionViewCell.swift
//  Movie App
//
//  Created by user on 22.10.2022.
//

import UIKit
import Kingfisher

class MediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaImage: UIImageView!
    
    @IBOutlet weak var mediaTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mediaImage.image = nil
        mediaTitle.text = nil
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mediaImage.translatesAutoresizingMaskIntoConstraints = false
        mediaImage.backgroundColor = .systemBackground
        mediaImage.clipsToBounds = true
        mediaImage.contentMode = .scaleAspectFill
        mediaImage.layer.cornerRadius = 12
    }
    
    
    func configureMovie(with data: [MovieModel], indexPath: IndexPath) {
        
        guard let title = data[indexPath.row].title else {
            
            mediaImage.image = .strokedCheckmark
            mediaTitle.isHidden = false
            mediaTitle.isEnabled = true
            
            return
        }
        
        mediaImage.isHidden = false
        mediaTitle.isHidden = true
        mediaTitle.isEnabled = true
        
        mediaTitle.text = title
        
        guard let imagePath = data[indexPath.row].posterPath else {
            mediaImage.image = .strokedCheckmark
            return
        }
        
        let url = URL(string: "https://image.tmdb.org/t/p/w300/\(imagePath)")
        let processor = DownsamplingImageProcessor(size: mediaImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 5)
        mediaImage.kf.indicatorType = .activity
        mediaImage.kf.setImage(
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
    }
    
    
    func configureTV(with data: [TVModel], indexPath: IndexPath) {
        
        guard !data.isEmpty else {
            
            mediaImage.image = .strokedCheckmark
            mediaTitle.isHidden = false
            mediaTitle.isEnabled = true
            
            return
        }
        
        mediaImage.isHidden = false
        mediaTitle.isHidden = true
        mediaTitle.isEnabled = true
        
        mediaTitle.text = data[indexPath.row].name
        
        guard let imagePath = data[indexPath.row].posterPath else {
            
            mediaImage.image = .strokedCheckmark
            return
        }
        
        let url = URL(string: "https://image.tmdb.org/t/p/w200/\(imagePath)")
        let processor = DownsamplingImageProcessor(size: mediaImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 5)
        mediaImage.kf.indicatorType = .activity
        mediaImage.kf.setImage(
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
    }
}
