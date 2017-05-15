//
//  TestViewController.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    var firstDataSource: UniTableViewDataSource!
    var secondDataSource: UniTableViewDataSource!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var togetherTabBar: TogetherTabBar!
    @IBOutlet weak var TestButton: UIButton!
    @IBOutlet weak var testButton2: PrettyButton!
    @IBOutlet weak var testButton3: UIButton!
    
    @IBAction func TestAction(_ sender: UIButton) {
        if let dSource = tableView.dataSource  as? UniTableViewDataSource {
            print(dSource.cellsOutputData)
        }
    }
    @IBAction func TestAction2(_ sender: UIButton) {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: TogetherNotificationTypes.mainNavSwitch),
            object: nil,
            userInfo: [
                "segueName": "HomeEventDetails",
                "segueParams": [
                    "eventData": testEvents[0].events[0]
                ]
            ])
    }
    @IBAction func TestAction3(_ sender: UIButton) {
        let popFrame = CGRect(
            x: self.view.frame.origin.x + self.view.frame.width / 4,
            y: self.view.frame.origin.y + self.view.frame.height / 4,
            width: self.view.frame.width / 2,
            height: self.view.frame.height / 2)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        firstDataSource = UniTableViewDataSource()
        firstDataSource.addSection(SectionMetaData(
            headerType: .none(0),
            footerType: .none(0),
            cells: []))
        do {
            try firstDataSource.addCell(0, reusableIdentifier: "DateTimeRangeCell", rowHeight: 142, cellData: ["Title": "Test1"], profileData: nil)
            try firstDataSource.addCell(0, reusableIdentifier: "DateTimeRangeCell", rowHeight: 420, cellData: ["Title": "Test2"], profileData: nil)
            try firstDataSource.addCell(0, reusableIdentifier: "DateTimeRangeCell", rowHeight: 142, cellData: ["Title": "Test3"], profileData: nil)
            try firstDataSource.addCell(0, reusableIdentifier: "DateTimeRangeCell", rowHeight: 142, cellData: ["Title": "Test4"], profileData: nil)
            try firstDataSource.addCell(0, reusableIdentifier: "DateTimeRangeCell", rowHeight: 142, cellData: ["Title": "Test5"], profileData: nil)
            try firstDataSource.addCell(0, reusableIdentifier: "DateTimeRangeCell", rowHeight: 142, cellData: ["Title": "Test6"], profileData: nil)
            try firstDataSource.addCell(0, reusableIdentifier: "DateTimeRangeCell", rowHeight: 142, cellData: ["Title": "Test7"], profileData: nil)
            try firstDataSource.addCell(0, reusableIdentifier: "DateTimeRangeCell", rowHeight: 142, cellData: ["Title": "Test8"], profileData: nil)
            try firstDataSource.addCell(0, reusableIdentifier: "DateTimeRangeCell", rowHeight: 142, cellData: ["Title": "Test9"], profileData: nil)
            try firstDataSource.addCell(0, reusableIdentifier: "DateTimeRangeCell", rowHeight: 142, cellData: ["Title": "Test10"], profileData: nil)
            try firstDataSource.addCell(0, reusableIdentifier: "DateTimeRangeCell", rowHeight: 142, cellData: ["Title": "Test11"], profileData: nil)
            try firstDataSource.addCell(0, reusableIdentifier: "DateTimeRangeCell", rowHeight: 142, cellData: ["Title": "Test12"], profileData: nil)
        } catch {
            print("Error adding cells!\n\(error)")
        }
        firstDataSource.generateCells(tableView)
        firstDataSource.connectToTableView(tableView)
        
        let dParams = ButtonParameters(
            backgroundColor: UIColor.gray,
            titleBackgroundColor: UIColor.lightGray,
            fontColor: UIColor.darkGray,
            cornerRadius: 10,
            borderColor: UIColor.grayColor(65),
            borderWidth: 1)
        let nParams = ButtonParameters(
            backgroundColor: UIColor.white,
            titleBackgroundColor: UIColor.white,
            fontColor: UIColor.black,
            cornerRadius: 5,
            borderColor: UIColor.black,
            borderWidth: 2)
        let sParams = ButtonParameters(
            backgroundColor: UIColor.black,
            titleBackgroundColor: UIColor.black,
            fontColor: UIColor.white,
            cornerRadius: 5,
            borderColor: UIColor.grayColor(178),
            borderWidth: 2)
        testButton2.setParamsForState(UIControlState(), params: nParams)
        testButton2.setParamsForState(.disabled, params: dParams)
        testButton2.setParamsForState(.selected, params: sParams)
        togetherTabBar.setupTabBar()
    }
    
    func testAction(){
        print("TestAction")
    }

    func displayDate(_ date: Date){
        GUItools.alert(self, strTitle: "Date Test", strBody: date.displayDate("en_US", dateStyle: .none, timeStyle: .short))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
