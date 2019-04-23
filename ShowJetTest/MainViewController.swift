//
//  MainViewController.swift
//  ShowJetTest
//
//  Created by Anton Trofimenko on 19/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
//    var mainView: ScrollableContentView { return self.view as! ScrollableContentView }

    lazy var scrollableView: ScrollableStackView = {
        let view = ScrollableStackView(frame: self.view.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollableView)
        setupView()
    }
    
    func setupView() {
        scrollableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollableView.layoutIfNeeded()
        scrollableView.setupView()
    }
    
    /**
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 */
//    override func loadView() {
//        self.view = ScrollableContentView(frame: UIScreen.main.bounds)
//        self.view.translatesAutoresizingMaskIntoConstraints = false
//    }
}
