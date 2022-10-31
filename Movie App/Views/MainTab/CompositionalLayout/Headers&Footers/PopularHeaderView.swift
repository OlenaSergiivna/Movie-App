//
//  Header.swift
//  Movie App
//
//  Created by user on 26.10.2022.
//

import UIKit

class PopularHeaderView: UICollectionReusableView {
    
    //MARK: Properities
    
    static let headerIdentifier = "PopularHeaderView"
    
    lazy var popularLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Popular now"
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return label
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        addSubview(popularLabel)
        
        setUpConstrains()
    }
    
    func setUpConstrains() {
        NSLayoutConstraint.activate([
            popularLabel.topAnchor.constraint(equalTo: topAnchor),
            popularLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

