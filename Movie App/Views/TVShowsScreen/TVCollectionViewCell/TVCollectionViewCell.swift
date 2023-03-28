//
//  TVCollectionViewCell.swift
//  Movie App
//
//  Created by user on 15.10.2022.
//

import UIKit

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
        
        KingsfisherManager.shared.setImage(imagePath: imagePath, setFor: tvImage, size: "w342")
    }
}
