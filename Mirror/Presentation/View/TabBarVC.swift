//
//  TabBarVC.swift
//  Mirror
//
//  Created by 경유진 on 2/25/24.
//

import UIKit
import SnapKit

class TabBarVC: UITabBarController {
    
    let HEIGHT_TAB_BAR: CGFloat = 100
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tabBar.backgroundColor = UIColor.mainYellow
        tabBar.itemPositioning = .centered
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = .black
        tabBar.tintColor = .white
        
        
        let homeVC = HomeVC()
        let homeTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "homeIcon"), tag: 0)
        homeVC.tabBarItem = homeTabBarItem
        homeVC.tabBarItem.badgeColor = UIColor.mainBlue
        
        let findObjectVC = UINavigationController(rootViewController: FindObjectVC())
        let findObjectTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "eyeIcon"), tag: 1)
        findObjectVC.tabBarItem = findObjectTabBarItem
        
        let describingVC = UINavigationController(rootViewController: DescribingVC())
        let describingTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "imageIcon"), tag: 2)
        describingVC.tabBarItem = describingTabBarItem
        
        let textReadingVC = UINavigationController(rootViewController: TextReadingVC())
        let textReadingTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "documentIcon"), tag: 3)
        textReadingVC.tabBarItem = textReadingTabBarItem
        
        self.viewControllers = [homeVC, findObjectVC, describingVC, textReadingVC]
    
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            var tabFrame = self.tabBar.frame
            tabFrame.size.height = HEIGHT_TAB_BAR
            tabFrame.origin.y = self.view.frame.size.height - HEIGHT_TAB_BAR
            self.tabBar.frame = tabFrame
        }
}
