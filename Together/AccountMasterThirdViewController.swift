//
//  AccountMasterThirdViewController.swift
//  Together
//
//  Created by Андрей Цай on 23.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

struct Interest {
    var data: InterestData
    var selected: Bool
}

class AccountMasterThirdViewController: UIViewController {
    
    weak var parentMaster: AccountMasterPageViewController!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var FinishButton: PrettyButton!
    
    fileprivate var interests: [Interest] = []
    fileprivate var loaded:Bool = false
    fileprivate let rowsOnScreen: CGFloat = 15
    var selectedInterests: [Interest] {
        get {
            return self.interests.filter{ $0.selected }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
        tableView.rowHeight = ceil(tableView.frame.height / rowsOnScreen)
    }
    
    fileprivate func loadData(){
        BackEndOverlay.getInterests{ (result) in
            switch result {
            case .success(let interestsArray):
                self.interests = []
                for i in interestsArray {
                    let iData = Interest(data: i, selected: false)
                    self.interests.append(iData)
                }
                self.loaded = true
                self.tableView.reloadData()
            case .failure(let error):
                print("Error loading interests! \(error)")
            }
        }
    }
    
    fileprivate func refreshData(){
        if !loaded {
            loadData()
        }
        tableView.reloadData()
    }
    
    fileprivate func makePretty(){
        FinishButton.loadStatesProfile(TogetherPrettyButtonProfiles.BlueLoginButton)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension AccountMasterThirdViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InterestCell", for: indexPath) as! AccountCreateMasterThirdTableViewCell
        let iData = interests[(indexPath as NSIndexPath).row]
        cell.InterestTitleLabel.text = iData.data.title
        cell.CheckButton.isSelected = iData.selected
        cell.selectPointColor((indexPath as NSIndexPath).row)
        cell.selectCallBack = {[weak self] (state) in
            let index = indexPath.row
            self?.interests[index].selected = state
        }
        return cell
    }

}

extension AccountMasterThirdViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let cell = tableView.cellForRow(at: indexPath) as? AccountCreateMasterThirdTableViewCell else { return }
        let newState = !interests[indexPath.row].selected
        interests[indexPath.row].selected = newState
        cell.CheckButton.isSelected = newState
    }
}

extension AccountMasterThirdViewController {
    
    @IBAction func ActionDescriptionPopup(_ sender: UIButton, forEvent event: UIEvent) {
        sender.isSelected = !sender.isSelected
        if let touches = event.allTouches {
            //print (touches)
            let touchPoint = touches.first!.location(in: self.tableView)
            if let tapIndexPath = tableView.indexPathForRow(at: touchPoint) {
                self.interests[(tapIndexPath as NSIndexPath).row].selected = sender.isSelected
            }
        }
    }
    
    @IBAction func FinishAction(_ sender: UIButton) {
        print(selectedInterests)
        performSegue(withIdentifier: "CreateAccountMainTabSegue", sender: self)
    }
    
}
