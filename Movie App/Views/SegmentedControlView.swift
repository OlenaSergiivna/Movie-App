//
//  Protocols.swift
//  Movie App
//
//  Created by user on 22.10.2022.
//

import UIKit

protocol SegmentedControlViewDelegate: AnyObject {
    func segmentedControl(didChange index: Int)
}

struct SegmentedControlConfiguration {
    
    let titles: [String]
    let font: UIFont
    let spacing: CGFloat
    let selectedLabelColor: UIColor
    let unselectedLabelColor: UIColor
    let selectedLineColor: UIColor
    
}

class SegmentedControlView: UIView {

    private var vStacks: [UIStackView] = []
    private var lineViews: [UIView] = []
    private var titleLables: [UILabel] = []
    private var selectedIndex: Int = 0
    private var config: SegmentedControlConfiguration!
    
    weak var delegate: SegmentedControlViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: .zero, height: 50)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private func configure() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    /// Configuration
    func configure(_ config: SegmentedControlConfiguration) {
        self.config = config
        let hStack = createHStack(config.spacing)
        layoutMainStackView(hStack)
        layoutElements(config, hStack)
        lineViews[selectedIndex].backgroundColor = config.selectedLineColor
        titleLables[selectedIndex].textColor = config.selectedLabelColor
    }
    
    /// Create main horizontal stack
    private func createHStack(_ spacing: CGFloat) -> UIStackView {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = spacing
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }
    
    /// Create vertical stack for iteration
    private func createVStack() -> UIStackView {
        let sv = UIStackView()
        sv.spacing = 0
        sv.axis = .vertical
        sv.distribution = .fill
        sv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectionHandler))
        sv.addGestureRecognizer(tap)
        return sv
    }
    
    /// Create label  for iteration
    private func createLabel(_ title: String, _ font: UIFont, _ unselectedColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = font
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = unselectedColor
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    /// Create line view for iteration
    private func createLineView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        return view
    }
    
    /// Layout our main horizontal stack
    private func layoutMainStackView(_ stackView: UIStackView) {
        /// Add main horizontal stack to scroll view
        /// This stack view will shrink in size by content
        /// Which will shrink content of scroll view in width
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    /// Layout our elements in main horizontal stack
    private func layoutElements(_ config: SegmentedControlConfiguration, _ stackView: UIStackView) {
        config.titles.forEach { title in
            /// Create new vertical stack
            /// which will contain UILabel at the top and UIView(Line) at the bottom
            let vStack = createVStack()
            
            /// Create label
            let label = createLabel(title, config.font, config.unselectedLabelColor)
            
            /// Add vertical stack to our main horizontal stack
            stackView.addArrangedSubview(vStack)
            
            /// Create line view
            let lineView = createLineView()
            vStack.addArrangedSubview(label)
            vStack.addArrangedSubview(lineView)
            
            /// We need to store our elements to change their color
            /// when selected item will change
            lineViews.append(lineView)
            titleLables.append(label)
            vStacks.append(vStack)
        }
    }
    
    @objc private func selectionHandler(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? UIStackView else {
            return
        }
        /// new index of selected view
        if let index = vStacks.firstIndex(of: view) {
            /// We unselect our elements using selectedIndex
            lineViews[selectedIndex].backgroundColor = .clear
            titleLables[selectedIndex].textColor = config.unselectedLabelColor
            /// Then we change colors of our elements using index
            lineViews[index].backgroundColor = config.selectedLineColor
            titleLables[index].textColor = config.selectedLabelColor
            /// Update selectedIndex by new index
            selectedIndex = index
            /// Send to delegate new selectedIndex
            delegate?.segmentedControl(didChange: selectedIndex)
        }
    }

}
