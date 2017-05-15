//
//  MainTabBarViewController.swift
//  Together
//
//  Created by Андрей Цай on 04.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import SideMenu
import GoogleMapsBase
import SwiftyUserDefaults

protocol MainTabChild {
    weak var MainNavController: UINavigationController! {get set}
}

class ProfileSideMenuController: UISideMenuNavigationController {
}

enum Tabs: Int {
    case shake = 0
    case map = 1
    case home = 2
    case messages = 3
    case settings = 4
}

class MainTabBarViewController: UITabBarController {
    
    //MARK: properties
    
    weak var profileSideMenu: UISideMenuNavigationController!
    fileprivate var searchButton: UIButton!
    fileprivate var needsToShowSideMenu = false
    fileprivate let tabBarHeight: CGFloat = 51
    
    override var selectedIndex: Int {
        get {
            let index = Defaults[.mainTabIndex]
            super.selectedIndex = index
            return index
        }
        set {
            if newValue < 4{
                Defaults[.mainTabIndex] = newValue
                super.selectedIndex = newValue
            } else if !needsToShowSideMenu {
                needsToShowSideMenu = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makePretty()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.recieveShowOnMapNotification(_:)),
            name: NSNotification.Name(rawValue: TogetherNotificationTypes.showEventOnMap),
            object: nil
        )
        
        tabBar.tintColor = UIColor(red: 50/255, green: 175/255, blue: 255/255, alpha: 1.0)
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = UIColor(white: 208/255, alpha: 1.0)
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        super.selectedIndex = Defaults[.mainTabIndex]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSideMenu()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.locationDataProvider.askForInUseGeoPermissions()
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        let newY = self.view.frame.height - self.tabBarHeight
        let newFrame = CGRect(
            x: self.tabBar.frame.origin.x,
            y: newY,
            width: self.view.frame.width,
            height: self.tabBarHeight
        )
        self.tabBar.frame = newFrame
        super.viewWillLayoutSubviews()
        
    }
    
    func searchAction(){
        navigationController?.performSegue(withIdentifier: "SearchSettingsSegue", sender: self)
    }
    
    func switchToTab(_ index: Int){
        self.selectedIndex = index
    }
    
    fileprivate func makePretty(){
        for view in self.viewControllers! {
            if var v = view as? MainTabChild {
                v.MainNavController = self.navigationController!
            }
        }
        self.setupProfileSideMenu()
        self.setupSearchButton()
        self.delegate = self
        self.navigationController?.isNavigationBarHidden = false
    }
    
    fileprivate func setupProfileSideMenu () {
        self.profileSideMenu = storyboard?.instantiateViewController(withIdentifier: "ProfileSideMenuView") as! UISideMenuNavigationController
        SideMenuManager.menuRightNavigationController = self.profileSideMenu
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.view)
        if let navBar = self.navigationController?.navigationBar {
            SideMenuManager.menuAddPanGestureToPresent(toView: navBar)
        }
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuAnimationFadeStrength = 0.7
    }
    
    @objc func recieveShowOnMapNotification(_ notification: Notification){
        guard let paramDict = (notification as NSNotification).userInfo as? [String: AnyObject] else { return }
        guard let latitude = paramDict["latitude"] as? Double, let longitude = paramDict["longitude"] as? Double else { return }
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        guard let vcList = self.viewControllers, let mapView = vcList[Tabs.map.rawValue] as? MapViewController else { return }
        mapView.setCurrentPosition(location, zoom: 18)
        self.selectedIndex = Tabs.map.rawValue
    }

    fileprivate func setupSearchButton(){
        guard let navController = self.navigationController else { return }
        let searchView = SearchButtonView(frame: navController.navigationBar.frame)
        searchView.setupView(
            horizontalMargin: 20,
            verticalMargin:10)
        searchView.addTarget(self, action: #selector(MainTabBarViewController.searchAction))
        self.navigationItem.titleView = searchView
    }
    
    func showSideMenu(){
        if needsToShowSideMenu {
            needsToShowSideMenu = false
            present(profileSideMenu, animated: true, completion: nil)
        }
    }
    
}

extension MainTabBarViewController: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ProfileViewController {
            needsToShowSideMenu = true
            showSideMenu()
            return false
        } else {
            let viewControllerIndex = self.viewControllers?.index(of: viewController) ?? viewController.tabBarItem.tag      
            self.selectedIndex = viewControllerIndex
            return true
        }
    }
}
