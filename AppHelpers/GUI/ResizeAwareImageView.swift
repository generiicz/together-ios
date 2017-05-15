//
//  ResizeAwareImageView.swift
//  Together
//
//  Created by Андрей Цай on 29.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

protocol ResizeAwareImageViewDelegate {
    func imageViewResized(imageView: ResizeAwareImageView, newSize: CGRect)
}

class ResizeAwareImageView: UIImageView {

    var resizingDelegate: ResizeAwareImageViewDelegate?
    
    override var bounds: CGRect {
        get{
            return super.bounds
        }
        set{
            super.bounds = newValue
            if self.resizingDelegate != nil {
                self.resizingDelegate?.imageViewResized(imageView: self, newSize: self.bounds)
            }
        }
    }

}
