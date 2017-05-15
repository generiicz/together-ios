//
//  FirstViewController.swift
//  Together
//
//  Created by Андрей Цай on 04.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class ShakeViewController: UIViewController, MainTabChild, BackNavigation {
    
    weak var MainNavController: UINavigationController!
    
    @IBOutlet weak var FirstButton: UIButton!
    @IBOutlet weak var SecondButton: UIButton!
    @IBOutlet weak var ChooseEventTypeButton: PrettyButton!
    @IBOutlet weak var ActivateShakeLabel: UILabel!
    
    @IBAction func FirstButtonAction(_ sender: UIButton) {
        self.MainNavController.performSegue(withIdentifier: "SearchSettingsSegue", sender: self)
    }
    @IBAction func SecondButtonAction(_ sender: UIButton) {
        self.navigationController?.performSegue(withIdentifier: "SecondSegue", sender: self)
    }
    @IBAction func ChooseEventTypeAction(_ sender: PrettyButton) {
    }

    func makePretty(){
        self.FirstButton.setVisuals(
            UIColor.white,
            borderWidth: 1,
            borderColor: UIColor.white.withAlphaComponent(0.7),
            bkgndColor: UIColor.gray.withAlphaComponent(0.1),
            cornerRadius: 1)
        ChooseEventTypeButton.loadStatesProfile(TogetherPrettyButtonProfiles.RedTextButton)
        ActivateShakeLabel.addCharactersSpacing(1.2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake ) {
            print("You shook me, now what")
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
    }

}

