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
        return mediaName
    }()
    
//    private let characterLabel: UILabel = {
//        let characterLabel = UILabel()
//        characterLabel.translatesAutoresizingMaskIntoConstraints = false
//        characterLabel.text = "Hello"
//        characterLabel.textColor = .darkGray
//        characterLabel.contentMode = .center
//        characterLabel.textAlignment = .center
//        characterLabel.font = .systemFont(ofSize: 8)
//        characterLabel.adjustsFontSizeToFitWidth = true
//        characterLabel.minimumScaleFactor = 0.3
//        return characterLabel
//    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
       
        contentView.addSubview(mediaImage)
        contentView.addSubview(mediaName)
        //contentView.addSubview(characterLabel)
        
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
    }
    
    
    func configure<T>(with data: T) {
        
        if let data = data as? MovieModel {
            configureMovie(with: data)
        } else if let data = data as? TVModel {
            configureTV(with: data)
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


