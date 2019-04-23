//
//  ViewCell.swift
//  ShowJetTest
//
//  Created by Anton Trofimenko on 18/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

protocol ObliqueViewDelegate: class {
    func itemClicked(tag: Int)
}

class ObliqueView: UIView {
    
    weak var delegate: ObliqueViewDelegate?
    var isOpened = false
    var currentheight: CGFloat = 0.0
    
    private var shapeLayer = CAShapeLayer()
    private var angle: CGFloat = 0.0
    private var imageName = ""
    private var maxHeight: CGFloat = 0.0
    private var maxWidth: CGFloat = 0.0
    
    private lazy var imageLayer: CALayer = {
        var tempLayer = CALayer()
        tempLayer.frame = CGRect(x: 0, y: 0, width: maxWidth, height: maxHeight)
        let image = UIImage(named: imageName)!
        let ratio = maxHeight / image.size.height
        let resizedImage = image.resizeImage(targetSize: CGSize(width: image.size.width * ratio, height: image.size.height * ratio))
        tempLayer.contents = resizedImage.cgImage
        tempLayer.contentsGravity = CALayerContentsGravity.center
        return tempLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect, angle: CGFloat, imageName: String, maxRect: CGRect) {
        self.init(frame: frame)
        self.imageName = imageName
        self.angle = angle
        self.maxWidth = maxRect.size.width
        self.maxHeight = maxRect.size.height
        self.currentheight = frame.height

        let startShape = calculatePath(closed: false)
        shapeLayer.path = startShape
        
        self.backgroundColor = UIColor.blue
        self.layer.mask = shapeLayer
        self.layer.addSublayer(imageLayer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        animate()
    }
    
    private func animate() {
        currentheight = frame.height
        shapeLayer.path = calculatePath(closed: false)
        shapeLayer.frame.size = CGSize(width: frame.width, height: currentheight)
    }
    
    @objc private func imageTapped() {
        delegate?.itemClicked(tag: tag)
    }

    private func calculatePath(closed: Bool = false) -> CGPath {
        let path = UIBezierPath()
        let calculatedHeight = currentheight
        let delta = ObliqueView.getDelta(frame: self.frame, angle: angle)
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
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
