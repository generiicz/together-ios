//
//  AccountCreateMasterFirstViewController.swift
//  Together
//
//  Created by Андрей Цай on 05.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import RxSwift

class AccountCreateMasterFirstViewController: KeyboardableViewController, InputViewController, AccountMasterPage {
    
    weak var parentMaster: AccountMasterPageViewController!
    var inputFields: [InputTableCell] = []
    var inputFieldsData: [InputCellData] = []
    var bottomConstraintNormalValue: CGFloat = 8
    var topConstraintNormalValue: CGFloat = 8
    var middleConstraintNormalValue: CGFloat = 8
    var nextButtonNormalHeight: CGFloat = 42
    var inputTableSized = false

    @IBOutlet weak var inputTableView: UITableView!
    @IBOutlet weak var NextPageButton: PrettyButton!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var TopConstraint: NSLayoutConstraint!
    @IBOutlet weak var MiddleConstraint: NSLayoutConstraint!
    
    @IBAction func NextPageAction(_ sender: UIButton) {
        self.parentMaster.nextPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
        inputTableView.dataSource = self
        let uParams = UnderlineTextFieldParams(
            color: UIColor.grayColor(192),
            width: 1,
            enabled: true)
        let iField1 = InputCellData(
            cellClass: InputCell2.self,
            title: "First Name",
            underline: uParams,
            observer: self.nameValidator,
            setupClosure: nil
        )
        let iField2 = InputCellData(
            cellClass: InputCell2.self,
            title: "Last Name",
            underline: uParams,
            observer: self.nameValidator,
            setupClosure: nil
        )
        let iField3 = InputCellData(
            cellClass: InputCell2.self,
            title: "Email",
            underline: uParams,
            observer: self.emailValidator,
            setupClosure: nil
        )
        inputFieldsData = [iField1, iField2, iField3]
        setupInputViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !inputTableSized {
            inputTableView.rowHeight = ceil((inputTableView.frame.height - inputTableView.frame.height * 0.2) / CGFloat(inputFields.count))
            inputTableSized = true
        }
        
    }
    
    override internal func setNormalConstraints() {
        self.bottomConstraintNormalValue = self.BottomConstraint.constant
        self.topConstraintNormalValue = self.TopConstraint.constant
        MiddleConstraint.constant = view.frame.height / 2 - TopConstraint.constant - 133
        middleConstraintNormalValue = MiddleConstraint.constant
        nextButtonNormalHeight = NextPageButton.frame.height
    }
    
    override func animateKeyboard(_ duration: TimeInterval, options: UIViewAnimationOptions, keyboardHeight: CGFloat, shouldShow shown: Bool) {
        //print(keyboardHeight)
        TopConstraint.constant = shown ? self.topConstraintNormalValue : 10
        MiddleConstraint.constant = shown ? middleConstraintNormalValue : 10
        BottomConstraint.constant = shown ? self.bottomConstraintNormalValue : keyboardHeight + self.keyboardBottomConstraint
        let labelHidden = !shown
        self.view.setNeedsLayout()
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {[weak self] in
                self?.TitleLabel.isHidden = labelHidden
                self?.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    func nameValidator(_ text: String){
        print("Name: \(text)")
    }
    
    func emailValidator(_ text: String){
        print("Email: \(text)")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    fileprivate func makePretty(){
        keyboardBottomConstraint = -35
        TitleLabel.addCharactersSpacing(2.5)
        NextPageButton.loadStatesProfile(TogetherPrettyButtonProfiles.BlueLoginButton)
        inputTableView.allowsSelection = false
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = inputFields[(indexPath as NSIndexPath).row] as! UITableViewCell
        return cell
    }

}
