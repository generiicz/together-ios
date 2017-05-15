//
//  FriendUserMainCell.swift
//  Together
//
//  Created by Андрей Цай on 16.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift

struct additionalDisplayClosure {
    var view: UIView
    //var viewData: CellAbstractData
    var closure: (UIView, CellAbstractData) -> Void
}

enum UserCellAdditionalUItype {
    case addToFriendsButton
    case sendMessageToFriendButton
    case distanceLabel(CGSize)
    case customButton(String?, UIColor?, String?, CGSize, Any, Selector)
    case customLabel(String, CGSize)
    case abstractView(UIView, CGSize)
}

class FriendUserMainCell: UITableViewCell {

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMessagesButton: UIButton!
    @IBOutlet weak var deleteUserButton: UIButton!
    @IBOutlet weak var mainHorizontalStack: UIStackView!
    @IBOutlet weak var mainVerticalStack: UIStackView!
    
    fileprivate let standardSize = CGSize(width: 42, height: 42)
    fileprivate var additionalDisplayUserClosures: [additionalDisplayClosure] = []
    fileprivate var currentPhoneLocation: Observable<CLLocation?>! // = Variable<CLLocationCoordinate2D?>(nil)
    fileprivate var disposeBag = DisposeBag()
    fileprivate var userData = Variable<UserData?>(nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userData.asObservable()
            .filter{$0 != nil}
            .subscribe(onNext: displayUserData)
            .addDisposableTo(disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    fileprivate func displayUserData(_ uData: UserData?) {
        guard let uData = uData else { return }
        userNameLabel.text = "\(uData.firstName) \(uData.lastName)"
        BackEndOverlay.getImageWithUUID(uData.photoUUID){ (result) in
            switch result {
            case .success(let image):
                self.userPhoto.image = image
            case .failure(let error):
                print ("Error loading user photo!\n\(error)")
            }
        }
        /*
        for cData in additionalDisplayUserClosures {
            cData.closure(
                cData.view,
                [
                    "userData": userData,
                    "currentPhoneLocation": currentPhoneLocation
                ])
        }*/
    }
    
    fileprivate func makeAdditionalUIElement(_ elementType: UserCellAdditionalUItype) -> UIView {
        var res: UIView!
        switch elementType {
        case .customButton(let title, let textColor, let imageName, let size, let target, let callBack):
            res = FriendUserMainCellUtilityViewsFactory.makeCustomButton(title: title, textColor: textColor, imageName: imageName, size: size, target: target, callBack: callBack)
        case .customLabel(let text, let size):
            res = FriendUserMainCellUtilityViewsFactory.makeCustomLabel(text: text, size: size)
        case .abstractView(let view, let size):
            res = view
            res.makeSizeRestrictedView(size: size)
        case .distanceLabel(let size):
            res = FriendUserMainCellUtilityViewsFactory.makeDistanceLabel(size: size)
            currentPhoneLocation
                .filter{$0 != nil}
                .subscribe(onNext:{ phoneLoc in
                    guard let label = res as? UILabel, let uuid = self.userData.value?.uuid else { return }
                    BackEndOverlay.getUserCurrentLocationByUUID(uuid){ (result) in
                        switch result {
                        case .success(let otherLocation):
                            let distance = usaDistance(meters:GMSGeometryDistance(phoneLoc!.coordinate, otherLocation))
                            label.text = distance.usaDistanceString
                        case .failure(let error):
                            print ("Error get user location!\n\(error)")
                        }
                    }
                })
                .addDisposableTo(disposeBag)
        case .addToFriendsButton:
            res = FriendUserMainCellUtilityViewsFactory.makeAddToFriendsButton(
                size: standardSize,
                target: self,
                callBack: #selector(self.addToFriends(_:)),
                currentUserUUID: MyTogetherAccount.shared.uuid,
                userDataObservable: userData.asObservable(),
                disposeBag: disposeBag)
        case .sendMessageToFriendButton:
            res = FriendUserMainCellUtilityViewsFactory.makeMessageButton(
                size: standardSize,
                target: self,
                callBack: #selector(self.sendMessageToFriend(_:)),
                userDataObservable: userData.asObservable(),
                disposeBag: disposeBag)
            
        }
        return res
    }
    
    fileprivate func addSubViews(to: UIStackView, viewTypes: [UserCellAdditionalUItype]) {
        for t in viewTypes {
            to.addArrangedSubview(makeAdditionalUIElement(t))
        }
    }
    
}
// MARK: Selectors for utility views
extension FriendUserMainCell {
    @objc fileprivate func addToFriends(_ sender: UIButton) {
        guard let uuid = userData.value?.uuid else { return }
        if sender.isSelected {
            BackEndOverlay.removefromFriends(masterUUID: MyTogetherAccount.shared.uuid, friendUUID: uuid){ (result) in
                switch result {
                case .success(let isFriend):
                    sender.isSelected = isFriend
                case .failure(let error):
                    GUItools.alert(GUItools.topMostVC!, strTitle: "Network error!", strBody: "\(error)")
                }
            }
        } else {
            BackEndOverlay.addToFriends(masterUUID: MyTogetherAccount.shared.uuid, friendUUID: uuid){ (result) in
                switch result {
                case .success(let isFriend):
                    sender.isSelected = isFriend
                case .failure(let error):
                    GUItools.alert(GUItools.topMostVC!, strTitle: "Network error!", strBody: "\(error)")
                }
            }
        }
    }
    @objc fileprivate func sendMessageToFriend(_ sender: UIButton) {
        print("SendMessageToFriend")
    }
}

extension FriendUserMainCell: UniCell {
    
    func setupCellProfile(_ profileData: CellAbstractData) {
        if let location = profileData["currentPhoneLocation"] as? Observable<CLLocation?> {
            self.currentPhoneLocation = location
        }
        if let rightViews = profileData["rightViews"] as? [UserCellAdditionalUItype] {
            addSubViews(to: mainHorizontalStack, viewTypes: rightViews)
        }
        if let bottomViews = profileData["bottomViews"] as? [UserCellAdditionalUItype]{
            addSubViews(to: mainVerticalStack, viewTypes: bottomViews)
        }
    }
    
    func setupCellData(_ cellData: CellAbstractData) {
        if let userUUID = cellData["userUUID"] as? String{
            BackEndOverlay.getUserDataByUUID(userUUID){ (result) in
                switch result {
                case .success(let uData):
                    self.userData.value = uData
                case .failure(let error):
                    print("Error loading user data! \(error)")
                }
            }
        }
        
    }
    
    func getCellData() -> CellAbstractData {
        return ["":0]
    }
}

