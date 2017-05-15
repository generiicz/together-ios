//
//  PoppingUpViewController.swift
//  Together
//
//  Created by Андрей Цай on 12.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

enum ArrowPoints {
    case top
    case right
    case bottom
    case left
}

class PoppingUpViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    fileprivate func popupPrepare() -> UIPopoverPresentationController? {
        self.modalPresentationStyle = .popover
        let popController = self.popoverPresentationController
        return popController
    }
    
    func popupViewControllerWithInlets(_ parentVC: UIViewController, popupBkgndColor: UIColor, insetX: CGFloat, insetY: CGFloat, animated: Bool = true) {
        var newBounds = CGRect()
        if parentVC is UITableViewController {
            newBounds = (parentVC as! UITableViewController).tableView.frame.insetBy(dx: insetX, dy: insetY)
        } else {
            newBounds = parentVC.view.frame.insetBy(dx: insetX, dy: insetY)
        }
        self.preferredContentSize = CGSize(width:  newBounds.width, height:  newBounds.height)
        self.view.backgroundColor = popupBkgndColor
        guard let popController = popupPrepare() else { return }
        popController.delegate = self
        popController.permittedArrowDirections = .any
        popController.sourceView = parentVC.view
        popController.sourceRect = CGRect(
            x: parentVC.view.bounds.origin.x+insetX/2,
            y: parentVC.view.bounds.origin.y+insetY/2,
            width: 1,
            height: 1)
        parentVC.present(self, animated: animated, completion:nil)
    }
    
    internal func calcSourceRect(_ frame: CGRect, arrowPoint: ArrowPoints, arrowLength: CGFloat) -> CGRect {
        var res = CGRect(x: 0, y: 0, width: 1, height: 1)
        switch arrowPoint {
        case .top:
            res.origin.x = frame.origin.x + round(frame.width / 2)
            res.origin.y = frame.origin.y - arrowLength
        case .right:
            res.origin.x = frame.origin.x + frame.width + arrowLength
            res.origin.y = frame.origin.y + round(frame.height / 2)
        case .bottom:
            res.origin.x = frame.origin.x + round(frame.width / 2)
            res.origin.y = frame.origin.y + frame.height + arrowLength
        case .left:
            res.origin.x = frame.origin.x - arrowLength
            res.origin.y = frame.origin.y - round(frame.height / 2)
        }
        return res
    }
    
    func popupViewControllerWithFrame(_ parentVC: UIViewController, frame: CGRect, popupBkgndColor: UIColor, arrowPoint: ArrowPoints, arrowLength: CGFloat = 10, animated: Bool = true){
        self.preferredContentSize = CGSize(width: frame.width, height: frame.height)
        self.view.backgroundColor = popupBkgndColor
        guard let popController = popupPrepare() else { return }
        popController.delegate = self
        popController.permittedArrowDirections = .any
        popController.sourceView = parentVC.view
        popController.sourceRect = calcSourceRect(frame, arrowPoint: arrowPoint, arrowLength: arrowLength)
        parentVC.present(self, animated: animated, completion:nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

