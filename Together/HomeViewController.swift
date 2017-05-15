//
//  HomeViewController.swift
//  Together
//
//  Created by Андрей Цай on 29.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController, MainTabChild, BackNavigation {
    
    fileprivate var eventsList: [EventGroupData] = []
    fileprivate var loaded = false
    fileprivate let colViewHorMargin: CGFloat = 10
    fileprivate let colViewHorPadding: CGFloat = 4
    fileprivate let colViewVertMargin: CGFloat = 10
    fileprivate let colViewVertPadding: CGFloat = 8
    fileprivate let tableSectionHeaderHeight: CGFloat = 46
    fileprivate let tableRowHeightMiltiplier: CGFloat = 0.9
    weak var MainNavController: UINavigationController!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var AddEventButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
    }
    
    func createSectionHeader(eventGroupUUID: String, eventGroupTitle: String) -> HomeSectionHeaderView? {
        guard let instance = Bundle.main.loadNibNamed("HomeSectionHeaderView", owner: HomeSectionHeaderView.self, options: nil)?.first as? HomeSectionHeaderView else { return nil }
        instance.setupView(uuid: eventGroupUUID, title: eventGroupTitle)
        return instance
    }
    
    func loadTestData () {
        BackEndOverlay.getEventsForHome{ (result) in
            switch result {
            case .success(let events):
                DispatchQueue.main.async {
                    self.eventsList = events
                    self.tableView.reloadData()
                    self.loaded = true
                }
            case .failure(let error):
                print("Error loading events! \(error)")
            }
        }
    }
    
    func reloadData() {
        self.loaded = false
        self.refreshData()
    }
    
    func refreshData(){
        if !self.loaded {
            self.loadTestData()
        } else {
            self.tableView.reloadData()
        }
    }
    
    func makePretty(){
        self.navigationController?.isNavigationBarHidden = false
        tableView.rowHeight = UIScreen.main.bounds.width * tableRowHeightMiltiplier
    }
    
    func showEventOnMap(_ location: CLLocationCoordinate2D) {
        let newIndex = (self.tabBarController?.selectedIndex)! - 1
        let mapView = self.tabBarController?.viewControllers![newIndex] as! MapViewController
        mapView.setCurrentPosition(location, zoom: 15)
        self.tabBarController?.selectedIndex = newIndex
    }

}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.eventsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! HomeTableViewCell
        let eventGroup = self.eventsList[(indexPath as NSIndexPath).section]
        let collectionLayout = cell.EventsCollection.collectionViewLayout as! HorizontalLayout
        collectionLayout.setupLayout(
            tableView.rowHeight - self.colViewVertMargin * 2 - 1,
            itemWidth: round(UIScreen.main.bounds.width*0.9),
            horizontalPadding: self.colViewHorPadding,
            verticalPadding: self.colViewVertPadding,
            horizontalMargin: self.colViewHorMargin,
            verticalMargin: self.colViewVertMargin,
            pagingType: .truePaging
        )
        collectionLayout.invalidateLayout()
        cell.EventsCollection.loadEvents(eventGroup.events)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableSectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionData = eventsList[section]
        guard let headerView = createSectionHeader(eventGroupUUID: sectionData.uuid, eventGroupTitle: sectionData.name) else { return nil }
        return headerView
    }
}
