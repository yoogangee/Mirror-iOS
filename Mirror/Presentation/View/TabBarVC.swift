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
        
        delegate = self
                
        let swipeRight = UISwipeGestureRecognizer(target:self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
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
    
    func checkTutorialRun() {
        let userDefault = UserDefaults.standard
        if userDefault.bool(forKey: "Onboarding") == false {
            let onboardingVC = OnboardingVC(transitionStyle: .scroll, navigationOrientation: .horizontal)
            onboardingVC.modalPresentationStyle = .fullScreen
            present(onboardingVC, animated: false)
        }
    }
    
    // 재스쳐
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if(self.selectedIndex) < 3 { // 슬라이드할 탭바 갯수 지정 (전체 탭바 갯수 - 1)
                animateToTab(toIndex: self.selectedIndex+1)
            }
        } else if gesture.direction == .right {
            if (self.selectedIndex) > 0 {
                animateToTab(toIndex: self.selectedIndex-1)
            }
        }
    }
}

extension TabBarVC: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let tabViewControllers = tabBarController.viewControllers, let toIndex = tabViewControllers.firstIndex(of: viewController) else {
            return false
        }
        animateToTab(toIndex: toIndex)
        return true
    }
    
    func animateToTab(toIndex: Int) {
        guard let tabViewControllers = viewControllers,
              let selectedVC = selectedViewController else { return }
        
        guard let fromView = selectedVC.view,
              let toView = tabViewControllers[toIndex].view,
              let fromIndex = tabViewControllers.firstIndex(of: selectedVC),
              fromIndex != toIndex else { return }
        
        fromView.superview?.addSubview(toView)
        
        let screenWidth = UIScreen.main.bounds.size.width
        let scrollRight = toIndex > fromIndex
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)
        // Disable interaction during animation
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
            fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y)
            toView.center = CGPoint(x: toView.center.x - offset, y: toView.center.y)
        }, completion: { finished in
            // Remove the old view from the tabbar view.
            fromView.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }
}
