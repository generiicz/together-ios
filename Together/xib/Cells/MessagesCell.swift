//
//  MessagesCell.swift
//  Together
//
//  Created by Андрей Цай on 01.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class MessagesCell: UITableViewCell {
    
    fileprivate let messageCutLevel: Int = 20
    
    @IBOutlet fileprivate weak var userPhoto: RoundImage!
    @IBOutlet fileprivate weak var userNameLabel: UILabel!
    @IBOutlet fileprivate weak var lastMessageLabel: UILabel!
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var authorLabel: UILabel!
    
    func loadData(_ message: MessageData){
        userPhoto.image = UIImage(named: "StandardAvatar")
        let cuuuid = MyTogetherAccount.shared.uuid
        let userUUID = message.from == cuuuid ? message.to : message.from
        BackEndOverlay.getUserDataByUUID(userUUID) { result in
            switch result {
            case .success(let uData):
                self.userNameLabel.text = "\(uData.firstName) \(uData.lastName)"
                self.timeLabel.text = message.time.displayDate(
                    "en_US",
                    dateStyle: .none,
                    timeStyle: .short
                )
                self.lastMessageLabel.text = message.text.characters.count > self.messageCutLevel ? message.text.substring(to: message.text.index(message.text.startIndex, offsetBy: self.messageCutLevel)) : message.text
                if message.from != cuuuid {
                    self.authorLabel.text = "\(uData.firstName):"
                }
                BackEndOverlay.getImageWithUUID(uData.photoUUID) { result in
                    switch result {
                    case .success(let image):
                        self.userPhoto.image = image.af_imageAspectScaled(toFill: self.userPhoto.frame.size)
                    case .failure(let error):
                        print("Error loading user photo \(error)")
                    }
                }
            case .failure(let error):
                print("Error loading user data! \(error)")
            }
        }
    }
}
