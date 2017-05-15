//
//  DateTimeSelectViewController.swift
//  Together
//
//  Created by Андрей Цай on 06.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class DateTimeSelectViewController: UIViewController {
    
    var completion: ((Date) -> Void)?
    var date: Date = Date()
    var pickTitle: String = "Please enter Date and Time"
    var pickMode: UIDatePickerMode = .dateAndTime
    var showed: Bool = false
    fileprivate let heightMultiplier: CGFloat = 7 / 16
    

    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var SetButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func SetAction(_ sender: UIButton) {
        dismiss(animated: true){() in
            if let callback = self.completion {
                callback(self.DatePicker.date)
            }
        }
    }
    
    @IBAction func CancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.applySetupData()
        self.transitioningDelegate = self
    }
    
    fileprivate func applySetupData(){
        TitleLabel.text = self.pickTitle
        DatePicker.datePickerMode = self.pickMode
        DatePicker.date = self.date
    }
    
    func showView(_ rootVC: UIViewController, animated: Bool){
        
        rootVC.definesPresentationContext = true
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        guard let presentController = self.presentationController else { return }
        presentController.setNeedsFocusUpdate()
        rootVC.present(self, animated: true, completion: nil)
    }
}

extension DateTimeSelectViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                                            presenting: UIViewController?,
                                                                                     source: UIViewController) -> UIPresentationController? {
        let presController = KeyboardusPresentusExtraordinaris(presentedViewController: presented, presenting: presenting)
        presController.heightMultiplier = heightMultiplier
        return presController
    }

}

