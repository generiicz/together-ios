//
//  ViewController.swift
//  Together
//
//  Created by Андрей Цай on 23.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setBackgroundImage (_ image: UIImage) -> UIImageView {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = image
        self.view.insertSubview(imageView, at: 0)
        return imageView
    }
}





