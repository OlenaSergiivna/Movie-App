//
//  HeartButton.swift
//  Movie App
//
//  Created by user on 21.03.2023.
//

import UIKit

class HeartButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let heartShapePath = UIBezierPath()
        
        heartShapePath.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        heartShapePath.addCurve(to: CGPoint(x: rect.width*0.1, y: rect.height*0.3),
                                controlPoint1: CGPoint(x: rect.maxX*0.25, y: rect.maxY*0.75),
                                controlPoint2: CGPoint(x: rect.maxX*0.1, y: rect.maxY*0.6))
        heartShapePath.addArc(withCenter: CGPoint(x: rect.width*0.3, y: rect.height*0.3),
                              radius: rect.width/5,
                              startAngle: CGFloat.pi,
                              endAngle: 0,
                              clockwise: true)
        heartShapePath.addArc(withCenter: CGPoint(x: rect.width*7/10, y: rect.height*3/10),
                              radius: rect.width/5,
                              startAngle: CGFloat.pi,
                              endAngle: 0,
                              clockwise: true)
        heartShapePath.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                                controlPoint1: CGPoint(x: rect.maxX*0.9, y: rect.maxY*0.6),
                                controlPoint2: CGPoint(x: rect.maxX*0.75, y: rect.maxY*0.75))
        heartShapePath.close()
        
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = heartShapePath.cgPath
        layer.mask = maskLayer
        
        let scale: CGFloat = 0.8
        let newSize = CGSize(width: rect.width * scale, height: rect.height * scale)
        let scaledRect = CGRect(origin: rect.origin, size: newSize)
        layer.setAffineTransform(CGAffineTransform(scaleX: scale, y: scale))
    }
}
