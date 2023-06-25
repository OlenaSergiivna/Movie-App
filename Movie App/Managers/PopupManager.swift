//
//  PopupManager.swift
//  Movie App
//
//  Created by user on 25.06.2023.
//

import Foundation
import SwiftEntryKit


struct PopupManager {
    
    static let shared = PopupManager()
    
    enum FavoritesAction {
        case add
        case remove
    }
    
    func showPopup(forAction action: FavoritesAction, mediaType: String) {
        
        let customView: UILabel = {
            let castLabel = UILabel()
            castLabel.translatesAutoresizingMaskIntoConstraints = false
            
            switch action {
            case .add:
                castLabel.text = "You added \(mediaType) to favorites ❤️"
            case .remove:
                castLabel.text = "You removed \(mediaType) from favorites 💔"
            }
            
            castLabel.textColor = .white
            castLabel.textAlignment = .center
            castLabel.contentMode = .center
            castLabel.font = .systemFont(ofSize: 14)
            castLabel.adjustsFontSizeToFitWidth = true
            castLabel.isHidden = false
            return castLabel
        }()
        
        
        var attributes = EKAttributes()
        attributes.positionConstraints.verticalOffset = 20
        attributes.hapticFeedbackType = .success
        
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.95)
        attributes.positionConstraints.size = .init(width: widthConstraint, height: .constant(value: 40))
        attributes.entryBackground = .visualEffect(style: .dark)
        attributes.roundCorners = .all(radius: 10)
        
        SwiftEntryKit.display(entry: customView, using: attributes)
    }
}

