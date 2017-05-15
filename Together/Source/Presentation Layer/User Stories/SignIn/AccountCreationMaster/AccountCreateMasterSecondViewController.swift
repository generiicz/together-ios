//
//  AccountCreateMasterSecondViewController.swift
//  Together
//
//  Created by Андрей Цай on 05.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import RxSwift

class AccountCreateMasterSecondViewController: KeyboardableViewController, AccountMasterPage {

    weak var parentMaster: AccountMasterPageViewController!
    var topConstraintNormalValue: CGFloat = 8
    var middleConstraintNormalValue: CGFloat = 8
    var bottomConstraintNormalValue: CGFloat = 8
    
    @IBOutlet weak var NextPageButton: PrettyButton!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var PasswordTextField: SecureViewableTextField!
    
    @IBAction func NextPageAction(_ sender: UIButton) {
        self.parentMaster.save(password: PasswordTextField.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PasswordTextField.setButton()
    }
    
    fileprivate func makePretty(){
        keyboardBottomConstraint = -35
        NextPageButton.loadStatesProfile(TogetherPrettyButtonProfiles.BlueLoginButton)
        TitleLabel.addCharactersSpacing(1.5)
        PasswordLabel.addCharactersSpacing(1)
        PasswordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
