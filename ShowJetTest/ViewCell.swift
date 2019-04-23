//
//  ViewCell.swift
//  ShowJetTest
//
//  Created by Anton Trofimenko on 18/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit


protocol ViewCellDelegate: class {
    func itemClicked(tag: Int)
}

class ViewCell: UICollectionViewCell {
    
    weak var delegate: ViewCellDelegate?
    var shapeLayer = CAShapeLayer()
    var angle: CGFloat = 0.0
    var imageName = ""
    var isOpened = false
    
    lazy var imageLayer: CALayer = {
        var tempLayer = CALayer()
        tempLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height + frame.height * 1/3)//self.frame
        tempLayer.contents = UIImage(named: imageName)?.cgImage
        tempLayer.contentsGravity = CALayerContentsGravity.center
        return tempLayer
    }()
    
    var currentheight: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        print("updateConstraints", self.frame.height)
        animate()
    }
    
    convenience init(frame: CGRect, angle: CGFloat, imageName: String) {
        self.init(frame: frame)
        self.imageName = imageName
        self.angle = angle
        currentheight = frame.height
    
//        shapeLayer.fillColor = UIColor.red.cgColor
        let startShape = calculatePath(closed: false)
        shapeLayer.path = startShape
        
        self.backgroundColor = UIColor.blue
        self.layer.mask = shapeLayer
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
        self.layer.addSublayer(imageLayer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    func animate(/**to size: CGFloat*/) {
//        currentheight = size
        currentheight = frame.height
//        print("animate to", size)
        shapeLayer.path = calculatePath(closed: false)
//        self.layer.frame = CGRect(x: 0, y: 0, width: frame.width, height: currentheight)
//        shapeLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: currentheight)
//        imageLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: currentheight)
    }
    
    @objc func imageTapped() {
        print("tapped \(tag)")
        delegate?.itemClicked(tag: tag)
    }
    
    func resizeComplete() {
        angle = 0
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = calculatePath(closed: false)//endShape
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: animation.keyPath)
    }
    
    func calculatePath(closed: Bool = false) -> CGPath {
        let path = UIBezierPath()
        
        var calculatedHeight: CGFloat = 0.0
        if closed {
            calculatedHeight = currentheight//sizeClosed.height
        } else {
            calculatedHeight = currentheight//frame.height
        }

        let delta = ViewCell.getDelta(frame: self.frame, angle: angle)
        print(delta)
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
    
    static func getDelta(frame: CGRect, angle: CGFloat) -> CGFloat {
        let radians = angle * CGFloat.pi / 180
        return frame.width * sin(radians) / cos(radians)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return calculatePath(closed: false).contains(point)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
