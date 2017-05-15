//
//  DateTimeRangeCell.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class DateTimeRangeCell: UITableViewCell {
    
    var editDateVC: DateTimeSelectViewController!
    fileprivate var editDateMode: UIDatePickerMode = .dateAndTime {
        didSet{
            switch editDateMode {
            case .dateAndTime:
                editDateVC.pickTitle = "Please Select Date and Time"
            case .date:
                editDateVC.pickTitle = "Please Select Date"
            case .time:
                editDateVC.pickTitle = "Please Select Time"
            default:
                editDateVC.pickTitle = "Please Select Date and Time"
            }
            editDateVC.pickMode = self.editDateMode
        }
    }
    fileprivate var fromDate: Date?
    fileprivate var toDate: Date?
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var FromButton: UIButton!
    @IBOutlet weak var ToButton: UIButton!
    @IBOutlet weak var FromDateLabel: UILabel!
    @IBOutlet weak var ToDateLabel: UILabel!
    
    @IBAction func FromEditAction(_ sender: UIButton) {
        editDateVC.date = fromDate ?? Date()
        editDateVC.completion = {(date) in
            self.setFromDate(date as Date)
        }
        if let rootVC = GUItools.topMostVC {
            editDateVC.showView(rootVC, animated: true)
        }
    }
    
    @IBAction func ToEditAction(_ sender: UIButton) {
        editDateVC.date = toDate ?? Date()
        editDateVC.completion = {(date) in
            self.setToDate(date as Date)
        }
        if let rootVC = GUItools.topMostVC {
            editDateVC.showView(rootVC, animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editDateVC = DateTimeSelectViewController(nibName: "DateTimeSelectViewController", bundle: nil)
    }
    
    fileprivate func getDateStringForMode(_ mode: UIDatePickerMode, date: Date) -> String{
        switch mode {
        case .dateAndTime:
            return date.displayDate("en_US", dateStyle: .short, timeStyle: .short)
        case .date:
            return date.displayDate("en_US", dateStyle: .short, timeStyle: .none)
        case .time:
            return date.displayDate("en_US", dateStyle: .none, timeStyle: .short)
        default:
            return date.displayDate("en_US", dateStyle: .short, timeStyle: .short)
        }
    }
    
    fileprivate func setFromDate(_ date: Date){
        self.fromDate = date
        self.FromDateLabel.text = self.getDateStringForMode(self.editDateMode, date: date)
    }
    
    fileprivate func setToDate(_ date: Date){
        self.toDate = date
        self.ToDateLabel.text = self.getDateStringForMode(self.editDateMode, date: date)
    }

}

extension DateTimeRangeCell: UniCell {
    
    func setupCellProfile(_ profileData: CellAbstractData) {
        if let editMode = profileData["EditMode"] as? Int {
            self.editDateMode = UIDatePickerMode(rawValue: editMode) ?? UIDatePickerMode.dateAndTime
        }
    }

    func setupCellData(_ cellData: CellAbstractData) {
        self.titleLabel.text = cellData["Title"] as? String
        if let iFromDate = cellData["FromDate"] as? Date {
            setFromDate(iFromDate)
        } else {
            setFromDate(Date())
        }
        if let iToDate = cellData["ToDate"] as? Date{
            setToDate(iToDate)
        } else {
            setToDate(Date())
        }
    }
    
    func getCellData() -> CellAbstractData {
        guard let fromDate = self.fromDate else { return [:] }
        guard let toDate = self.toDate else { return [:] }
        return [
            "FromDate": fromDate,
            "ToDate": toDate
        ]
    }
}

