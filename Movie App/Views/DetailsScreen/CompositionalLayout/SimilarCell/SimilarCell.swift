//
//  SimilarCell.swift
//  Movie App
//
//  Created by user on 08.12.2022.
//

import UIKit

class SimilarMediaCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "SimilarMediaCollectionViewCell"

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let mediaImage: UIImageView = {
        let mediaImage = UIImageView()
        mediaImage.translatesAutoresizingMaskIntoConstraints = false
        mediaImage.contentMode = .scaleAspectFill
        mediaImage.clipsToBounds = true
        mediaImage.layer.cornerRadius = 20
        mediaImage.isSkeletonable = true
        mediaImage.image = UIImage()
        mediaImage.isHidden = false
        return mediaImage
    }()
    
    
    private let mediaName: UILabel = {
        let mediaName = UILabel()
        mediaName.translatesAutoresizingMaskIntoConstraints = false
        mediaName.text = ""
        mediaName.textColor = .white
        mediaName.textAlignment = .center
        mediaName.contentMode = .center
        mediaName.font = .systemFont(ofSize: 10)
        mediaName.adjustsFontSizeToFitWidth = true
        mediaName.isSkeletonable = true
        mediaName.isHidden = false
        return mediaName
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        isSkeletonable = true
        
        contentView.isSkeletonable = true
        contentView.addSubview(mediaImage)
        contentView.addSubview(mediaName)
        
        NSLayoutConstraint.activate([
            
            mediaImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            mediaImage.widthAnchor.constraint(equalToConstant: contentView.frame.size.width),
            mediaImage.heightAnchor.constraint(equalToConstant: contentView.frame.size.height - 30),
            
            mediaName.topAnchor.constraint(equalTo: mediaImage.bottomAnchor, constant: 4),
            mediaName.leadingAnchor.constraint(greaterThanOrEqualTo: mediaImage.leadingAnchor),
            mediaName.trailingAnchor.constraint(greaterThanOrEqualTo: mediaImage.trailingAnchor),
            mediaName.centerXAnchor.constraint(equalTo: mediaImage.centerXAnchor),
            
        ])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mediaImage.image = nil
        mediaName.text = nil
        
        mediaImage.isHidden = false
        mediaName.isHidden = false 
    }
    
    
    func configure(with data: Media) {
        switch data {
            
        case .movie(let movie):
            configureMovie(with: movie)
            
        case .tvShow(let tvShow):
            configureTV(with: tvShow)
        }
    }
    
    
    func configureMovie(with data: MovieModel) {
        
        mediaName.text = data.title
        
        guard let backdropPath = data.backdropPath else {
            mediaImage.image = .strokedCheckmark
            return
        }

        KingsfisherManager.shared.setImage(profilePath: backdropPath, image: mediaImage)
    }
    
    
    func configureTV(with data: TVModel) {
        
        mediaName.text = data.name
        
        guard let backdropPath = data.backdropPath else {
            mediaImage.image = .strokedCheckmark
            return
        }

        KingsfisherManager.shared.setImage(profilePath: backdropPath, image: mediaImage)
    }
}


