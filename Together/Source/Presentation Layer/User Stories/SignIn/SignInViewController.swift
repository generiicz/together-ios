//
//  SignInViewController.swift
//  Together
//
//  Created by Андрей Цай on 04.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftyJSON
import PKHUD
import SwiftyUserDefaults

class SignInViewController: UIViewController, BackNavigation {
    
    var wayChosen: Bool!
    
    @IBOutlet fileprivate weak var CreateAccountButton: PrettyButton!
    @IBOutlet fileprivate weak var SignInButon: PrettyButton!
    @IBOutlet fileprivate weak var TwitterButton: PrettyButton!
    @IBOutlet fileprivate weak var Facebook: PrettyButton!
    @IBOutlet fileprivate weak var orLabel: UILabel!
    @IBOutlet fileprivate weak var orView: drawingView!
    
    lazy var api: APIService<AuthAPI> = APIService<AuthAPI>()
    
    @IBAction func SignInAction(_ sender: UIButton) {
        chooseWayByButton(sender){ () in
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
        }
    }
    
    @IBAction func CreateAccountAction(_ sender: UIButton) {
        chooseWayByButton(sender){ () in
            self.navigationController?.performSegue(withIdentifier: "CreateAccountSegue", sender: self)
        }
    }
    
    @IBAction func FacebookAction(_ sender: UIButton) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        SocialService.login(type: .facebook, sender: self).then { (token) -> Promise<(json: JSON, code: Int)> in
            PKHUD.sharedHUD.show()
            return self.api.request(target: .social(type: .facebook, token: token))
        }.then { [weak self] (json, code) -> Void in
            PKHUD.sharedHUD.hide()
            if code == 200 {
                if let token = json["data"]["token"].string {
                    Defaults[.token] = token
                }
                self?.performSegue(withIdentifier: "openMain", sender: self)
            }
        }.catch { (error) in
            PKHUD.sharedHUD.hide()
            print(error)
        }
    }
    
    @IBAction func TwitterAction(_ sender: UIButton) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        SocialService.login(type: .twitter, sender: self).then { (token) -> Promise<(json: JSON, code: Int)> in
            PKHUD.sharedHUD.show()
            return self.api.request(target: .social(type: .twitter, token: token))
            }.then { [weak self] (json, code) -> Void in
                PKHUD.sharedHUD.hide()
                if code == 200 {
                    if let token = json["data"]["token"].string {
                        Defaults[.token] = token
                    }
                    self?.performSegue(withIdentifier: "openMain", sender: self)
                }
            }.catch { (error) in
                PKHUD.sharedHUD.hide()
                print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makePretty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetWay()
    }
    
    fileprivate func makePretty() {
        changeBackNavItem("", tintColor: UIColor.lightGray)
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.SignInButon.loadStatesProfile(TogetherPrettyButtonProfiles.MainGraySignInButton)
        self.TwitterButton.loadStatesProfile(TogetherPrettyButtonProfiles.TwitterLoginButton)
        self.Facebook.loadStatesProfile(TogetherPrettyButtonProfiles.FacebookLoginButton)
        self.CreateAccountButton.loadStatesProfile(TogetherPrettyButtonProfiles.GrayLinkButton(113))
        orView.clearsContextBeforeDrawing = true
    }
}

extension SignInViewController: ChooseOneWay {
    
    internal func resetWay() {
        SignInButon.isUserInteractionEnabled = true
        TwitterButton.isUserInteractionEnabled = true
        Facebook.isUserInteractionEnabled = true
        CreateAccountButton.isUserInteractionEnabled = true
        wayChosen = false
    }
}
