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
    var nextButtonNormalHeight: CGFloat = 80
    var inputTableSized = false

    @IBOutlet weak var inputTableView: UITableView!
    @IBOutlet weak var NextPageButton: PrettyButton!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var BottomConstraint: NSLayoutConstraint!
    
    fileprivate var firstName: String?
    fileprivate var secondName: String?
    fileprivate var email: String?
    
    @IBAction func NextPageAction(_ sender: UIButton) {
        guard let firstName = firstName, let secondName = secondName, let email = email else {
            GUItools.alert(self, strTitle: "Incorrect Field!", strBody: "Not valid name or email")
            return
        }
        
        self.parentMaster.save(name: "\(firstName) \(secondName)", email: email)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePretty()
        inputTableView.dataSource = self
        let uParams = UnderlineTextFieldParams(
            color: UIColor.clear,
            width: 1,
            enabled: true)
        let iField1 = InputCellData(
            cellClass: InputCell2.self,
            title: "First Name",
            underline: uParams,
            observer: self.firstValidator,
            setupClosure: nil
        )
        let iField2 = InputCellData(
            cellClass: InputCell2.self,
            title: "Last Name",
            underline: uParams,
            observer: self.secondValidator,
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
            inputTableView.rowHeight = nextButtonNormalHeight
            inputTableSized = true
        }
        
    }
    
    override func animateKeyboard(_ duration: TimeInterval, options: UIViewAnimationOptions, keyboardHeight: CGFloat, shouldShow shown: Bool) {
        BottomConstraint.constant = shown ? self.bottomConstraintNormalValue : keyboardHeight * 0.6 + self.keyboardBottomConstraint
        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func firstValidator(_ text: String?) {
        print("Name: \(text)")
        firstName = text
    }
    
    func secondValidator(_ text: String?) {
        print("Name: \(text)")
        secondName = text
    }
    
    func emailValidator(_ text: String?) {
        print("Email: \(text)")
        email = text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    fileprivate func makePretty(){
        keyboardBottomConstraint = -35
        TitleLabel.addCharactersSpacing(1.5)
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
