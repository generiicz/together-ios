//
//  ProfileMenuTableViewController.swift
//  Together
//
//  Created by Андрей Цай on 12.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class SettingsMenuViewController: UIViewController {
    
    fileprivate let menuDataSource = UniTableViewDataSource()
    fileprivate let itemHeight: CGFloat? = nil // = 36
    fileprivate var totalMenuItems: Int!
    //fileprivate let myFriendsVC = UsersTableViewController(nibName: "UsersTableViewController", bundle: nil)

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var editUserProfileButton: PrettyButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func editUserProfileAction(_ sender: UIButton) {
        print("Edit user profile")
    }
    
    @IBAction func shareWithFriendsAction(_ sender: UIButton) {
        print("share with friends")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuDataSource.defaultRowHeight = round(tableView.frame.height / CGFloat(totalMenuItems))
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuDataSource.defaultRowHeight = round(tableView.frame.height / CGFloat(totalMenuItems))
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: totalMenuItems - 1, section: 0), at: .bottom, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let heartInsetH = shareButton.frame.height*0.3
        let subWidth = shareButton.frame.width - shareButton.frame.height + heartInsetH*2
        let heartInsetRight = subWidth*0.9
        let heartInsetLeft = subWidth*0.1
        
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(
            heartInsetH,
            heartInsetLeft,
            heartInsetH,
            heartInsetRight
        )
        shareButton.titleEdgeInsets = UIEdgeInsetsMake(
            0,
            -shareButton.frame.width*0.3,
            0,
            0)
    }
    
    fileprivate func showMyFriends() {
        /*
        if let nc = self.navigationController {
            nc.show(myFriendsVC, sender: self)
        }*/
        let distanceLabel = UserCellAdditionalUItype.distanceLabel(CGSize(width: 100, height: 30))
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: TogetherNotificationTypes.mainNavSwitch),
            object: nil,
            userInfo: [
                "segueName": "FriendsUsersScreen",
                "segueParams":[
                    "queryType": GetUsersQueryType.friends(MyTogetherAccount.shared.uuid),
                    "profileData": [
                        "rightViews":[
                            UserCellAdditionalUItype.sendMessageToFriendButton,
                            distanceLabel
                        ],
                        "currentPhoneLocation": (UIApplication.shared.delegate as? AppDelegate)?.locationDataProvider.currentLocation.asObservable() as Any
                    ],
                    "geoDataEnabled": true,
                    "navigationType": UsersTableNavigationType.searchButtonAdd,
                    "headerType": SectionHeaderFooterType.searchButton(60),
                    "footerType": SectionHeaderFooterType.facebookSearchFriends(100)
                ]
            ])
    }
    /*
    fileprivate func setupMyFriendsVC() {
        let distanceLabel = UserCellAdditionalUItype.distanceLabel(CGSize(width: 100, height: 30))
        myFriendsVC.setupUsersTableView(
            queryType: .friends(MyTogetherAccount.shared.uuid),
            profileData: [
                "rightViews":[
                    UserCellAdditionalUItype.sendMessageToFriendButton,
                    distanceLabel
                ],
                "currentPhoneLocation": (UIApplication.shared.delegate as? AppDelegate)?.locationDataProvider.currentLocation.asObservable() as Any
            ],
            geoLocation: true
        )
    }*/
    
    fileprivate func selectedMenuItem(_ indexPath: IndexPath, cData: CellAbstractData?) {
        guard let itemTitle = cData?["Title"] as? String else { return }
        switch itemTitle {
        case "My Friends":
            showMyFriends()
        default:
            GUItools.alert(self, strTitle: "Under Construction", strBody: "Not implemented yet")
        }
    }
    
    fileprivate func makePretty() {
        //setupMyFriendsVC()
        BackEndOverlay.getImageWithUUID(MyTogetherAccount.shared.photoUUID){ result in
            switch result {
            case .success(let image):
                self.userPhoto.image = image
            case .failure(let error):
                self.userPhoto.image = UIImage(named:"StandardAvatar")
                print("Error loading image \(error)")
            }
        }
        userNameLabel.text = "\(MyTogetherAccount.shared.firstName) \(MyTogetherAccount.shared.lastName)"
        totalMenuItems = setupCells()
        menuDataSource.connectToTableView(tableView)
        editUserProfileButton.loadStatesProfile(TogetherPrettyButtonProfiles.RedUnderlinedButton)
        shareButton.setImage(GUItools.iconicImage("SettingsShareWithFriends"), for: UIControlState())
    }
    
    fileprivate func setupCells() -> Int{
        menuDataSource.addSection(SectionMetaData(
            headerType: .none(0),
            footerType: .none(0),
            cells: []))
        let titleColor = UIColor.grayColor(131)
        let profileData = [
            "TitleColor": titleColor,
            "TintColor": titleColor,
            ]
        do {
            try menuDataSource.addCell(
                0,
                reusableIdentifier: "SettingsMenuCell",
                nibName: "SettingsMenuCell",
                rowHeight: itemHeight,
                cellData: [
                    "Title": "My Friends",
                    "ImageName": "SettingsMyFriends"
                ],
                profileData: profileData,
                selectedClosure: self.selectedMenuItem
            )
            try menuDataSource.addCell(
                0,
                reusableIdentifier: "SettingsMenuCell",
                nibName: "SettingsMenuCell",
                rowHeight: itemHeight,
                cellData: [
                    "Title": "Events History",
                    "ImageName": "SettingsEventsHistory"
                ],
                profileData: profileData,
                selectedClosure: self.selectedMenuItem
            )
            try menuDataSource.addCell(
                0,
                reusableIdentifier: "SettingsMenuCell",
                nibName: "SettingsMenuCell",
                rowHeight: itemHeight,
                cellData: [
                    "Title": "Interests",
                    "ImageName": "SettingsInterests"
                ],
                profileData: profileData,
                selectedClosure: self.selectedMenuItem
            )
            try menuDataSource.addCell(
                0,
                reusableIdentifier: "SettingsMenuCell",
                nibName: "SettingsMenuCell",
                rowHeight: itemHeight,
                cellData: [
                    "Title": "Notifications",
                    "ImageName": "SettingsNotifications"
                ],
                profileData: profileData,
                selectedClosure: self.selectedMenuItem
            )
            try menuDataSource.addCell(
                0,
                reusableIdentifier: "SettingsMenuCell",
                nibName: "SettingsMenuCell",
                rowHeight: itemHeight,
                cellData: [
                    "Title": "Settings",
                    "ImageName": "SettingsSettings"
                ],
                profileData: profileData,
                selectedClosure: self.selectedMenuItem
            )
            try menuDataSource.addCell(
                0,
                reusableIdentifier: "SettingsMenuCell",
                nibName: "SettingsMenuCell",
                rowHeight: itemHeight,
                cellData: [
                    "Title": "Help",
                    "ImageName": "SettingsHelp"
                ],
                profileData: profileData,
                selectedClosure: self.selectedMenuItem
            )
            try menuDataSource.addCell(
                0,
                reusableIdentifier: "SettingsMenuCell",
                nibName: "SettingsMenuCell",
                rowHeight: itemHeight,
                cellData: [
                    "Title": "Add Event",
                    "TitleColor": TogetherColors.RedMain,
                    "TintColor": TogetherColors.RedMain,
                    "ImageName": "SettingsAddEvent"
                ],
                profileData: [
                    "TitleColor": TogetherColors.RedMain,
                    "TintColor": TogetherColors.RedMain
                ],
                selectedClosure: self.selectedMenuItem
            )
        } catch {
            print("Error adding menu cells\n\(error)")
        }
        menuDataSource.generateCells(tableView)
        return menuDataSource.cellsCount[0]
    }

}
