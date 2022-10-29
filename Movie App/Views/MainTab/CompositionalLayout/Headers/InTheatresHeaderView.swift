//
//  InTheatresHeaderView.swift
//  Movie App
//
//  Created by user on 29.10.2022.
//

import UIKit

class InTheatresHeaderView: UICollectionReusableView {
    
    //MARK: Properities
    
    static let headerIdentifier = "InTheatresHeaderView"
    
    lazy var theatresLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Now in theatres"
        label.font = UIFont.systemFont(ofSize: 25,weight: .semibold)
        return label
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        addSubview(theatresLabel)
        
        setUpConstrains()
    }
    
    func setUpConstrains() {
        NSLayoutConstraint.activate([
            theatresLabel.topAnchor.constraint(equalTo: topAnchor),
            theatresLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


