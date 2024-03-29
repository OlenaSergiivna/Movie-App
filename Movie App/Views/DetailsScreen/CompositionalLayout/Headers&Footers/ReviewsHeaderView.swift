//
//  ReviewsHeaderView.swift
//  Movie App
//
//  Created by user on 08.12.2022.
//

import UIKit

class ReviewsHeaderView: UICollectionReusableView {
    
    static let headerIdentifier = "ReviewsHeaderView"
    
    lazy var reviewsLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Reviews"
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        addSubview(reviewsLabel)
        
        setUpConstrains()
    }
    
    func setUpConstrains() {
        NSLayoutConstraint.activate([
            reviewsLabel.topAnchor.constraint(equalTo: topAnchor),
            reviewsLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



