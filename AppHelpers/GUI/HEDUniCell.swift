//
//  HEDUniCell.swift
//  Together
//
//  Created by Андрей Цай on 01.11.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import RxSwift

class HEDUniCell: UITableViewCell {
    
    internal let disposeBag = DisposeBag()
    internal var subscribed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func displayEventData(event: EventData?){
    }
}

extension HEDUniCell: UniCell {
    
    func setupCellData(_ cellData: CellAbstractData) {
        guard !subscribed else { return }
        if let eventVar = cellData["event"] as? Variable<EventData?> {
            eventVar.asObservable()
                .filter{ $0 != nil}
                .subscribe(onNext: displayEventData)
                .addDisposableTo(disposeBag)
            subscribed = true
        }
    }
}
