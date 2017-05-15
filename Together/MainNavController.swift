//
//  MainNavController.swift
//  Together
//
//  Created by Андрей Цай on 04.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import CoreLocation

class MainNavController: UINavigationController {
    
    fileprivate lazy var homeScreenEventDetailsVC = HomeEventDetailsViewController(nibName: "HomeEventDetailsViewController", bundle: nil)
    fileprivate lazy var friendsUsersScreenVC = UsersTableViewController(nibName: "UsersTableViewController", bundle: nil)
    fileprivate var searchSettingsVC: SearchSettingsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchSettingsVC = storyboard?.instantiateViewController(withIdentifier: "SearchSettingsViewController") as! SearchSettingsViewController
        self.makePretty()
        self.setupNotifications()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func makePretty() {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.white
        navigationBar.backgroundColor = UIColor.white
    }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(MainNavController.switchByNotification(_:)),
            name: NSNotification.Name(rawValue: TogetherNotificationTypes.mainNavSwitch),
            object: nil)
    }
    
    fileprivate func mainTabShowIndex(_ index: Int) {
        guard let rootVC = viewControllers[0] as? MainTabBarViewController else { return }
        rootVC.switchToTab(index)
        self.popToRootViewController(animated: true)
    }
    
    @objc fileprivate func switchByNotification(_ notification: Notification) {
        guard let paramDict = (notification as NSNotification).userInfo as? [String: Any] else { return }
        guard let segueName = paramDict["segueName"] as? String else { return }
        guard let segueParams = paramDict["segueParams"] as? [String: Any] else { return }
        print(segueName, segueParams)
        switch segueName {
        case "Root":
            let index = segueParams["tabIndex"] as? Int ?? 2
            mainTabShowIndex(index)
        case "HomeEventDetails":
            if let eventData = segueParams["eventData"] as? EventData {
                homeScreenEventDetailsVC.eventData.value = eventData
                show(homeScreenEventDetailsVC, sender: self)
            }
        case "ShowEventOnMap":
            if let eventLocation = segueParams["location"] as? CLLocationCoordinate2D, let rootVC = viewControllers[0] as? MainTabBarViewController, let mapVC = rootVC.viewControllers?[Tabs.map.rawValue] as? MapViewController {
                mapVC.setCurrentPosition(eventLocation, zoom: 18)
                mainTabShowIndex(Tabs.map.rawValue)
            }
        case "FriendsUsersScreen":
            if let queryType = segueParams["queryType"] as? GetUsersQueryType, let profileData = segueParams["profileData"] as? CellAbstractData, let geoDataEnabled = segueParams["geoDataEnabled"] as? Bool {
                let navType = segueParams["navigationType"] as? UsersTableNavigationType ?? .none
                let headerType = segueParams["headerType"] as? SectionHeaderFooterType ?? .none(0)
                let footerType = segueParams["footerType"] as? SectionHeaderFooterType ?? .none(0)
                friendsUsersScreenVC.setupUsersTableView(
                    queryType: queryType,
                    profileData: profileData,
                    geoLocation: geoDataEnabled,
                    navigationType: navType,
                    headerType:  headerType,
                    footerType:  footerType
                )
                show(friendsUsersScreenVC, sender: self)
            }
        case "SearchFacebookFriends":
            print("SearchFacebookFriends")
            if let friendsPerPage = segueParams["FriendsPerPage"] as? Int{
                print(friendsPerPage)
            }
        
        case "SearchSettings":
            print("SearchSettings")
            if let ssPage = segueParams["SearchSettingsPage"] as? Int {
                print(ssPage)
                searchSettingsVC.setupSearchSettings(ssPage)
                show(self.searchSettingsVC, sender: self)
            }
        default:
            performSegue(withIdentifier: segueName, sender: self)
        }
    }

}
