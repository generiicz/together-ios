//
//  HEDParticipantsCell.swift
//  Together
//
//  Created by Андрей Цай on 19.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import RxSwift

class HEDParticipantsCell: HEDUniCell {

    fileprivate var participants: [String] = [] {
        didSet {
            if participants.count > 0 {
                self.generateUserData(participants)
            }
        }
    }
    fileprivate var participantsData = Variable<[UserData]>([])
    fileprivate let cellIdentifier = "ParticipantCell"
    //fileprivate let disposeBag = DisposeBag()
    fileprivate let layoutMargin: CGFloat = 4
    
    @IBOutlet weak var participantsCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        participantsCollection.register(
            UINib(nibName: "HEDParticipantsCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ParticipantCell")
        participantsCollection.decelerationRate = UIScrollViewDecelerationRateFast
        participantsCollection.layer.shouldRasterize = true
        participantsCollection.layer.rasterizationScale = UIScreen.main.scale
        participantsData.asObservable()
            .filter{ $0.count > 0 }
            .bindTo(participantsCollection.rx.items(cellIdentifier: "ParticipantCell", cellType: HEDParticipantsCollectionViewCell.self))
            {row, data, cell in
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                cell.userData.value = data
            }
            .addDisposableTo(disposeBag)
    }
    
    override func displayEventData(event: EventData?) {
        if let eData = event, let participants = eData.participants {
            self.participants = participants
        }
    }
    
    fileprivate func getUserData(_ uuid: String) {
        print("Test uuid: \(uuid)")
    }
    
    fileprivate func setupLayoutHeight (_ height: CGFloat) {
        if let cLayout = participantsCollection.collectionViewLayout as? HorizontalLayout {
            let size: CGFloat = height - layoutMargin * 2 - 2
            cLayout.setupLayout(
                size,
                itemWidth: round(size * 0.55),
                horizontalPadding: layoutMargin,
                verticalPadding: layoutMargin,
                horizontalMargin: layoutMargin,
                verticalMargin: layoutMargin,
                pagingType: .truePaging)
            cLayout.invalidateLayout()
        }
    }
    
    fileprivate func generateUserData (_ uuids: [String]) {
        participantsData.value.removeAll()
        for uuid in uuids {
            BackEndOverlay.getUserDataByUUID(uuid){ result in
                switch result {
                case .success(let uData):
                    self.participantsData.value.append(uData)
                case .failure(let error):
                    print("load user data error\n\(error)")
                }
            }
        }
    }
    
    func setupCellProfile(_ profileData: CellAbstractData) {
        if let height = profileData["itemHeight"] as? CGFloat {
            setupLayoutHeight(height)
        }
    }
}
/*
extension HEDParticipantsCell: UniCell {
    
    func setupCellProfile(_ profileData: CellAbstractData) {
        if let height = profileData["itemHeight"] as? CGFloat {
            setupLayoutHeight(height)
        }
    }
    
    func setupCellData(_ cellData: CellAbstractData) {
        if let participants = cellData["participants"] as? [String] {
            self.participants =  participants
        }
    }
}*/
