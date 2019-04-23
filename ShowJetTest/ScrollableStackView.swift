//
//  ScrollableContentView.swift
//  ShowJetTest
//
//  Created by Anton Trofimenko on 19/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

class ScrollableStackView: UIView, ViewCellDelegate {
    
    //    lazy var scrollView: UIScrollView = {
    //        let sv = UIScrollView(frame: self.frame)
    //        sv.backgroundColor = UIColor.brown
    //        sv.showsVerticalScrollIndicator = false
    //        return sv
    //    }()
    
    lazy var scrollView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 0
//        sv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return sv
    }()
    
    let angle: CGFloat = 6.0
    var items = [ViewCell]()
    var itemsData = ["1", "2", "3", "4", "5", "6", "8", "9"]
    var itemsColors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.brown, UIColor.white, UIColor.black, UIColor.brown, UIColor.white, UIColor.black]
    var heightConstraints = [ViewCell : NSLayoutConstraint]()
    
    var animationCell: ViewCell?
    var deltaTick: CGFloat = 0.0
    var currentHeight: CGFloat = 0.0
    var ticksCount = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        setupView()
    }
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        createItems()
    }
    
    func createItems() {
        var index = -1
        for item in itemsData {
            index += 1
            let itemView = ViewCell(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * 2/3), angle: 6.0, imageName: item)
            itemView.tag = index
            itemView.backgroundColor = itemsColors[index]
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            //            scrollView.addSubview(itemView)
            //            if index == 0 {
            //                NSLayoutConstraint(item: itemView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0).isActive = true
            //            } else {
            //                let delta = -ViewCell.getDelta(frame: itemView.frame, angle: 6.0) + 2
            //                print(delta)
            //                NSLayoutConstraint(item: itemView, attribute: .top, relatedBy: .equal, toItem: items[index - 1], attribute: .bottom, multiplier: 1, constant: delta).isActive = true
            //            }
            //            NSLayoutConstraint(item: itemView, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 0).isActive = true
            
            
//            NSLayoutConstraint(item: itemView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: itemView.frame.width).isActive = true
//            let heightConstraint = NSLayoutConstraint(item: itemView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: itemView.frame.height)
//            heightConstraint.isActive = true
            
            
            
            //            if index == 0 {
            //                itemView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            //            } else {
            //                itemView.topAnchor.constraint(equalTo: items[index - 1].bottomAnchor).isActive = true
            //            }
            //            itemView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
            //            itemView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true

//            scrollView.addArrangedSubview(itemView)
//            itemView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            itemView.widthAnchor.constraint(equalToConstant: itemView.frame.width).isActive = true
//            itemView.heightAnchor.constraint(equalToConstant: itemView.frame.height).isActive = true
            let heightConstraint = itemView.heightAnchor.constraint(equalToConstant: itemView.frame.height)
            heightConstraint.isActive = true
            itemView.delegate = self
            heightConstraints[itemView] = heightConstraint
            items.append(itemView)
            itemView.layoutIfNeeded()
            itemView.setNeedsUpdateConstraints()
        }
        scrollView.setNeedsLayout()
        self.setNeedsUpdateConstraints()
        self.layoutIfNeeded()
        
        
        updateContentSize()
        self.layoutIfNeeded()
        self.updateContentSize()
        self.setNeedsUpdateConstraints()
    }
    
    func updateContentSize() {
        for item in items {
            print(item.bounds, item.frame)
        }
        let lastItem = items[items.count - 1]
        print(lastItem.bounds.maxY)
        print(lastItem.frame.maxY)
        //        scrollView.contentSize = CGSize(width: self.frame.width, height: lastItem.frame.maxY)
        //        scrollView.contentSize = CGSize(width: self.frame.width, height: lastItem.frame.maxY)
    }
    
    func itemClicked(tag: Int) {
        for cell in items {
            if cell.tag == tag {
                cellSelected(cell: cell)
            }
        }
    }
    
    func cellSelected(cell: ViewCell) {
        deltaTick = (self.frame.height - cell.frame.height) / 30
        animationCell = cell
        currentHeight = cell.frame.height
        let displayLink = CADisplayLink(target: self, selector: #selector(animationDidUpdate))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: RunLoop.main, forMode: .default)
        UIView.animate(withDuration: 0.5, delay: 0.01, options: [.layoutSubviews], animations: {
            var heightnConstraint = self.heightConstraints[self.animationCell!]
            heightnConstraint?.constant = self.frame.height
            self.animationCell?.frame.size.height = self.frame.height
            
            self.scrollView.layoutIfNeeded()
        }, completion: { (_) in
            displayLink.invalidate()
            self.scrollView.layoutIfNeeded()
            self.animationCell?.layoutIfNeeded()
            self.updateContentSize()
        })
    }
    
    @objc func animationDidUpdate(displayLing: CADisplayLink) {
        if ticksCount == 0 {
            ticksCount += 1
            return
        }
        if ticksCount > 30 {
            //            animationCell?.resizeComplete()
            return
        }
        ticksCount += 1
        currentHeight += deltaTick
        var heightnConstraint = self.heightConstraints[self.animationCell!]
        heightnConstraint?.constant = currentHeight
        print("currentHeight", currentHeight)
        scrollView.layoutIfNeeded()
        animationCell?.layoutIfNeeded()
//        self.animationCell?.animate(to: currentHeight)
    }
}
