//
//  Keyboardable.swift
//  Dudatez
//
//  Created by RekOn on 14/06/16.
//  Copyright © 2016 KickPunchLabs. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
//import RxGesture

protocol Keyboardable: class, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var disposeBag: DisposeBag { get }
    
    func animateKeyboard(duration: NSTimeInterval,
                         options: UIViewAnimationOptions,
                         keyboardHeight: CGFloat,
                         shouldShow shown: Bool)
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
                           shouldReceiveTouch touch: UITouch) -> Bool
    
    func additionalPrepare()
    
}

extension Keyboardable where Self: UIViewController {
    
    internal func keyboardableRx() {
        let keyboardWillChangeFrameNotification = NSNotificationCenter.defaultCenter().rx_notification(UIKeyboardWillChangeFrameNotification)
        
        keyboardWillChangeFrameNotification
            .takeUntil(self.rx_deallocated)
            .subscribeNext(keyboardWillChangeFrame)
            .addDisposableTo(disposeBag)
        
        let tap = UITapGestureRecognizer(target: self, action: nil)
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        tap.delegate = self
        
        self.additionalPrepare()
    }
    
    private func keyboardWillChangeFrame(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() else { return }
        let duration: NSTimeInterval = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
        let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
        
        let shown = endFrame.origin.y >= UIScreen.mainScreen().bounds.size.height
        let keyboardHeight = endFrame.size.height
        
        self.animateKeyboard(duration, options: animationCurve, keyboardHeight: keyboardHeight, shouldShow: shown)
    }
    
    internal func dissmissKeyboard() {
        self.view.endEditing(true)
    }
    
    internal func gestureShouldReceiveTouch(touch: UITouch) -> Bool {
        if touch.view is UIControl || touch.view?.superview is UITableViewCell {
            return false
        }
        self.dissmissKeyboard()
        return true
    }
    
}

