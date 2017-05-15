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
    
    var topConstraintNormalValue: CGFloat = 8
    var middleConstraintNormalValue: CGFloat = 8
    var bottomConstraintNormalValue: CGFloat = 8
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var WarningLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var EmailTextField: UnderlinedTextField!
    @IBOutlet weak var ResetPasswordButton: PrettyButton!
    @IBOutlet weak var RegistrationButton: PrettyButton!

    @IBOutlet weak var TopConstraint: NSLayoutConstraint!
    @IBOutlet weak var MiddleConstraint: NSLayoutConstraint!
    @IBOutlet weak var BottomConstraint: NSLayoutConstraint!
    
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
    
    override internal func setNormalConstraints() {
        self.bottomConstraintNormalValue = self.BottomConstraint.constant
        self.topConstraintNormalValue = self.TopConstraint.constant
        MiddleConstraint.constant = TopConstraint.constant + TitleLabel.frame.height + 20
        middleConstraintNormalValue = MiddleConstraint.constant
    }
    
    override func animateKeyboard(_ duration: TimeInterval, options: UIViewAnimationOptions, keyboardHeight: CGFloat, shouldShow shown: Bool) {
        print(keyboardHeight)
        TopConstraint.constant = shown ? self.topConstraintNormalValue : 0
        MiddleConstraint.constant = shown ? middleConstraintNormalValue : 0
        BottomConstraint.constant = shown ? self.bottomConstraintNormalValue : keyboardHeight + self.keyboardBottomConstraint
        let labelHidden = !shown
        
        self.view.setNeedsLayout()
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {[weak self] in
                self?.WarningLabel.isHidden = labelHidden
                self?.TitleLabel.isHidden = labelHidden
                self?.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    fileprivate func makePretty(){
        keyboardBottomConstraint = -35
        TitleLabel.addCharactersSpacing(2.5)
        WarningLabel.addCharactersSpacing(2.5)
        EmailLabel.addCharactersSpacing(1.5)
        ResetPasswordButton.loadStatesProfile(TogetherPrettyButtonProfiles.BlueLoginButton)
        RegistrationButton.loadStatesProfile(TogetherPrettyButtonProfiles.GrayLinkButton(178))
        EmailTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
