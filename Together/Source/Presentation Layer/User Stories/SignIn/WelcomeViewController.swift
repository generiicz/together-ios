//
//  WelcomeViewController.swift
//  Together
//
//  Created by Андрей Цай on 17.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class WelcomeViewController: UIViewController {
    
    fileprivate var slides: [UIImage]!
    fileprivate var backgroundImageView: UIImageView!
    fileprivate var secondBackgroundView: UIImageView!
    fileprivate let animated: Bool = true
    fileprivate var previousPage: Int = 0
    fileprivate let aniDuration: TimeInterval = 0.5

    @IBOutlet weak var PageControl: UIPageControl!
    
    @IBOutlet var SwipeRecognizerLeft: UISwipeGestureRecognizer!
    
    @IBOutlet var SwipeRecognizerRight: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slides = [
            UIImage(named: "WelcomeScreen-1")!,
            UIImage(named: "WelcomeScreen-2")!,
            UIImage(named: "WelcomeScreen-3")!,
            UIImage(named: "WelcomeScreen-4")!,
        ]
        self.setupPageControl()
        self.initBackgroundView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.setupPageControl()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.redrawBackgroundView()
    }
    
    func initBackgroundView() {
        self.secondBackgroundView = UIImageView(frame: UIScreen.main.bounds)
        self.view.insertSubview(self.secondBackgroundView, at: 0)
        self.secondBackgroundView.image = self.slides[self.PageControl.currentPage]
        self.backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        self.view.insertSubview(self.backgroundImageView, at: 1)
        self.backgroundImageView.image = self.slides[self.PageControl.currentPage]
        self.view.bringSubview(toFront: self.PageControl)
    }
    
    func redrawBackgroundView() {
        self.backgroundImageView.frame = UIScreen.main.bounds
    }
    
    func setBackgroundImage (_ image: UIImage, animated: Bool, animationType: UIViewAnimationOptions = .transitionFlipFromRight, animationDuration:TimeInterval = 0.5, direction: Int = 1){
        let frontView = self.view.subviews[1] as! UIImageView
        let backView = self.view.subviews[0] as! UIImageView
        let newOriginX: CGFloat = direction < 0 ? self.view.bounds.width : 0
        let backNewOriginX: CGFloat = direction < 0 ? 0 : -self.view.bounds.width
        if animated {
            if direction > 0 {
                backView.image = frontView.image
                frontView.isHidden = true
                frontView.frame.origin.x = self.view.bounds.width
                frontView.image = image
                frontView.isHidden = false
            } else {
                backView.image = image
                backView.frame.origin.x = -self.view.bounds.width
            }
            UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: animationType,
            animations: {() in
                frontView.frame.origin.x = newOriginX
                backView.frame.origin.x = backNewOriginX
            },
            completion: {(done) in
                if done && direction < 0 {
                    self.view.exchangeSubview(at: 0, withSubviewAt: 1)
                    frontView.frame.origin.x = 0
                }
                if done && direction > 0 {
                    backView.frame.origin.x = 0
                }
                self.enableGestures()
            }
            )
            
        } else {
            self.backgroundImageView.image = image
        }
    }
    
    func setupPageControl(){
        self.PageControl.numberOfPages = self.slides.count
        self.PageControl.currentPage = 0
        self.PageControl.backgroundColor = UIColor.colorFromRGB(42, green: 172, blue: 255, alpha: 255)
        self.PageControl.tintColor = UIColor.white
    }
    
    func decreasePage() {
        self.previousPage = self.PageControl.currentPage
        self.PageControl.currentPage -= 1
    }
    
    func increasePage(){
        self.previousPage = self.PageControl.currentPage
        self.PageControl.currentPage += 1
    }
    
    func disableGestures(){
        self.SwipeRecognizerLeft.isEnabled = false
        self.SwipeRecognizerRight.isEnabled = false
    }
    
    func enableGestures(){
        self.SwipeRecognizerLeft.isEnabled = true
        self.SwipeRecognizerRight.isEnabled = true
    }
    
    func listForward(){
        self.disableGestures()
        if self.animated {
            self.setBackgroundImage(
                self.slides[self.PageControl.currentPage],
                animated: true,
                animationType: UIViewAnimationOptions.transitionFlipFromRight,
                animationDuration: self.aniDuration,
                direction: 1
            )
        } else {
            self.setBackgroundImage(self.slides[self.PageControl.currentPage], animated: false)
        }
    }
    
    func listBackward(){
        self.disableGestures()
        if self.animated {
            self.setBackgroundImage(
                self.slides[self.PageControl.currentPage],
                animated: true,
                animationType: UIViewAnimationOptions.transitionFlipFromLeft,
                animationDuration: self.aniDuration,
                direction: -1
            )
        } else {
            self.setBackgroundImage(self.slides[self.PageControl.currentPage], animated: false)
        }
    }
    
}

extension WelcomeViewController {
    
    @IBAction func SwipeLeftAction(_ sender: UISwipeGestureRecognizer) {
        if self.PageControl.currentPage < self.PageControl.numberOfPages - 1 {
            self.increasePage()
            self.listForward()
        } else {
            Defaults[.firstStart] = false
            self.navigationController?.performSegue(withIdentifier: "SignInSegue", sender: self)
        }
    }
    
    @IBAction func SwipeRightAction(_ sender: UISwipeGestureRecognizer) {
        if self.PageControl.currentPage > 0 {
            self.decreasePage()
            self.listBackward()
        }
    }
    
    @IBAction func CurrentPageChangedAction(_ sender: UIPageControl) {
        if previousPage < sender.currentPage {
            self.listForward()
        } else if previousPage > sender.currentPage {
            self.listBackward()
        }
        self.previousPage = sender.currentPage
    }
}
