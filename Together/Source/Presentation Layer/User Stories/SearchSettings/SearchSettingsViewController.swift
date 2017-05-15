//
//  SearchSettingsViewController.swift
//  Together
//
//  Created by Андрей Цай on 11.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class SearchSettingsViewController: UIViewController, BackNavigation {
    
    fileprivate var dsArray: [UniTableViewDataSource] = []
    fileprivate var displayedView: UITableViewController? = nil
    fileprivate var switchSegmented: UISegmentedControl!
    fileprivate var startPage: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        self.makePretty()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.switchSegmented.selectedSegmentIndex = self.startPage
        self.displayView(dsArray[switchSegmented.selectedSegmentIndex])
    }
    
    func setupSearchSettings(_ pageNum: Int) {
        guard self.dsArray.count > 0 && pageNum >= 0 && pageNum <= self.dsArray.count - 1 else {
            startPage = 0
            return
        }
        startPage = pageNum
    }
    
    fileprivate func makePretty(){
        setupNavigation()
        
    }
    
    func confirmAction(_ sender: UIBarButtonItem){
        print("confirmAction \(sender)")
        backByStep(1)
    }
    
    func cancelAction(_ sender: UIBarButtonItem){
        print("cancelAction \(sender)")
        backByStep(1)
    }
    
    fileprivate func ongoingEventsAction(_ sender: PrettyButton) {
        print("ONGOING EVENTS")
    }
    
    fileprivate func extraTicketsAction(_ sender: PrettyButton) {
        print("EXTRA TICKETS")
    }
    
    fileprivate func searchEventsCreatedByFriendsAction(_ sender: PrettyButton) {
        print("SEARCH EVENTS CREATED BY FRIENDS")
    }
    
    func selectCountry(_ indexPath: IndexPath, cellData: CellAbstractData?) {
        print("select country by selecting cell")
    }
    
    func selectEventType(_ indexPath: IndexPath, cellData: CellAbstractData?) {
        print("select event type by selecting cell")
    }
    
    fileprivate func setupViews() {
        let firstDataSource = UniTableViewDataSource()
        firstDataSource.addSection(SectionMetaData(
            headerType: .none(0),
            footerType: .none(0),
            cells: []))
        do {
            try firstDataSource.addCell(
                0,
                reusableIdentifier: "ButtonCell",
                rowHeight: 96,
                cellData: nil,
                profileData: [
                    "title": "ONGOING EVENTS",
                    "visualProfile": TogetherPrettyButtonProfiles.RedBorderedButton,
                    "action": self.ongoingEventsAction
                ])
            try firstDataSource.addCell(
                0,
                reusableIdentifier: "ButtonCell",
                rowHeight: 96,
                cellData: nil,
                profileData: [
                    "title": "EXTRA TICKETS",
                    "visualProfile": TogetherPrettyButtonProfiles.BlueBorderedButton,
                    "action": self.extraTicketsAction
                ])
            try firstDataSource.addCell(
                0,
                reusableIdentifier: "ArrowButtonCell",
                nibName: "ArrowButtonCell",
                rowHeight: 42,
                cellData: [
                    "title": "Choose event type",
                    ],
                profileData: [
                    "backgroundColor": UIColor.white
                ],
                selectedClosure: self.selectEventType
            )
            try firstDataSource.addCell(
                0,
                reusableIdentifier: "SearchSettingsSearchCell",
                rowHeight: 100.0,
                cellData: [:],
                profileData: nil)
            try firstDataSource.addCell(
                0,
                reusableIdentifier: "DateTimeRangeCell",
                rowHeight: 142.0,
                cellData: [
                    "Title": "Event Date"
                ],
                profileData: [
                    "EditMode": UIDatePickerMode.date.rawValue
                ])
            try firstDataSource.addCell(
                0,
                reusableIdentifier: "DateTimeRangeCell",
                rowHeight: 142.0,
                cellData: [
                    "Title": "Event Time"
                ],
                profileData: [
                    "EditMode": UIDatePickerMode.time.rawValue
                ])
            try firstDataSource.addCell(
                0,
                reusableIdentifier: "AddressGeoCell",
                rowHeight:420.0,
                cellData: nil,
                profileData: [
                    "Title": "Select place to search",
                    "Latitude": 40.7264923,
                    "Longitude": -73.9411471,
                    "Address": "Some Place"
                ])
        } catch {
            print("Error setup firstDataSource\n\(error)")
        }
        firstDataSource.generateCells(tableView)
        let secondDataSource = UniTableViewDataSource()
        secondDataSource.addSection(SectionMetaData(
            headerType: .none(0),
            footerType: .none(0),
            cells: []))
        secondDataSource.addSection(SectionMetaData(
            headerType: .richText(
                "Gender",
                TogetherColors.GrayFontDark,
                18,
                0,
                UIColor.grayColor(248)),
            footerType: .none(0),
            cells: []))
        secondDataSource.addSection(SectionMetaData(
            headerType: .none(20),
            footerType: .none(0),
            cells: []))
        secondDataSource.addSection(SectionMetaData(
            headerType: .none(20),
            footerType: .none(0),
            cells: []))
        do {
            try secondDataSource.addCell(
                0,
                reusableIdentifier: "SearchSettingsSearchCell",
                rowHeight: 100.0,
                cellData: [:],
                profileData: nil)
            try secondDataSource.addCell(
                0,
                reusableIdentifier: "ButtonCell",
                rowHeight: 96,
                cellData: nil,
                profileData: [
                    "title": "SEARCH EVENTS CREATED BY FRIENDS",
                    "visualProfile": TogetherPrettyButtonProfiles.RedBorderedButton,
                    "action": self.searchEventsCreatedByFriendsAction
                ])
            try secondDataSource.addCell(
                0,
                reusableIdentifier: "ArrowButtonCell",
                nibName: "ArrowButtonCell",
                rowHeight: 42,
                cellData: [
                    "title": "Country",
                ],
                profileData: [
                    "backgroundColor": UIColor.white
                ],
                selectedClosure: self.selectCountry
            )
            try secondDataSource.addCell(
                1,
                reusableIdentifier: "GenderCell",
                rowHeight: 54,
                cellData: [
                    "selectedGender": 0
                ],
                profileData: nil
            )
            try secondDataSource.addCell(
                2,
                reusableIdentifier: "AgeCell",
                rowHeight: 120,
                cellData: [
                    "selectAge": true,
                    "minAge": 21 as Float,
                    "maxAge": 45 as Float
                ],
                profileData: nil)
            try secondDataSource.addCell(
                3,
                reusableIdentifier: "ArrowButtonCell",
                nibName: "ArrowButtonCell",
                rowHeight: 42,
                cellData: [
                    "title": "Choose event type",
                    ],
                profileData: [
                    "backgroundColor": UIColor.white
                ],
                selectedClosure: self.selectEventType
            )
        } catch {
            print("Error setup secondDataSource\n\(error)")
        }
        secondDataSource.generateCells(tableView)
        dsArray = [firstDataSource, secondDataSource]
    }
    
    fileprivate func setupNavigation() {
        let viewRect = CGRect(
            x: 0,
            y: 0,
            width: (self.navigationController?.navigationBar.bounds.width)! * 0.55,
            height: (self.navigationController?.navigationBar.bounds.height)! * 0.7
        )
        self.navigationItem.titleView = UIView(
            frame: viewRect
        )
        let segmentedItems = ["By Event", "By Creator"]
        switchSegmented = UISegmentedControl(items: segmentedItems)
        switchSegmented.layer.borderWidth = 1.0
        switchSegmented.layer.borderColor = UIColor.grayColor(163).cgColor
        switchSegmented.layer.cornerRadius = 6
        switchSegmented.frame = viewRect
        switchSegmented.selectedSegmentIndex = 0
        switchSegmented.addTarget(self, action: #selector(SearchSettingsViewController.switchWiews(_:)), for: .valueChanged )
        switchSegmented.setTitleTextAttributes(
            [
                NSFontAttributeName: UIFont(name: TogetherFontNames.SFUIDisplayRegular, size: 15)!,
                NSForegroundColorAttributeName: UIColor.grayColor(163),
                NSBackgroundColorAttributeName: UIColor.white
            ],
            for: UIControlState()
        )
        switchSegmented.setTitleTextAttributes(
            [
                NSFontAttributeName: UIFont(name: TogetherFontNames.SFUIDisplayRegular, size: 17)!,
                NSForegroundColorAttributeName: UIColor.white,
                NSBackgroundColorAttributeName: UIColor.grayColor(163)
            ],
            for: .selected
        )
        switchSelection(
            switchSegmented,
            bkgndColor: UIColor.white,
            selectedColor: UIColor.grayColor(163)
        )
        self.navigationItem.titleView?.addSubview(switchSegmented)
        let leftNavItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(SearchSettingsViewController.cancelAction(_:))
        )
        leftNavItem.setTitleTextAttributes(
            [
                NSFontAttributeName: UIFont(name: TogetherFontNames.SFUIDisplayRegular, size: 17)!,
                NSForegroundColorAttributeName: UIColor.colorFromRGB(236, green: 72, blue: 72, alpha: 255)
            ],
            for: UIControlState()
        )
        let rightNavItem = UIBarButtonItem(
            title: "Confirm",
            style: .plain,
            target: self,
            action: #selector(SearchSettingsViewController.confirmAction(_:))
        )
        rightNavItem.setTitleTextAttributes(
            [
                NSFontAttributeName: UIFont(name: TogetherFontNames.SFUIDisplayRegular, size: 17)!,
                NSForegroundColorAttributeName: UIColor.colorFromRGB(50, green: 175, blue: 255, alpha: 255)
            ],
            for: UIControlState()
        )
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = leftNavItem
        navigationItem.rightBarButtonItem = rightNavItem
    }
    
    func displayView(_ viewToDisplay: UniTableViewDataSource) {
        viewToDisplay.connectToTableView(self.tableView)
        tableView.reloadData()
    }
    
    func switchSelection(_ segmented: UISegmentedControl, bkgndColor: UIColor, selectedColor: UIColor){
        let sortedViews = segmented.subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        
        for (index, view) in sortedViews.enumerated() {
            view.layer.cornerRadius = 6
            if index == segmented.selectedSegmentIndex {
                view.tintColor = selectedColor
            } else {
                view.tintColor = bkgndColor
            }
        }
    }
    
    func switchWiews (_ sender: UISegmentedControl) {
        
        switchSelection(
            sender,
            bkgndColor: UIColor.white,
            selectedColor: UIColor.grayColor(163)
        )
        self.displayView(dsArray[sender.selectedSegmentIndex])
    }
    
    
    
}


