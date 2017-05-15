//
//  MessagesTableViewController.swift
//  Together
//
//  Created by Андрей Цай on 12.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController, BackNavigation, MainTabChild {
    
    weak var MainNavController: UINavigationController!
    var messages: [MessageData] = []
    var loaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
        tableView.register(UINib(nibName: "MessagesCell", bundle: nil), forCellReuseIdentifier: "MessagesCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
    }
    
    func loadTestData () {
        BackEndOverlay.getLastMessagesForUser("test"){ (result) in
            switch result {
            case .success(let messages):
                self.messages = messages
                self.tableView.reloadData()
                //self.loaded = true
            case .failure(let error):
                print("Error loading messages for user \(error)")
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
            //self.loaded = true
        } else {
            self.tableView.reloadData()
        }
    }
    
    func makePretty(){
        self.navigationController?.isNavigationBarHidden = false
        self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell", for: indexPath) as! MessagesCell
        cell.loadData(messages[(indexPath as NSIndexPath).row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        let data = self.messages[(indexPath as NSIndexPath).row]
        print(data)
    }

}
