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
import PKHUD

class LoginViewController: KeyboardableViewController, InputViewController {
    
    var inputFields: [InputTableCell] = []
    var inputFieldsData: [InputCellData] = []
    var wayChosen: Bool!
    fileprivate var inputTableSized: Bool = false
    fileprivate var bottomConstraintNormalValue: CGFloat = 8
    fileprivate var middleConstraintNormalValue: CGFloat = 8
    fileprivate var topConstraintNormalValue:CGFloat = 8
    fileprivate let standardRowHeight: CGFloat = 80
    fileprivate var login: String? {
        didSet {
            typedAction()
        }
    }
    fileprivate var password: String? {
        didSet {
            typedAction()
        }
    }

    @IBOutlet weak var inputTableView: UITableView!
    @IBOutlet weak var LoginButton: PrettyButton!
    @IBOutlet weak var SignInLabel: UILabel!
    @IBOutlet weak var CreateAccountButton: PrettyButton!
    @IBOutlet weak var ForgotPasswordButton: PrettyButton!
    @IBOutlet weak var BottomConstraint: NSLayoutConstraint!
    
    lazy var api: APIService<AuthAPI> = APIService<AuthAPI>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.keyboardableRx()
        self.makePretty()
        inputTableView.dataSource = self
        let uParams = UnderlineTextFieldParams(
            color: UIColor.clear,
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
            inputTableView.rowHeight = standardRowHeight
            inputTableSized = true
        }
    }
    
    func passwordValidator(_ text: String?) {
        print("password: \(text ?? "")")
        guard let text = text else {
            password = nil
            return
        }
        password = text
    }
    
    func emailValidator(_ text: String?) {
        print("Email: \(text ?? "")")
        guard let text = text else {
            login = nil
            return
        }
        login = text
        
    }
    
    func typedAction() {
        if login != nil && password != nil {
            LoginButton.isEnabled = true
        } else {
            LoginButton.isEnabled = false
        }
    }
    
    override func animateKeyboard(_ duration: TimeInterval, options: UIViewAnimationOptions, keyboardHeight: CGFloat, shouldShow shown: Bool) {
        BottomConstraint.constant = shown ? self.bottomConstraintNormalValue : keyboardHeight * 0.8 + self.keyboardBottomConstraint
        self.view.setNeedsLayout()
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {[weak self] in
                self?.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    fileprivate func makePretty() {
        self.SignInLabel.addCharactersSpacing(5.5)
        self.LoginButton.loadStatesProfile(TogetherPrettyButtonProfiles.BlueLoginButton)
        self.LoginButton.isEnabled = false
        ForgotPasswordButton.loadStatesProfile(TogetherPrettyButtonProfiles.GrayLinkButton(61))
        self.CreateAccountButton.loadStatesProfile(TogetherPrettyButtonProfiles.GrayLinkButton(113))
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
        guard let login = login, let password = password else {
            return
        }
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        api.request(target: .login(email: login, password: password)).then { (json, code) -> Void in
            PKHUD.sharedHUD.hide()
            if json["code"] == 200 {
                if let token = json["data"]["token"].string {
                    Defaults[.token] = token
                }
                self.performSegue(withIdentifier: "MainTabSegue", sender: self)
            } else {
                GUItools.alert(self, strTitle: "Login Error!", strBody: "Not valid username or password")
            }
        }.catch { (error) in
            PKHUD.sharedHUD.hide()
            GUItools.alert(self, strTitle: "Server Error!", strBody: "Something went wrong.")
            print(error)
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
