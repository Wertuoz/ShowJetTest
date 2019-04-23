//
//  ViewControllerTemp.swift
//  ShowJetTest
//
//  Created by Anton Trofimenko on 19/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

class ViewControllerTemp: UIViewController, ViewCellDelegate {
    
    let itemsData = [1, 2, 3, 4, 5, 6]
    var items = [ViewCell]()
    var heightConstraints = [ViewCell : NSLayoutConstraint]()
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let screensize: CGRect = UIScreen.main.bounds
//        let screenWidth = screensize.width
//        let screenHeight = screensize.height
//        var scrollView: UIScrollView!
//        scrollView = UIScrollView(frame: CGRect(x: 0, y: 120, width: screenWidth, height: screenHeight))
//
//        scrollView.addSubview(labelTwo)
//
//        NSLayoutConstraint(item: labelTwo, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: labelTwo, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
//        NSLayoutConstraint(item: labelTwo, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: labelTwo, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
//
//        labelTwo.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        labelTwo.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        labelTwo.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        labelTwo.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        labelTwo.heightAnchor.constraint(equalToConstant: 200).isActive = true
//
//        scrollView.contentSize = CGSize(width: screenWidth, height: 2000)
//        view.addSubview(scrollView)
//
//    }

//    @IBOutlet weak var contentView: UIView!
    lazy var scrollView: UIScrollView = {
       let sv = UIScrollView(frame: view.frame)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        sv.contentSize.height = 5000
        sv.backgroundColor = UIColor.brown
        return sv
    }()
//
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        setupScrollView()

        // Do any additional setup after loading the view.
    }
    
    func setupScrollView() {
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//
//        let viewToAdd = UIView(frame: view.frame)
//        scrollView.addSubview(viewToAdd)
//
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        

        createItems()

        
    }
    
    func createItems() {
        var index = -1
        for _ in itemsData {
            index += 1
            let itemView = ViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 2/3))
//            let itemView = UIView(frame: view.frame)
            itemView.tag = index
            itemView.backgroundColor = .red
            scrollView.addSubview(itemView)
            if index == 0 {
                NSLayoutConstraint(item: itemView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0).isActive = true
            } else {
                NSLayoutConstraint(item: itemView, attribute: .top, relatedBy: .equal, toItem: items[index - 1], attribute: .bottom, multiplier: 1, constant: -35).isActive = true
            }
            NSLayoutConstraint(item: itemView, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: itemView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: itemView.frame.width).isActive = true
            let heightConstraint = NSLayoutConstraint(item: itemView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: itemView.frame.height)
            heightConstraint.isActive = true

            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.delegate = self
            heightConstraints[itemView] = heightConstraint
            

//            if index == 0 {
//                itemView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//            } else {
//                itemView.topAnchor.constraint(equalTo: items[index - 1].bottomAnchor).isActive = true
//            }
//            itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//            itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//            itemView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
//            itemView.heightAnchor.constraint(equalToConstant: itemView.frame.height).isActive = true
//            if index == items.count - 1 {
//                itemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//            }
            items.append(itemView)
        }
        let lastItem = items[items.count - 1]
        print(lastItem.bounds.maxY)
        scrollView.contentSize = CGSize(width: 200, height: 4000)
//        scrollView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight]
    }

    func itemClicked(tag: Int) {
        guard let cell = getItemByTag(tag: tag) else {
            return
        }
        
//        cell.heightAnchor.constraint(equalToConstant: 500)
        guard var heightView = heightConstraints[cell] else {
            return
        }
        heightView.constant = view.frame.height
//        cell.animate(to: view.frame.height)
        UIView.animate(withDuration: 0.6) {
            self.scrollView.layoutIfNeeded()
//            cell.setNeedsDisplay()
        }
        
    }

    func getItemByTag(tag: Int) -> ViewCell? {
        for item in items {
            if item.tag == tag {
                return item
            }
        }
        return nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
