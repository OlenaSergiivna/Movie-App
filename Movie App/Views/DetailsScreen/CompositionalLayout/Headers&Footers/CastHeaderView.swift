//
//  CastHeaderView.swift
//  Movie App
//
//  Created by user on 08.12.2022.
//

import UIKit

class CastHeaderView: UICollectionReusableView {
    
    static let headerIdentifier = "CastHeaderView"
    
    lazy var castLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Cast"
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        addSubview(castLabel)
        
        setUpConstrains()
    }
    
    func setUpConstrains() {
        NSLayoutConstraint.activate([
            castLabel.topAnchor.constraint(equalTo: topAnchor),
            castLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


