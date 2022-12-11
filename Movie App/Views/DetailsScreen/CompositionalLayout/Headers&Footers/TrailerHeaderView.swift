//
//  TrailerHeaderView.swift
//  Movie App
//
//  Created by user on 11.12.2022.
//

import UIKit

class TrailerHeaderView: UICollectionReusableView {
    
    static let headerIdentifier = "TrailerHeaderView"
    
    lazy var headerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Trailer"
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        addSubview(headerLabel)
        
        setUpConstrains()
    }
    
    
    func setUpConstrains() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



