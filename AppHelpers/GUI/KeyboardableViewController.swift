//
//  KeyboardableViewController.swift
//  Together
//
//  Created by Андрей Цай on 05.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import RxSwift

class KeyboardableViewController: UIViewController, Keyboardable {

    internal var disposeBag: DisposeBag = DisposeBag()
    internal var additionalPrepareClosure: (() -> Void)? = nil
    internal var keyboardBottomConstraint: CGFloat = 0
    internal var validateConstraints: Bool = false {
        didSet{
            if !oldValue && validateConstraints {
                setNormalConstraints()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardableRx()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        validateConstraints = true
    }

    internal func setNormalConstraints() {
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return self.gestureShouldReceiveTouch(touch)
    }
    
    func animateKeyboard(_ duration: TimeInterval, options: UIViewAnimationOptions, keyboardHeight: CGFloat, shouldShow shown: Bool) {
    }

}
