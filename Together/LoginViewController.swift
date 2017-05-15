//
//  LoginViewController.swift
//  Together
//
//  Created by Андрей Цай on 05.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyUserDefaults

class LoginViewController: KeyboardableViewController, InputViewController {
    
    var inputFields: [InputTableCell] = []
    var inputFieldsData: [InputCellData] = []
    var wayChosen: Bool!
    fileprivate var inputTableSized: Bool = false
    fileprivate var bottomConstraintNormalValue: CGFloat = 8
    fileprivate var middleConstraintNormalValue: CGFloat = 8
    fileprivate var topConstraintNormalValue:CGFloat = 8
    fileprivate let standardRowHeight: CGFloat = 64
    fileprivate var login: String?
    fileprivate var password: String?

    @IBOutlet weak var MiddleConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputTableView: UITableView!
    @IBOutlet weak var LoginButton: PrettyButton!
    @IBOutlet weak var SignInLabel: UILabel!
    @IBOutlet weak var CreateAccountButton: PrettyButton!
    @IBOutlet weak var ForgotPasswordButton: PrettyButton!
    @IBOutlet weak var BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var TopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.keyboardableRx()
        self.makePretty()
        inputTableView.dataSource = self
        let uParams = UnderlineTextFieldParams(
            color: UIColor.grayColor(192),
            width: 1,
            enabled: true)
        let iField1 = InputCellData(
            cellClass: InputCell2.self,
            title: "Email",
            underline: uParams,
            observer: self.emailValidator,
            setupClosure: nil
        )
        let iField2 = InputCellData(
            cellClass: InputCell2.self,
            title: "Password",
            underline: uParams,
            observer: self.passwordValidator,
            setupClosure: { (cell: InputTableCell) in
                cell.inputTextField.isSecureTextEntry = true
            }
        )
        inputFieldsData = [iField1, iField2]
        setupInputViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        resetWay()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !inputTableSized {
            let rowHeight = ceil((inputTableView.frame.height - inputTableView.frame.height * 0.2) / CGFloat(inputFields.count))
            inputTableView.rowHeight = rowHeight < standardRowHeight ? standardRowHeight : rowHeight
            inputTableSized = true
        }
    }
    
    func passwordValidator(_ text: String){
        print("password: \(text)")
        password = text.isEmpty ? nil : text
        typedAction()
    }
    
    func emailValidator(_ text: String){
        print("Email: \(text)")
        login = text.isEmpty ? nil : text
        typedAction()
    }
    
    func typedAction(){
        if login != nil && password != nil {
            LoginButton.isEnabled = true
        } else {
            LoginButton.isEnabled = false
        }
    }
    
    override internal func setNormalConstraints () {
        self.bottomConstraintNormalValue = self.BottomConstraint.constant
        self.topConstraintNormalValue = self.TopConstraint.constant
        MiddleConstraint.constant = TopConstraint.constant + SignInLabel.frame.height + 8
        middleConstraintNormalValue = MiddleConstraint.constant
    }
    
    override func animateKeyboard(_ duration: TimeInterval, options: UIViewAnimationOptions, keyboardHeight: CGFloat, shouldShow shown: Bool) {
        //print(keyboardHeight)
        TopConstraint.constant = shown ? self.topConstraintNormalValue : 0
        MiddleConstraint.constant = shown ? middleConstraintNormalValue : 0
        BottomConstraint.constant = shown ? self.bottomConstraintNormalValue : keyboardHeight + self.keyboardBottomConstraint
        self.view.setNeedsLayout()
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {[weak self] in
                self?.SignInLabel.isHidden = !shown
                self?.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    fileprivate func makePretty(){
        self.SignInLabel.addCharactersSpacing(5.5)
        self.LoginButton.loadStatesProfile(TogetherPrettyButtonProfiles.BlueLoginButton)
        self.LoginButton.isEnabled = false
        self.ForgotPasswordButton.loadStatesProfile(TogetherPrettyButtonProfiles.GrayLinkButton(178))
        self.CreateAccountButton.loadStatesProfile(TogetherPrettyButtonProfiles.GrayLinkButton(178))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputFields.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = inputFields[(indexPath as NSIndexPath).row] as! UITableViewCell
        return cell
    }

}

extension LoginViewController {
    
    @IBAction func LoginAction(_ sender: UIButton) {
        chooseWayByButton(sender){ () in
            guard let login = self.login, let password = self.password else {
                GUItools.alert(self, strTitle: "Login Error!", strBody: "Not valid username or password")
                return
            }
            BackEndOverlay.getTokenByLogIn(login, password: password){ (result) in
                switch result{
                case .success(let flag):
                    if flag{
                        self.performSegue(withIdentifier: "MainTabSegue", sender: self)
                    } else {
                        GUItools.alert(self, strTitle: "Login Error!", strBody: "Wrong username or password")
                    }
                case .failure(let error):
                    GUItools.alert(self, strTitle: "Login Error!", strBody: "\(error)")
                }
            }
        }
    }
    
    @IBAction func ForgotPasswordAction(_ sender: UIButton) {
        chooseWayByButton(sender){ () in
            self.navigationController?.performSegue(withIdentifier: "ForgotPasswordSegue", sender: self)
        }
    }
    
    @IBAction func CreateAccountAction(_ sender: UIButton) {
        chooseWayByButton(sender){ () in
            self.navigationController?.performSegue(withIdentifier: "CreateAccountSegue", sender: self)
        }
    }
    
}

extension LoginViewController: ChooseOneWay {
    
    internal func resetWay(){
        LoginButton.isUserInteractionEnabled = true
        CreateAccountButton.isUserInteractionEnabled = true
        ForgotPasswordButton.isUserInteractionEnabled = true
        CreateAccountButton.isUserInteractionEnabled = true
        wayChosen = false
    }
}
