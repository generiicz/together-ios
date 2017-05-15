//
//  HEDCreatorCell.swift
//  Together
//
//  Created by Андрей Цай on 17.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class HEDCreatorCell: HEDUniCell {
    @IBOutlet weak var creatorPhoto: RoundImage!
    @IBOutlet weak var creatorName: UILabel!
    
    fileprivate var creatorData: UserData? {
        didSet{
            guard let creatorData = creatorData else { return }
            creatorName.text = "\(creatorData.firstName) \(creatorData.lastName)"
            BackEndOverlay.getImageWithUUID(creatorData.photoUUID){ result in
                switch result {
                case .success(let image):
                    self.creatorPhoto.image = image
                case .failure(let error):
                    print("Error get creator photo\n\(error)")
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func displayEventData(event: EventData?) {
        if let eData = event {
            //TODO: load user info
//            fetchUserData(eData.creator)
        }
    }
    
    fileprivate func fetchUserData(_ uuid: String) {
        BackEndOverlay.getUserDataByUUID(uuid){ result in
            switch result {
            case .success(let uData):
                self.creatorData = uData
            case .failure(let error):
                print("Error get creator photo\n\(error)")
            }
        }
    }
    
}
/*
extension HEDCreatorCell: UniCell {
    func setupCellData(_ cellData: CellAbstractData) {
        if let creatorUUID = cellData["creatorUUID"] as? String {
            fetchUserData(creatorUUID)
        }
    }
}*/
