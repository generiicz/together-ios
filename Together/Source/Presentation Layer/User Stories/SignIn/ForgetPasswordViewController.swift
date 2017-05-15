//
//  ForgetPasswordViewController.swift
//  Together
//
//  Created by Андрей Цай on 26.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import RxSwift

class ForgetPasswordViewController: KeyboardableViewController, BackNavigation {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var WarningLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var EmailTextField: UnderlinedTextField!
    @IBOutlet weak var ResetPasswordButton: PrettyButton!
    @IBOutlet weak var RegistrationButton: PrettyButton!

    @IBAction func registerAction(_ sender: PrettyButton) {
        if let navigationController = self.navigationController {
            navigationController.performSegue(withIdentifier: "CreateAccountSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeBackNavItem("")
    }
    
    fileprivate func makePretty(){
        keyboardBottomConstraint = -35
        TitleLabel.addCharactersSpacing(1.5)
        WarningLabel.addCharactersSpacing(1.5)
        EmailLabel.addCharactersSpacing(1)
        ResetPasswordButton.loadStatesProfile(TogetherPrettyButtonProfiles.BlueLoginButton)
        RegistrationButton.loadStatesProfile(TogetherPrettyButtonProfiles.GrayLinkButton(61))
        EmailTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
