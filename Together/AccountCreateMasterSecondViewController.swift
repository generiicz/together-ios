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
    @IBOutlet weak var TopConstraint: NSLayoutConstraint!
    @IBOutlet weak var MiddleConstraint: NSLayoutConstraint!
    @IBOutlet weak var BottomConstraint: NSLayoutConstraint!
    
    @IBAction func NextPageAction(_ sender: UIButton) {
        self.parentMaster.nextPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PasswordTextField.setButton()
    }
    
    override internal func setNormalConstraints(){
        MiddleConstraint.constant = TopConstraint.constant + TitleLabel.frame.height + 50
        middleConstraintNormalValue = MiddleConstraint.constant
        self.bottomConstraintNormalValue = self.BottomConstraint.constant
        self.topConstraintNormalValue = self.TopConstraint.constant
    }
    
    override func animateKeyboard(_ duration: TimeInterval, options: UIViewAnimationOptions, keyboardHeight: CGFloat, shouldShow shown: Bool) {
        print(keyboardHeight)
        TopConstraint.constant = shown ? self.topConstraintNormalValue : 10
        MiddleConstraint.constant = shown ? middleConstraintNormalValue : 10
        BottomConstraint.constant = shown ? self.bottomConstraintNormalValue : keyboardHeight + self.keyboardBottomConstraint
        let labelHidden = !shown
        self.view.setNeedsLayout()
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {[weak self] in
                self?.TitleLabel.isHidden = labelHidden
                self?.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    fileprivate func makePretty(){
        keyboardBottomConstraint = -35
        NextPageButton.loadStatesProfile(TogetherPrettyButtonProfiles.BlueLoginButton)
        TitleLabel.addCharactersSpacing(2.5)
        PasswordLabel.addCharactersSpacing(1.5)
        PasswordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
