//
//  AnimationLayer.swift
//  ShowJetTest
//
//  Created by Anton Trofimenko on 22/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

class AnimationLayer: CALayer {
    
    func calc(from: CGFloat, to: CGFloat) {
        print("from: \(from), to: \(to)")
        position.x = from
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.toValue = from
        animation.toValue = to
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false
        add(animation, forKey: animation.keyPath)
    }

}
