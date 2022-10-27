//
//  MoviesHeaderView.swift
//  Movie App
//
//  Created by user on 27.10.2022.
//

import UIKit

protocol MoviesHeaderViewDelegate: AnyObject {
    func openAllMoviesVC()
}

class MoviesHeaderView: UICollectionReusableView {
    
    //MARK: Properities
    
    static let headerIdentifier = "MoviesHeaderView"
    
    weak var delegate: MoviesHeaderViewDelegate?
    
    lazy var movieLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Movies"
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return label
    }()
    
    lazy var seeAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See all", for: .normal)
        //button.setTitleColor(.label.withAlphaComponent(0.8), for: .normal)
        button.setTitleColor(UIColor.systemPink, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.addTarget(self, action: #selector(seaAllButtonPressed), for: .touchUpInside)
        return button
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        [movieLabel, seeAllButton].forEach( {addSubview($0)} )
        
        setUpConstrains()
    }
    
    func setUpConstrains() {
        NSLayoutConstraint.activate([
            movieLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            movieLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            seeAllButton.topAnchor.constraint(equalTo: movieLabel.topAnchor, constant: 0)
        ])
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   @objc func seaAllButtonPressed() {
       delegate?.openAllMoviesVC()
    }
    
}


