//
//  HEDParticipantsCollectionViewCell.swift
//  Together
//
//  Created by Андрей Цай on 19.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import RxSwift

class HEDParticipantsCollectionViewCell: UICollectionViewCell {
    
    var userData = Variable<UserData?>(nil)
    fileprivate let disposeBag = DisposeBag()

    @IBOutlet weak var participantPhoto: RoundImage!
    @IBOutlet weak var participantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userData.asObservable()
            .filter{ $0 != nil}
            .subscribe(onNext: self.displayUserData)
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func displayUserData(_ uData: UserData?) {
        print("\npartCollectionViewCell: \(uData!)")
        participantName.text = "\(uData!.firstName) \(uData!.lastName)"
        BackEndOverlay.getImageWithUUID(uData!.photoUUID){ result in
            switch result {
            case .success(let image):
                self.participantPhoto.image = image
            case .failure(let error):
                print("Error get creator photo\n\(error)")
            }
        }
    }

}
