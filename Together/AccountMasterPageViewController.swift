//
//  AccountMasterPageViewController.swift
//  Together
//
//  Created by Андрей Цай on 04.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

protocol AccountMasterPage: class {
    weak var parentMaster: AccountMasterPageViewController! {get set}
}

extension AccountMasterPageViewController:  UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                              viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.views.index(of: viewController){
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDataSource()
        self.setupPageControl()
        print (self.gestureRecognizers)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removeSwipeGesture()
    }
    
    func removeSwipeGesture(){
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    func changePageControl () {
        for view in self.view.subviews {
            print (view)
            for view2 in view.subviews {
                print ("2- ", view2)
            }
        }
    }
    
    fileprivate func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.lightGray
        appearance.currentPageIndicatorTintColor = UIColor.cyan
        appearance.backgroundColor = UIColor.white
        self.changePageControl()
    }
    
    func setupDataSource () {
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

}
