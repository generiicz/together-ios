//
//  InputViewController.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import RxSwift

struct UnderlineTextFieldParams {
    var color: UIColor
    var width: CGFloat
    var enabled: Bool
}

struct InputCellData {
    var cellClass: InputTableCell.Type
    var title: String
    var underline: UnderlineTextFieldParams?
    var observer: (_ text: String?) -> Void
    var setupClosure: ((_ cell: InputTableCell) -> Void)?
}

struct inputCell {
    var cellData: InputCellData
    var cellObj: InputTableCell
}

// TODO: refactor this to TableViewDataSource
protocol InputViewController: class, UITableViewDataSource  {
    
    weak var inputTableView: UITableView! { get set }
    
    var inputFieldsData: [InputCellData] { get set }
    
    var inputFields: [InputTableCell] { get set }
    
    var disposeBag: DisposeBag { get set }
}

extension InputViewController where Self: UIViewController {
    
    func addCellWithValidator(_ cellData: InputCellData) {
        let cell = cellData.cellClass.loadCellFromNib()
        cell.setupInputCell(cellData.title, underline: cellData.underline, setupClosure: cellData.setupClosure)
        let obs = cell.inputTextField.rx.textInput.text
            .distinctUntilChanged({ _,_ in
                return false
            })
            //.throttle(0.5, scheduler: MainScheduler.instance)
        obs.subscribe(onNext: cellData.observer).addDisposableTo(disposeBag)
        inputFields.append(cell)
    }
    
    func generateInputFields() {
        inputFields = []
        for fieldData in inputFieldsData {
            addCellWithValidator(fieldData)
        }
    }
    
    func setupInputViewController(){
        generateInputFields()
        
    }
    
}
