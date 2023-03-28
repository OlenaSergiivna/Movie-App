//
//  CastCollectionViewCell.swift
//  Movie App
//
//  Created by user on 12.11.2022.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "CastCollectionViewCell"

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let castImage: UIImageView = {
        let castImage = UIImageView()
        castImage.translatesAutoresizingMaskIntoConstraints = false
        castImage.contentMode = .scaleAspectFill
        castImage.clipsToBounds = true
        castImage.layer.cornerRadius = 20
        castImage.isSkeletonable = true
        castImage.image = UIImage()
        castImage.isHidden = false
        return castImage
    }()
    
    
    private let backLabel: UILabel = {
        let backLabel = UILabel()
        backLabel.translatesAutoresizingMaskIntoConstraints = false
        backLabel.isHidden = true
        backLabel.text = ""
        backLabel.textColor = .darkGray
        backLabel.numberOfLines = 3
        backLabel.font = .systemFont(ofSize: 12, weight: .bold)
        backLabel.adjustsFontSizeToFitWidth = true
        backLabel.isSkeletonable = true
        return backLabel
    }()
    
    
    private let castLabel: UILabel = {
        let castLabel = UILabel()
        castLabel.translatesAutoresizingMaskIntoConstraints = false
        castLabel.text = ""
        castLabel.textColor = .white
        castLabel.textAlignment = .center
        castLabel.contentMode = .center
        castLabel.font = .systemFont(ofSize: 10)
        castLabel.adjustsFontSizeToFitWidth = true
        castLabel.isSkeletonable = true
        castLabel.isHidden = false
        return castLabel
    }()
    
    
    private let characterLabel: UILabel = {
        let characterLabel = UILabel()
        characterLabel.translatesAutoresizingMaskIntoConstraints = false
        characterLabel.text = ""
        characterLabel.textColor = .darkGray
        characterLabel.contentMode = .center
        characterLabel.textAlignment = .center
        characterLabel.font = .systemFont(ofSize: 8)
        characterLabel.adjustsFontSizeToFitWidth = true
        characterLabel.minimumScaleFactor = 0.3
        characterLabel.isSkeletonable = true
        characterLabel.isHidden = false
        return characterLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        isSkeletonable = true
        
        contentView.isSkeletonable = true
        contentView.addSubview(backLabel)
        contentView.addSubview(castImage)
        contentView.addSubview(castLabel)
        contentView.addSubview(characterLabel)
        
        NSLayoutConstraint.activate([
            
            castImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            castImage.widthAnchor.constraint(equalToConstant: contentView.frame.size.width),
            castImage.heightAnchor.constraint(equalToConstant: contentView.frame.size.height - 30),
            
            castLabel.topAnchor.constraint(equalTo: castImage.bottomAnchor, constant: 4),
            castLabel.leadingAnchor.constraint(greaterThanOrEqualTo: castImage.leadingAnchor),
            castLabel.trailingAnchor.constraint(greaterThanOrEqualTo: castImage.trailingAnchor),
            castLabel.centerXAnchor.constraint(equalTo: castImage.centerXAnchor),
            
            characterLabel.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 4),
            characterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            characterLabel.leadingAnchor.constraint(greaterThanOrEqualTo: castLabel.leadingAnchor),
            characterLabel.centerXAnchor.constraint(equalTo: castLabel.centerXAnchor),
            characterLabel.trailingAnchor.constraint(greaterThanOrEqualTo: castLabel.trailingAnchor),
            
            backLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            backLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            backLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backLabel.isHidden = true
        castImage.image = nil
        castLabel.text = nil
        characterLabel.text = nil
    }
    
    
    func configure(with data: CastModel) {
        
        castLabel.text = data.name
        
        configureCharacterLabel(data: data)
        
        guard let profilePath = data.profilePath else {

            backLabel.isHidden = false
            backLabel.text = data.name
            return
        }
        
        KingsfisherManager.shared.setImage(imagePath: profilePath, setFor: castImage)
    }
    
    
    private func configureCharacterLabel(data: CastModel) {
        
        guard let characterString = data.character else {
            characterLabel.text = "  "
            return
        }
        
        guard !characterString.isEmpty else {
            characterLabel.text = "  "
            return
        }
        
        characterLabel.text = characterString
        
        if let index = characterString.range(of: "/")?.lowerBound {
            let substring = characterString[..<index]
            
            characterLabel.text = String(substring.dropLast(1))
        }
    }
}
