//
//  ReviewsCell.swift
//  Movie App
//
//  Created by user on 08.12.2022.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "ReviewsCollectionViewCell"

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let personsImage: UIImageView = {
        let personsImage = UIImageView()
        personsImage.translatesAutoresizingMaskIntoConstraints = false
        personsImage.contentMode = .scaleAspectFill
        personsImage.clipsToBounds = true
        personsImage.layer.cornerRadius = personsImage.frame.width / 2
        return personsImage
    }()
    
    
    private let paddingView: UIView = {
        let paddingView = UIView()
        paddingView.backgroundColor = .systemPink
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        paddingView.clipsToBounds = true
        paddingView.backgroundColor = #colorLiteral(red: 0.1529411376, green: 0.1529411376, blue: 0.1529411376, alpha: 1)
        paddingView.layer.cornerRadius = 10
        return paddingView
    }()
    
    
    private let reviewLabel: UILabel = {
        let reviewLabel = UILabel()
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewLabel.text = ""
        reviewLabel.textColor = .white
        reviewLabel.textAlignment = .left
        reviewLabel.font = .systemFont(ofSize: 14)
        reviewLabel.adjustsFontSizeToFitWidth = true
        reviewLabel.numberOfLines = 0
        return reviewLabel
    }()
    
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = ""
        nameLabel.textColor = .darkGray
        nameLabel.contentMode = .center
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 8)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.3
        return nameLabel
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(paddingView)
        addSubview(personsImage)
        contentView.addSubview(reviewLabel)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            
            paddingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            paddingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            paddingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            paddingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            personsImage.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 16),
            personsImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            personsImage.heightAnchor.constraint(equalToConstant: 30),
            personsImage.widthAnchor.constraint(equalToConstant: 30),
            
            nameLabel.centerYAnchor.constraint(equalTo: personsImage.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: personsImage.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: paddingView.trailingAnchor, constant: -16),
            
            reviewLabel.topAnchor.constraint(equalTo: personsImage.bottomAnchor, constant: 16),
            reviewLabel.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor, constant: -16),
            reviewLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),
            reviewLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -8)
            
        ])
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        reviewLabel.text = nil
    }
    
    
    func configure(with data: ReviewsModel) {

        nameLabel.text = data.authorDetails.username
        reviewLabel.text = data.content

        guard let avatarPath = data.authorDetails.avatarPath else {

            personsImage.image = .strokedCheckmark
            return
        }

        KingsfisherManager.shared.setImage(profilePath: avatarPath, image: personsImage)
    }
}

