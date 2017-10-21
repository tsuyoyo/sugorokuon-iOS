//
//  HomeTabBarController.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/21.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit

// Memo :
// Referred (http://hidef.jp/post-725/) to catch select event on tabBar
class HomeTabBarController: UITabBarController, UITabBarControllerDelegate {

    private var lastViewControllerIndex : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func tabBarController(_ tabBarController: UITabBarController,
                                 didSelect viewController: UIViewController) {
        
        if lastViewControllerIndex == tabBarController.selectedIndex {
            (viewController as? HomeTabBarDelegate)?.didTabSelected()
        } else {
            lastViewControllerIndex = tabBarController.selectedIndex
        }
    }
    
}
