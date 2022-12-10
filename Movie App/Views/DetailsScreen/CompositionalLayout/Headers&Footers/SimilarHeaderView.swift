//
//  SimilarHeaderView.swift
//  Movie App
//
//  Created by user on 08.12.2022.
//

import UIKit

class SimilarHeaderView: UICollectionReusableView {
    
    static let headerIdentifier = "SimilarHeaderView"
    
    lazy var similarLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Similar media"
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        addSubview(similarLabel)
        
        setUpConstrains()
    }
    
    func setUpConstrains() {
        NSLayoutConstraint.activate([
            similarLabel.topAnchor.constraint(equalTo: topAnchor),
            similarLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



