//
//  StackViewController.swift
//  ShowJetTest
//
//  Created by Anton Trofimenko on 22/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

class ObliqueViewController: UIViewController, ObliqueViewDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let angle: CGFloat = 6.0
    private let animationDuration: CGFloat = 0.4
    private let framesCount: CGFloat = 60.0
    private var items = [ObliqueView]()
    private var itemsData = ["1", "2", "3", "4", "5", "6", "8", "9"]

    private var isAnimationInProgress = false
    private var animationCell: ObliqueView?
    private var deltaTick: CGFloat = 0.0
    private var currentHeight: CGFloat = 0.0
    private var ticksCount: CGFloat = 0.0
    private var heightConstraints = [ObliqueView : NSLayoutConstraint]()
    private var timer: Timer?
    
    private var animationLoops: CGFloat {
        get {
            return animationDuration * framesCount
        }
    }
    
    private var fullSize: CGRect {
        get {
            return self.view.frame
        }
    }
    
    private var smallSize: CGRect {
        get {
            let maxSize = fullSize
            return CGRect(x: 0, y: 0, width: maxSize.width, height: maxSize.height * 2/3)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for item in stackView.arrangedSubviews {
            item.removeFromSuperview()
        }
        stackView.layoutIfNeeded()
        let delta = ObliqueView.getDelta(frame: fullSize, angle: angle)
        stackView.spacing = -(delta - 2)
        scrollView.showsVerticalScrollIndicator = false
        createItems()
    }
    
    private func createItems() {
        var index = -1
        for item in itemsData {
            index += 1
            let itemView = ObliqueView(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: smallSize.height), angle: angle, imageName: item, maxRect: fullSize)
            itemView.tag = index
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
        if isAnimationInProgress {
            return
        }
        for cell in items {
            if cell.tag == tag {
                cellSelected(cell: cell)
            }
        }
    }
    
    private func cellSelected(cell: ObliqueView) {
        isAnimationInProgress = true
        if cell.isOpened == false {
            deltaTick = (fullSize.height - smallSize.height) / animationLoops
            animationCell = cell
            currentHeight = smallSize.height
        } else {
            deltaTick = (smallSize.height - fullSize.height) / animationLoops
            animationCell = cell
            currentHeight = fullSize.height
        }
        let offset = calcOffset(cell: cell)

        if items.firstIndex(of: cell) == items.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int((animationDuration + 0.1) * 1000))) {
                self.animateScroll(to: self.calcOffset(cell: cell))
            }
        } else {
            animateScroll(to: offset)
        }

        startTimer()
    }
    
    private func animateScroll(to offset: CGFloat) {
        UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0, options: .curveLinear, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0, y: offset)
        }, completion: nil)
    }
    
    private func calcOffset(cell: ObliqueView) -> CGFloat {
        var offset: CGFloat = 0
        let index = items.firstIndex(of: cell)!
        let lastItemIndex = items.count - 1
        switch index {
        case 0:
            offset = cell.frame.minY
        case lastItemIndex:
            offset = scrollView.contentSize.height - fullSize.height
        default:
            offset = !cell.isOpened ? cell.frame.minY : cell.frame.minY - (fullSize.height - smallSize.height) / 2
        }
        return offset
    }
    
    private func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(1/framesCount), target: self, selector: #selector(animationDidUpdate), userInfo: nil, repeats: true)
        }
    }
    
    private func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            animationCell!.isOpened = !animationCell!.isOpened
            animationCell = nil
            timer = nil
            deltaTick = 0.0
            currentHeight = 0.0
            ticksCount = 0
            isAnimationInProgress = false
        }
    }
    
    @objc private func animationDidUpdate() {
        if ticksCount == 0 {
            ticksCount += 1
            return
        }
        if ticksCount > animationLoops {
            /** animation to remove coreners, want to do this later
                and need to add easing function to calc deltatick
                animationCell?.resizeComplete()
             */
            stopTimer()
            return
        }
        ticksCount += 1

        currentHeight += deltaTick
        let heightnConstraint = self.heightConstraints[self.animationCell!]
        heightnConstraint?.constant = self.currentHeight
        stackView.layoutIfNeeded()
        animationCell?.updateConstraints()
    }
}
