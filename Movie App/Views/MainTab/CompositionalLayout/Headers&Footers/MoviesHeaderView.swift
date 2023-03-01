//
//  MoviesHeaderView.swift
//  Movie App
//
//  Created by user on 27.10.2022.
//

import UIKit

protocol MoviesHeaderViewDelegate: AnyObject {
    func openAllMoviesVC()
    func changeMovieGenre(index: Int)
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
        button.setTitleColor(UIColor.systemPink, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.addTarget(self, action: #selector(seeAllButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    // Container view of the segmented control
    lazy var segmentedControlScrollView: UIScrollView = {
        let segmentedControlScrollView = UIScrollView()
        segmentedControlScrollView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlScrollView.contentSize = CGSize(width: segmentedControlScrollView.bounds.size.width, height: 40)
        segmentedControlScrollView.backgroundColor = .clear
        segmentedControlScrollView.showsHorizontalScrollIndicator = false
        return segmentedControlScrollView
    }()
    
    
    // Customised segmented control
    lazy var segmentedControl: NoSwipeSegmentedControl = {
        let segmentedControl = NoSwipeSegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        segmentedControl.selectedSegmentTintColor = .systemPink
       
        segmentedControl.insertSegment(withTitle: "", at: 0, animated: true)
        
        // Change text color and the font of the NOT selected (normal) segment
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)], for: .normal)

        // Change text color and the font of the selected segment
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)], for: .selected)
        
        // Set up event handler to get notified when the selected segment changes
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        return segmentedControl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        segmentedControlScrollView.addSubview(segmentedControl)

        [movieLabel, seeAllButton, segmentedControlScrollView].forEach( {addSubview($0)} )
        
        setUpConstrains()
    }
    
    func setUpConstrains() {
        NSLayoutConstraint.activate([
            movieLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            movieLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            seeAllButton.topAnchor.constraint(equalTo: movieLabel.topAnchor, constant: 0),
            
            segmentedControlScrollView.topAnchor.constraint(equalTo: movieLabel.bottomAnchor, constant: 8),
            segmentedControlScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            segmentedControlScrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            segmentedControlScrollView.heightAnchor.constraint(equalToConstant: 30),
            
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlScrollView.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlScrollView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: segmentedControlScrollView.trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: segmentedControlScrollView.bottomAnchor, constant: 0),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   @objc func seeAllButtonPressed() {
       delegate?.openAllMoviesVC()
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let segmentIndex = segmentedControl.selectedSegmentIndex
        delegate?.changeMovieGenre(index: segmentIndex)
    }
    
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

class NoSwipeSegmentedControl: UISegmentedControl {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
