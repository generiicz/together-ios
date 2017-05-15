//
//  LaunchNavController.swift
//  Together
//
//  Created by Андрей Цай on 17.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class LaunchNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.makePretty()
        
        if Defaults[.firstStart] {
            performSegue(withIdentifier: "WelcomeSegue", sender: self)
        } else {
            performSegue(withIdentifier: "SignInSegue", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate func makePretty() {
        // removing the hairline
        self.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationBar.shadowImage = UIImage()
        
        self.navigationBar.barTintColor = UIColor.white // bar background color
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.lightGray
        
        let font = UIFont(name: TogetherFontNames.SFUIDisplayMedium, size: 20)!
        let titleAttributes = [ NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : font ]
        
        self.navigationBar.titleTextAttributes = titleAttributes
    }

}
