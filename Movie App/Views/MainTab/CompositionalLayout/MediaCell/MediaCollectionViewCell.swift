//
//  MediaCollectionViewCell.swift
//  Movie App
//
//  Created by user on 22.10.2022.
//

import UIKit

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
        mediaImage.backgroundColor = .clear
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
        
        KingsfisherManager.shared.setImage(imagePath: imagePath, setFor: mediaImage, size: "w500", cornerRadius: 5)
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
        
        KingsfisherManager.shared.setImage(imagePath: imagePath, setFor: mediaImage, size: "w500", cornerRadius: 5)
    }
}
