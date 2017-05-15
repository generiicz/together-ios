//
//  AccountMasterThirdViewController.swift
//  Together
//
//  Created by Андрей Цай on 23.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import PromiseKit
import ObjectMapper
import PKHUD

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
    
    lazy var userApi: APIService<UserAPI> = APIService<UserAPI>()
    lazy var postApi: APIService<PostAPI> = APIService<PostAPI>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
        tableView.rowHeight = 50
    }
    
    fileprivate func loadData() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        postApi.request(target: .categories).then { (json, code) -> Promise<[InterestData]> in
            guard let raw = json.rawString() else {
                return Promise(error: CatchError.invalideJSON)
            }
            return Parser<InterestData>.convert(raw: raw, paths: ["data", "categories"])
        }.then { (items) -> Promise<[Interest]> in
            return Promise(resolvers: { (fulfill, reject) in
                var _objects: [Interest] = []
                items.forEach({ (item) in
                    let _object = Interest(data: item, selected: false)
                    _objects.append(_object)
                })
                if _objects.isEmpty {
                    reject(CatchError.emptyArray)
                } else {
                    fulfill(_objects)
                }
            })
        }.then { (interests) -> Void in
            PKHUD.sharedHUD.hide()
            self.interests = interests
            self.tableView.reloadData()
        }.catch { (error) in
            PKHUD.sharedHUD.hide()
            print(error)
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
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0) : .white
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
        //TODO: save intetests user (will be added in 2 part)
        print(selectedInterests)
        performSegue(withIdentifier: "CreateAccountMainTabSegue", sender: self)
    }
    
}
