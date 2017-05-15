//
//  AccountMasterPageViewController.swift
//  Together
//
//  Created by Андрей Цай on 04.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
import PKHUD
import PromiseKit

protocol AccountMasterPage: class {
    weak var parentMaster: AccountMasterPageViewController! {get set}
}

extension AccountMasterPageViewController:  UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                              viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.views.index(of: viewController) {
            if index - 1 >= 0 {
                return self.views[index-1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                              viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = self.views.index(of: viewController){
            if index + 1 < self.views.count {
                return self.views[index+1]
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.views.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
}

class AccountMasterPageViewController: UIPageViewController {
    
    var views:[UIViewController]!
    var currentIndex: Int = 0
    
    fileprivate var name = ""
    fileprivate var email = ""
    
    lazy var authApi: APIService<AuthAPI> = APIService<AuthAPI>()
    lazy var userApi: APIService<UserAPI> = APIService<UserAPI>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDataSource()
        self.setupPageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removeSwipeGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .white
        for subView in view.subviews {
            if  subView is  UIPageControl {
                subView.frame.origin.y = self.view.frame.size.height - 34
                subView.frame.size.height -= 25
            }
        }
    }
    
    func removeSwipeGesture(){
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    func changePageControl() {
        
    }
    
    fileprivate func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.lightGray
        
        appearance.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "dot_img_selected")!)
        appearance.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "dot_img")!)
        appearance.backgroundColor = UIColor.white
        self.changePageControl()
    }
    
    func setupDataSource() {
        let FirstPage = storyboard!.instantiateViewController(withIdentifier: "Account Master 1")
        let SecondPage = storyboard!.instantiateViewController(withIdentifier: "Account Master 2")
        let ThirdPage = storyboard!.instantiateViewController(withIdentifier: "Account Master 3")
        let tmp = [FirstPage, SecondPage, ThirdPage]
        for v in tmp {
            let vv = v as? AccountMasterPage
            vv?.parentMaster = self
        }
        self.loadViewControllers(tmp)
        let view = self.getCurrentView()
        self.dataSource = self
        self.setViewControllers([view], direction: .forward, animated: true, completion: nil)
    }
    
    func incrementIndex() -> Bool {
        let newIndex = self.currentIndex + 1
        if newIndex < self.views.count {
            self.currentIndex = newIndex
            return true
        }
        return false
    }
    
    func decrementIndex() -> Bool{
        let newIndex = self.currentIndex - 1
        if newIndex >= 0 {
            self.currentIndex = newIndex
            return true
        }
        return false
    }
    
    func getCurrentView() -> UIViewController{
        return self.views[self.currentIndex]
    }
    
    func loadViewControllers (_ views: [UIViewController]) {
        self.views = views
    }
    
    func nextPage () {
        if self.incrementIndex(){
            let view = self.getCurrentView()
            self.setViewControllers([view], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func save(name: String, email: String) {
        self.name = name
        self.email = email
        nextPage()
    }
    
    func save(password: String?) {
        guard let password = password else {
            return
        }
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        authApi.request(target: .registation(email: email, password: password)).then { (json, code) -> Promise<(json: JSON, code: Int)> in
            if json["code"] == 200 {
                if let token = json["data"]["token"].string {
                    Defaults[.token] = token
                }
                return self.userApi.request(target: .update(name: self.name))
            } else {
                PKHUD.sharedHUD.hide()
                GUItools.alert(self, strTitle: "Login Error!", strBody: "Not valid username or password")
                return Promise(error: CatchError.denyAccess)
            }
        }.then { (json, code) -> Void in
            PKHUD.sharedHUD.hide()
            if code == 200 {
                self.nextPage()
            }
        }.catch { (error) in
                PKHUD.sharedHUD.hide()
                GUItools.alert(self, strTitle: "Server Error!", strBody: "Something went wrong.")
                print(error)
        }
    }

}
