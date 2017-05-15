//
//  UsersTableViewController.swift
//  Together
//
//  Created by Андрей Цай on 07.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import CoreLocation
//import GoogleMapsBase
/*
struct CellProfile {
    var cellType: Any
    var setupData: CellAbstractData
}*/
/*
enum usersTableHeaderType {
    case none
    case search
}
*/
enum UsersTableNavigationType {
    case none
    case backTitle(String)
    case backSearch
    case searchButtonAdd
}
/*
enum usersTableFooterType {
    case none
    case facebookSearchFriends
}*/

class UsersTableViewController: UIViewController {
    
    fileprivate var tableDataSource: UniTableViewDataSource!
    fileprivate var usersData: [String] = []
    fileprivate var queryType: GetUsersQueryType!
    fileprivate var cellProfile: CellAbstractData!
    fileprivate let tableRowHeight: CGFloat = 142
    fileprivate var currentPhoneLocation: CLLocationCoordinate2D?
    fileprivate var navType: UsersTableNavigationType = .none
    fileprivate var headerType: SectionHeaderFooterType = .none(0)
    fileprivate var footerType: SectionHeaderFooterType = .none(0)
    //fileprivate var locationManager: CLLocationManager?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var togetherTabBar: TogetherTabBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //locationManager?.delegate = self
        updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //guard let lm = locationManager else { return }
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.locationDataProvider.askForInUseGeoPermissions()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //locationManager?.delegate = nil
    }
    
    func setupUsersTableView(queryType: GetUsersQueryType, profileData: CellAbstractData, geoLocation: Bool = false, navigationType: UsersTableNavigationType = .none, headerType: SectionHeaderFooterType = .none(0), footerType: SectionHeaderFooterType = .none(0)) {
        self.queryType = queryType
        self.cellProfile = profileData
        self.navType = navigationType
        self.headerType = headerType
        self.footerType = footerType
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if geoLocation {
            appDelegate.locationDataProvider.askForInUseGeoPermissions()
        }
    }
    
    fileprivate func makePretty() {
        togetherTabBar.setupTabBar()
        setupTable()
        setupNav()
    }
    
    @objc fileprivate func addUserSelector(_ sender: UIBarButtonItem) {
        print("addUserSelector")
    }
    
    fileprivate func createNavSearchButton(_ widthMultiplyer: CGFloat) -> SearchButtonView?{
        guard let navController = self.navigationController else {return nil}
        let newFrame = CGRect(x: 0, y: 0, width: navController.navigationBar.frame.width * widthMultiplyer, height: navController.navigationBar.frame.height)
        let searchView = SearchButtonView(frame: newFrame)
        searchView.setupView()
        searchView.addStandardTarget()
        return searchView
    }
    
    fileprivate func createBackSearchNavView() {
        guard let searchView = createNavSearchButton(0.6) else {return}
        self.navigationItem.titleView = searchView
    }
    
    fileprivate func createBackTitleNavView(_ title: String) {
        let navTitle = UniTableDataSourceFactory.createSectionTitle(title)
        self.navigationItem.titleView = navTitle
    }
    
    fileprivate func createSearchAddNavView() {
        guard let searchView = createNavSearchButton(0.7) else {return}
        self.navigationItem.hidesBackButton = true
        self.navigationItem.titleView = searchView
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addUserSelector(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    fileprivate func setupNav() {
        switch self.navType {
        case .none:
            break
        case .backSearch:
            self.createBackSearchNavView()
        case .backTitle(let title):
            self.createBackTitleNavView(title)
        case .searchButtonAdd:
            self.createSearchAddNavView()
        }
    }
    
    fileprivate func setupTable() {
        tableDataSource = UniTableViewDataSource()
        tableDataSource.defaultRowHeight = self.tableRowHeight
        tableDataSource.connectToTableView(tableView)
        
    }
    
    fileprivate func generateCells() {
        tableDataSource.addSection(SectionMetaData(
            headerType: self.headerType,
            footerType: self.footerType,
            cells: []))
        var data: CellAbstractData = [:]
        for userUUID in usersData {
            data["userUUID"] = userUUID
            do {
                try tableDataSource.addCell(
                    0,
                    reusableIdentifier: "FriendUserMainCell",
                    rowHeight: nil,
                    cellData: data,
                    profileData: cellProfile)
            } catch {
                print("Error generating users cells\n\(error)")
            }
        }
        tableDataSource.regenerateCells(tableView)
        tableView.reloadData()
    }
    
    fileprivate func regenerateCells() {
        tableDataSource.clean()
        generateCells()
    }
    
    fileprivate func updateData() {
        BackEndOverlay.getUsersUUIDs(For: self.queryType){ (result) in
            switch result {
            case .success(let users):
                self.usersData = users
                self.regenerateCells()
            case .failure(let error):
                GUItools.alert(self, strTitle: "Network Error", strBody: "Can't load users!\nCode: \(error)")
            }
        }
    }
}
/*
extension UsersTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentPhoneLocation = location.coordinate
            do {
                try tableDataSource.updateAllCellsData{ cell in
                    guard let uCell = cell as? FriendUserMainCell else { return }
                    uCell.setupCellData(
                        [
                            "currentPhoneLocation": currentPhoneLocation as Any
                        ]
                    )
                }
            } catch {
                print("Error update data in cells\n\(error)")
            }
            //regenerateCells()
            //manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        GUItools.alert(self, strTitle: "Get location error", strBody: "Your location is unavailable\n\(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .restricted, .denied, .notDetermined:
            GUItools.alert(self, strTitle: "GeoLocation is not allowed!", strBody: "Some data would not be available to you. Please allow geolocation usage for application.")
        }
    }
}*/
