//
//  TVHeader.swift
//  Movie App
//
//  Created by user on 29.10.2022.
//
import UIKit

protocol TVHeaderViewDelegate: AnyObject {
    func openAllTVVC()
    func changeTVGenre(index: Int)
}

class TVHeaderView: UICollectionReusableView {
    
    //MARK: Properities
    
    static let headerIdentifier = "TVHeaderView"
    
    weak var delegate: TVHeaderViewDelegate?
    
    lazy var tvLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "TV Shows"
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

        [tvLabel, seeAllButton, segmentedControlScrollView].forEach( {addSubview($0)} )
        
        setUpConstrains()
    }
    
    func setUpConstrains() {
        NSLayoutConstraint.activate([
            tvLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            tvLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            seeAllButton.topAnchor.constraint(equalTo: tvLabel.topAnchor, constant: 0),
            
            segmentedControlScrollView.topAnchor.constraint(equalTo: tvLabel.bottomAnchor, constant: 8),
            segmentedControlScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            segmentedControlScrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            segmentedControlScrollView.heightAnchor.constraint(equalToConstant: 40),
            
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
       delegate?.openAllTVVC()
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let segmentIndex = segmentedControl.selectedSegmentIndex
        delegate?.changeTVGenre(index: segmentIndex)
    }
    
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
