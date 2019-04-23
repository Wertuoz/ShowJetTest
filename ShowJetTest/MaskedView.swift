//
//  MaskedView.swift
//  ShowJetTest
//
//  Created by Anton Trofimenko on 18/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

class MaskedView: UIView {
    let angle: CGFloat = 6.0
    var sizeClosed: CGRect {
        get {
            return CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height * 2/3)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.red.cgColor
        let startShape = calculatePath(closed: true)
        let endShape = calculatePath(closed: false)
        shapeLayer.path = startShape
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = endShape
        animation.duration = 5
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: animation.keyPath)
        self.backgroundColor = UIColor.blue
        self.layer.mask = shapeLayer
    }
    
    func calculatePath(closed: Bool = false) -> CGPath {
        let path = UIBezierPath()
        let radians = angle * CGFloat.pi / 180
        var calculatedHeight: CGFloat = 0.0
        if closed {
            calculatedHeight = sizeClosed.height
        } else {
            calculatedHeight = frame.height
        }
        
        let delta = frame.width * sin(radians) / cos(radians)
        print(sin(radians), delta)
        
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 0, y: calculatedHeight - delta)
        let point3 = CGPoint(x: frame.width, y: calculatedHeight)
        let point4 = CGPoint(x: frame.width, y: delta)
        
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        path.close()
        
        return path.cgPath
    }
}
