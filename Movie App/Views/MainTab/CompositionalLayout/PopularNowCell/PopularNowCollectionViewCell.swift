//
//  PopularNowCollectionViewCell.swift
//  Movie App
//
//  Created by user on 25.10.2022.
//

import UIKit

class PopularNowCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    @IBOutlet weak var movieImage: UIImageView!
    
   weak var delegate: PopularNowDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSwipeRecognizer()
    }
    
    
    func addSwipeRecognizer() {
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(PopularNowCollectionViewCell.cellSwiped(sender:)))
        swipeLeft.direction = .left
        swipeLeft.delegate = self
        self.addGestureRecognizer(swipeLeft)
        self.isUserInteractionEnabled = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(PopularNowCollectionViewCell.cellSwiped(sender:)))
        swipeRight.direction = .right
        swipeRight.delegate = self
        self.addGestureRecognizer(swipeRight)
        self.isUserInteractionEnabled = true
    }
    
    
    @objc func cellSwiped(sender: UISwipeGestureRecognizer) {
        delegate?.popularNowSwiped()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.movieImage.translatesAutoresizingMaskIntoConstraints = false
        self.movieImage.backgroundColor = .clear
        self.movieImage.clipsToBounds = true
        self.movieImage.contentMode = .scaleAspectFill
        self.movieImage.layer.cornerRadius = 12
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movieImage.image = nil
        movieNameLabel.text = nil
    }
    
    
    func configure(with data: [TrendyMedia], indexPath: IndexPath) {
        
        guard !data.isEmpty else {
            movieImage.image = .strokedCheckmark
            movieNameLabel.isHidden = true
            movieNameLabel.isEnabled = false
            
            return
        }
        
        movieImage.isHidden = false
        movieNameLabel.isHidden = false
        movieNameLabel.isEnabled = true
        
        if let movieName = data[indexPath.row].name {
            movieNameLabel.text = movieName
        } else {
            movieNameLabel.text = data[indexPath.row].title
        }
        
        
        guard let imagePath = data[indexPath.row].backdropPath else {
            
            movieImage.image = .strokedCheckmark
            return
        }
        
        KingsfisherManager.shared.setImage(profilePath: imagePath, image: movieImage, cornerRadius: 10)
    }
}


extension PopularNowCollectionViewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

protocol PopularNowDelegate: AnyObject {
    func popularNowSwiped()
}
