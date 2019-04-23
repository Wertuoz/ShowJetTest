//
//  StackViewController.swift
//  ShowJetTest
//
//  Created by Anton Trofimenko on 22/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

class StackViewController: UIViewController, ViewCellDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let angle: CGFloat = 6.0
    var items = [ViewCell]()
    var itemsData = ["1", "2", "3", "4", "5", "6", "8", "9"]

    var animationCell: ViewCell?
    var deltaTick: CGFloat = 0.0
    var currentHeight: CGFloat = 0.0
    var ticksCount = 0
    var heightConstraints = [ViewCell : NSLayoutConstraint]()
    var timingFunc: AnimationLayer?
    
    var fullSize: CGRect {
        get {
            return self.view.frame
        }
    }
    
    var smallSize: CGRect {
        get {
            let maxSize = fullSize
            return CGRect(x: 0, y: 0, width: maxSize.width, height: maxSize.height * 2/3)
        }
    }
    
    let itemsColors = [UIColor.red,UIColor.green,UIColor.blue,UIColor.white,UIColor.black,UIColor.brown,UIColor.yellow,UIColor.cyan,UIColor.darkGray]
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for item in stackView.arrangedSubviews {
            item.removeFromSuperview()
        }
        stackView.layoutIfNeeded()
        let delta = ViewCell.getDelta(frame: view.frame, angle: 6.0)
        stackView.spacing = -(delta - 2)
        createItems()
    }
    
    func createItems() {
        var index = -1
        for item in itemsData {
            index += 1
            let itemView = ViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 2/3), angle: 6.0, imageName: item)
            itemView.tag = index
            itemView.backgroundColor = itemsColors[index]
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.delegate = self

            itemView.widthAnchor.constraint(equalToConstant: itemView.frame.width).isActive = true
            let heightConstraint = itemView.heightAnchor.constraint(equalToConstant: itemView.frame.height)
            heightConstraint.isActive = true
            heightConstraints[itemView] = heightConstraint

            items.append(itemView)
            stackView.addArrangedSubview(itemView)
        }
    }
    
    func itemClicked(tag: Int) {
        for cell in items {
            if cell.tag == tag {
                cellSelected(cell: cell)
            }
        }
    }
    
    func cellSelected(cell: ViewCell) {
        if cell.isOpened == false {
            deltaTick = (self.view.frame.height - cell.frame.height) / 60
            animationCell = cell
            currentHeight = cell.frame.height
        } else {
            deltaTick = (self.view.frame.height * 2/3 - cell.frame.height) / 60
            animationCell = cell
            currentHeight = self.view.frame.height
        }
        let result = cell.frame.minY.truncatingRemainder(dividingBy: self.view.frame.height)
        let calcOffset = !cell.isOpened ? cell.frame.minY : cell.frame.minY - (self.view.frame.height - self.view.frame.height * 2/3) / 2
        print(result)
        print(calcOffset)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0, y: calcOffset)
        }, completion: nil)


//        timingFunc = AnimationLayer()
//        self.view.layer.addSublayer(timingFunc!)
//        timingFunc?.calc(from: cell.frame.height, to: self.view.frame.height)

        startTimer()
        print("1", currentHeight)
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1/120, target: self, selector: #selector(animationDidUpdate), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            animationCell!.isOpened = !animationCell!.isOpened
            animationCell = nil
            timer = nil
            deltaTick = 0.0
            currentHeight = 0.0
            ticksCount = 0
        }
    }
    
    @objc func animationDidUpdate() {
        if ticksCount == 0 {
            ticksCount += 1
            return
        }
        if ticksCount > 60 {
            stopTimer()
            return
        }
        ticksCount += 1

        currentHeight += deltaTick
        var heightnConstraint = self.heightConstraints[self.animationCell!]
        heightnConstraint?.constant = self.currentHeight
        print("curheigh", self.currentHeight)
        stackView.layoutIfNeeded()
        animationCell?.updateConstraints()
    }
}
