//
//  CreateEventViewController.swift
//  Together
//
//  Created by developer on 09.05.17.
//  Copyright © 2017 Андрей Цай. All rights reserved.
//

import Foundation
import UIKit
//TODO: can complited after do other parts
class CreateEventViewController: UIViewController {
    // MARK: Property
    @IBOutlet fileprivate weak var EmailButton: PrettyButton!
    @IBOutlet fileprivate weak var PhoneButton: PrettyButton!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
    }
    
    // MARK: Actions
    @IBAction func closeBarItemAction(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private
    fileprivate func makePretty() {
        self.EmailButton.loadStatesProfile(TogetherPrettyButtonProfiles.CreateButton)
        self.PhoneButton.loadStatesProfile(TogetherPrettyButtonProfiles.CreateButton)
    }
}
