//
//  UserPageViewController.swift
//  BestRamen
//
//  Created by Sakurako Shimbori on 2020/09/08.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit

class UserPageViewController: UIViewController {
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupVerticalChildren()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var scrollView: UIScrollView!
    
    private func setupVerticalChildren() {
        // CollectionViewController
        let collectionViewController = CollectionViewController()
        addChild(collectionViewController)
        verticalStackView.addArrangedSubview(collectionViewController.view)
        collectionViewController.didMove(toParent: self)

        // TableViewController
        let tableViewController = TableViewController()
        addChild(tableViewController)
        verticalStackView.addArrangedSubview(tableViewController.view)
        tableViewController.didMove(toParent: self)
    }

    
}
