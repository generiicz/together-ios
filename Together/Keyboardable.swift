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
    var additionalPrepareClosure: (() -> Void)? {get set}
    
    func animateKeyboard(_ duration: TimeInterval,
                         options: UIViewAnimationOptions,
                         keyboardHeight: CGFloat,
                         shouldShow shown: Bool)
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool
    
}

extension Keyboardable where Self: UIViewController {
    
    internal func keyboardableRx() {
        let keyboardWillChangeFrameNotification = NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillChangeFrame)
        
        keyboardWillChangeFrameNotification
            .takeUntil((self as! NSObject).rx.deallocated)
            .subscribe(onNext: keyboardWillChangeFrame)
            .addDisposableTo(disposeBag)
        
        let tap = UITapGestureRecognizer(target: self, action: nil)
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        tap.delegate = self
        if let additionalPrepareClosure = self.additionalPrepareClosure {
            additionalPrepareClosure()
        }
    }
    
    fileprivate func keyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let duration: TimeInterval = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
        let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
        
        let shown = endFrame.origin.y >= UIScreen.main.bounds.size.height
        let keyboardHeight = endFrame.size.height
        
        self.animateKeyboard(duration, options: animationCurve, keyboardHeight: keyboardHeight, shouldShow: shown)
    }
    
    internal func dissmissKeyboard() {
        self.view.endEditing(true)
    }
    
    internal func gestureShouldReceiveTouch(_ touch: UITouch) -> Bool {
        if touch.view is UIControl || touch.view?.superview is UITableViewCell {
            return false
        }
        self.dissmissKeyboard()
        return true
    }
    
}

