//
//  HomeEventDetailsViewController.swift
//  Together
//
//  Created by Андрей Цай on 14.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import RxSwift

class HomeEventDetailsViewController: UIViewController {
    internal var tableDataSource: UniTableViewDataSource = UniTableViewDataSource()
    internal var tableDataSourceMode: UniTableViewCellsMode = .unique
    fileprivate let tableRowHeight: CGFloat = 128
    fileprivate let participantsHeight: CGFloat = 182
    fileprivate var loaded = false
    var eventData = Variable<EventData?>(nil)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var togetherTabBar: TogetherTabBar!

    override func awakeFromNib() {
        super.awakeFromNib()
        tableDataSource.cellsMode = tableDataSourceMode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
        tableDataSource.connectToTableView(tableView)
        setupCells()
        tableDataSource.generateCells(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    fileprivate func iHaveExtraTicketAction(_ sender: PrettyButton) {
        print("Have extra ticket!")
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: TogetherNotificationTypes.mainNavSwitch),
            object: nil,
            userInfo: [
                "segueName": "FriendsUsersScreen",
                "segueParams":[
                    "queryType": GetUsersQueryType.friends(MyTogetherAccount.shared.uuid),
                    "profileData": [
                        "rightViews":[
                            UserCellAdditionalUItype.addToFriendsButton
                        ]
                    ],
                    "geoDataEnabled": false
                ]
        ])
    }
    
    fileprivate func contactFaciliatorAction(_ sender: PrettyButton) {
        print("Contact faciliator!")
    }
    
    fileprivate func sendFriendRequestToCreator(_ sender: PrettyButton) {
        print("SEND FRIEND REQUEST")
    }
    
    @objc fileprivate func shareEventSelector() {
        print("ShareEventSelector")
    }

    fileprivate func updateCellsData(_ eData: EventData) {
        do {
            try tableDataSource.updateCellsData(
                0,
                range: 0...0) { cell in
                    guard let cell = cell as? UniCell else { return }
                    cell.setupCellData(["event": eData])
            }
        } catch {
            print("Error updating cells data\n\(error)")
        }
    }
    
    fileprivate func makePretty () {
        togetherTabBar.setupTabBar()
        tableView.backgroundColor = UIColor.grayColor(248)
        setupNavigationPanel()
    }
    
    fileprivate func setupNavigationPanel() {
        self.navigationController?.navigationBar.tintColor = TogetherColors.BlueTwitter
        let navIconSide: CGFloat = self.navigationController != nil ? floor((self.navigationController?.navigationBar.frame.height)! * 0.8) : 42
        let navIconFrame = CGRect(x: 0, y: 0, width: navIconSide, height: navIconSide)
        let navIconView = UIView(frame: navIconFrame)
        let imageView = UIImageView(image: GUItools.iconicImage("SettingsShareWithFriends"))
        imageView.makeSizeRestrictedView(size: navIconFrame.size)
        imageView.tintColor = TogetherColors.RedMain
        navIconView.addSubview(imageView)
        navIconView.addMarginsToSubview(top: 0, left: 0, bottom: 0, right: 0, target: imageView)
        imageView.sizeToFit()
        navigationItem.titleView = navIconView
        let navShareButton = UIBarButtonItem(
            image: UIImage(named: "shareIcon"),
            style: .done,
            target: self,
            action: #selector(self.shareEventSelector))
        navShareButton.tintColor = TogetherColors.BlueTwitter
        navShareButton.imageInsets = UIEdgeInsetsMake(16, 32, 16, 0)
        navigationItem.rightBarButtonItem = navShareButton
    }
    
    fileprivate func setupCells() {
        tableDataSource.addSection(SectionMetaData(
            headerType: .none(0),
            footerType: .none(0),
            cells: [
                CellMetaData(
                    identifier: "EventDetailsPhotoCell",
                    rowHeight: 300,
                    cellData: [
                        "event": eventData as Any
                    ],
                    profileData: [
                        "backgroundColor": UIColor.grayColor(248)
                    ]),
                CellMetaData(
                    identifier: "HEDEventTimeCell",
                    rowHeight: 74,
                    cellData: [
                        "event": eventData as Any
                    ],
                    profileData: nil),
                CellMetaData(
                    identifier: "StaticGoogleMapCell",
                    rowHeight: 320,
                    cellData: [
                        "event": eventData as Any
                    ],
                    profileData: nil)
            ]
        ))
        tableDataSource.addSection(SectionMetaData(
            headerType: .richText(
                "Created",
                TogetherColors.GrayFontDark,
                18,
                0,
                UIColor.grayColor(248)),
            footerType: .none(0),
            cells: [
                CellMetaData(
                    identifier: "HEDCreatorCell",
                    rowHeight: 142,
                    cellData: [
                        "event": eventData as Any
                    ],
                    profileData: nil),
                CellMetaData(
                    identifier: "ButtonCell",
                    rowHeight: 94,
                    cellData: nil,
                    profileData: [
                        "title": "SEND FRIEND REQUEST",
                        "visualProfile": TogetherPrettyButtonProfiles.BlueLoginButton,
                        "action": self.sendFriendRequestToCreator,
                        "backgroundColor": UIColor.grayColor(248)
                    ])
            ]
        ))
        tableDataSource.addSection(SectionMetaData(
            headerType: .richText(
                "Users",
                TogetherColors.GrayFontDark,
                18,
                0,
                UIColor.grayColor(248)),
            footerType: .none(0),
            cells: [
                CellMetaData(
                    identifier: "HEDParticipantsCell",
                    rowHeight: participantsHeight,
                    cellData: [
                        "event": eventData as Any
                    ],
                    profileData: [
                        "itemHeight": participantsHeight]),
                CellMetaData(
                    identifier: "HEDExtraTicketsCell",
                    rowHeight: 42,
                    cellData: [
                        "event": eventData as Any
                    ],
                    profileData: nil),
                CellMetaData(
                    identifier: "ButtonCell",
                    rowHeight: 94,
                    cellData: nil,
                    profileData: [
                        "title": "I HAVE AN EXTRA TICKET",
                        "visualProfile": TogetherPrettyButtonProfiles.RedBorderedGrayBackButton,
                        "action": self.iHaveExtraTicketAction,
                        "backgroundColor": UIColor.grayColor(248)]),
                CellMetaData(
                    identifier: "ButtonCell",
                    rowHeight: 94,
                    cellData: nil,
                    profileData: [
                        "title": "CONTACT THE FACILIATOR",
                        "visualProfile": TogetherPrettyButtonProfiles.RedPlainButton,
                        "action": self.contactFaciliatorAction,
                        "backgroundColor": UIColor.grayColor(248)])
            ]
        ))
    }
    
}
