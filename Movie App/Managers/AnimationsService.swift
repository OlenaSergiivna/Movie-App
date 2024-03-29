//
//  AnimationsService.swift
//  Movie App
//
//  Created by user on 23.10.2022.
//

import UIKit
import Lottie

struct AnimationService {
    
    static let shared = AnimationService()
    
    private init() {}
    
    func addAnimation(view: UIView) {
        let animation = LottieAnimationView(name: "movie")
        animation.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.5, height: view.frame.width * 0.5)
        animation.center = CGPoint(x: view.frame.midX + view.frame.midX / 6, y: view.frame.midY - 300)
        animation.loopMode = .repeat(1)
        view.addSubview(animation)
        
        animation.play()
    }
}
