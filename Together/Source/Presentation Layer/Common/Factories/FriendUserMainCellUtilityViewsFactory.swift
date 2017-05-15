//
//  FriendUserMainCellUtilityViewsFactory.swift
//  Together
//
//  Created by Андрей Цай on 11.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import RxSwift

//MARK: All UI elements makers here
struct FriendUserMainCellUtilityViewsFactory {
    
    static func makeCustomButton(title: String?, textColor: UIColor?, imageName: String?, size: CGSize, target: Any, callBack: Selector) -> UIButton {
        let res = UIButton()
        res.makeSizeRestrictedView(size: size)
        res.addTarget(target, action: callBack, for: .touchUpInside)
        if let title = title {
            res.setTitle(title, for: .normal)
        }
        if let textColor = textColor {
            res.setTitleColor(textColor, for: .normal)
        }
        if let iName = imageName, let image = UIImage(named: iName) {
            res.setImage(image, for: .normal)
        }
        return res
    }
    
    static func makeCustomLabel(text: String, size:CGSize) -> UILabel {
        let res = UILabel()
        res.makeSizeRestrictedView(size: size)
        res.text = text
        return res
    }
    
    static func makeDistanceLabel(size: CGSize) -> UILabel {
        let res = UILabel()
        res.makeSizeRestrictedView(size: size)
        res.text = "_ m."
        return res
    }
    
    static func makeAddToFriendsButton (size: CGSize, target: Any, callBack: Selector, currentUserUUID: String, userDataObservable: Observable<UserData?>, disposeBag: DisposeBag) -> UIButton {
        let res = makeCustomButton(
            title: nil,
            textColor: nil,
            imageName: "addPlain",
            size: size,
            target: target,
            callBack: callBack)
        res.setImage(UIImage(named: "removePlain"), for: .selected)
        res.setImage(UIImage(named: "circlePlain"), for: .disabled)
        res.tintColor = UIColor.blue
        res.isEnabled = false
        userDataObservable
            .filter{$0 != nil}
            .subscribe(onNext:
            { (uData) in
                BackEndOverlay.checkForFriendship(firstUserUUID: currentUserUUID, secondUserUUID: uData!.uuid){ (result) in
                    switch result {
                    case .success(let isFriend):
                        res.isEnabled = true
                        res.isSelected = isFriend
                    case .failure(let error):
                        print("Error getting friendship! Sad!\n\(error)")
                    }
                }
            }).addDisposableTo(disposeBag)
        return res
    }
    
    static func makeMessageButton(size: CGSize, target: Any, callBack: Selector, userDataObservable: Observable<UserData?>, disposeBag: DisposeBag) -> UIButton {
        let res = makeCustomButton(
            title: nil,
            textColor: nil,
            imageName: "MessageIcon",
            size: size,
            target: target,
            callBack: callBack)
        res.setImage(UIImage(named: "UserOffline"), for: .selected)
        res.tintColor = UIColor.cyan
        userDataObservable
            .filter{$0 != nil}
            .subscribe(onNext:
                { (uData) in
                    BackEndOverlay.getUserConnectionStatusByUUID(uData!.uuid){ (result) in
                        switch result {
                        case .success(let isOnline):
                            res.isSelected = !isOnline
                        case .failure(let error):
                            print("Error getting friendship! Sad!\n\(error)")
                        }
                    }
            }).addDisposableTo(disposeBag)
        return res
    }
}
