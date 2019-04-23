//
//  AutoViewController.swift
//  ShowJetTest
//
//  Created by Anton Trofimenko on 21/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

class AutoViewController: UIViewController, ViewCellDelegate {
    var cells = [ViewCell]()
    var animationCell: ViewCell?
    var deltaTick: CGFloat = 0.0
    var currentHeight: CGFloat = 0.0
    var ticksCount = 0
    
    func itemClicked(tag: Int) {
        for cell in cells {
            if cell.tag == tag {
                cellSelected(cell: cell)
            }
        }
    }
    
    func cellSelected(cell: ViewCell) {
        print(self.view.frame.height, cell.frame.height)
        deltaTick = (self.view.frame.height - cell.frame.height) / 30
        animationCell = cell
        currentHeight = cell.frame.height
        let displayLink = CADisplayLink(target: self, selector: #selector(animationDidUpdate))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: RunLoop.main, forMode: .default)
        UIView.animate(withDuration: 0.5, delay: 0.01, options: [.curveLinear], animations: {
            self.animationCell?.frame.size.height = self.view.frame.height
        }, completion: { (_) in
            displayLink.invalidate()
        })

    }
    
    @objc func animationDidUpdate(displayLing: CADisplayLink) {
//        print("updated", self.animationCell?.frame.size.height)
        if ticksCount == 0 {
            ticksCount += 1
            return
        }
        if ticksCount > 30 {
            return
        }
        ticksCount += 1
        currentHeight += deltaTick
//        self.animationCell?.animate(to: currentHeight)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cell = ViewCell(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 2/3))
        cell.tag = 1
        cell.contentMode = .redraw
        cell.autoresizingMask = .flexibleHeight
        cell.delegate = self
        view.addSubview(cell)
        cells.append(cell)
    }
    

}
