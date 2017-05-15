//
//  KeyboardusPresentusExtraordinaris.swift
//  Together
//
//  Created by Андрей Цай on 09.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class KeyboardusPresentusExtraordinaris: UIPresentationController {
    
    var heightMultiplier: CGFloat = 0.3
    fileprivate let dimmingView = UIView()
    
    override func presentationTransitionWillBegin() {
        let removeGR = UISwipeGestureRecognizer(target: self, action: #selector(self.gestureDismiss))
        let removeTapGR = UITapGestureRecognizer(target: self, action: #selector(self.gestureDismiss))
        removeGR.direction = .down
        presentedViewController.view.addGestureRecognizer(removeGR)
        dimmingView.addGestureRecognizer(removeTapGR)
        dimmingView.frame = setDimmingBounds()
        dimmingView.backgroundColor = UIColor.grayColor(61, alpha: 128)
        dimmingView.alpha = 0
        containerView?.addSubview(dimmingView)
        presentedViewController.view.frame = setHiddenViewBounds()
        dimmingView.addSubview(presentedViewController.view)
        let coordinator = presentingViewController.transitionCoordinator
        coordinator?.animate(
            alongsideTransition: { (context) in
                self.dimmingView.alpha = 1
                self.presentedViewController.view.frame = self.setShowedViewBounds()
            }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let coordinator = presentingViewController.transitionCoordinator
        coordinator?.animate(
            alongsideTransition: { (context) in
                self.dimmingView.alpha = 0
                self.presentedViewController.view.frame = self.setHiddenViewBounds()
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool){
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    fileprivate func setDimmingBounds() -> CGRect {
        let height: CGFloat = UIScreen.main.bounds.height
        let y: CGFloat = 0
        let x: CGFloat = 0
        let width: CGFloat = UIScreen.main.bounds.width
        let newFrame = CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )
        return newFrame
    }
    
    fileprivate func setShowedViewBounds() -> CGRect{
        let height: CGFloat = round(UIScreen.main.bounds.height * heightMultiplier)
        let y: CGFloat = UIScreen.main.bounds.height - height
        let x: CGFloat = 0
        let width: CGFloat = UIScreen.main.bounds.width
        let newFrame = CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )
        return newFrame
    }
    
    fileprivate func setHiddenViewBounds() -> CGRect{
        let height: CGFloat = round(UIScreen.main.bounds.height / 3)
        let y: CGFloat = UIScreen.main.bounds.height
        let x: CGFloat = 0
        let width: CGFloat = UIScreen.main.bounds.width
        let newFrame = CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )
        return newFrame
    }
    
    @objc fileprivate func gestureDismiss(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
