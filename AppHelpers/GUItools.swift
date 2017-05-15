//
//  GUItools.swift
//  Together
//
//  Created by Андрей Цай on 07.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

struct GUItools {
    
    static var topMostVC: UIViewController? {
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            print("Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
        }
        return presentedVC
    }
    
    static func iconicImage(_ named: String) -> UIImage? {
        let res = UIImage(named: named)
        return res?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    }
    
    static func popupViewController(_ parentVC: UIViewController, popupVC: UIViewController, popupBkgndColor: UIColor, insetX: CGFloat, insetY: CGFloat, animated: Bool) {
        let newBounds = UIScreen.main.bounds.insetBy(dx: insetX, dy: insetY)
        popupVC.preferredContentSize = CGSize(width:  newBounds.width, height:  newBounds.height)
        popupVC.view.backgroundColor = popupBkgndColor
        popupVC.modalPresentationStyle = .popover
        guard let popController = popupVC.popoverPresentationController else { return }
        popController.permittedArrowDirections = .any
        popController.sourceView = parentVC.view
        popController.sourceRect = CGRect(
            x: parentVC.view.bounds.origin.x+insetX/2,
            y: parentVC.view.bounds.origin.y+insetY/2,
            width: 1,
            height: 1)
        parentVC.present(popupVC, animated: animated, completion:nil)
    }
        
    static func alert(_ parentVC: UIViewController, strTitle: String, strBody: String, actionTitle: String = "OK", animated: Bool = true) {
        let alert = UIAlertController(
            title: strTitle,
            message: strBody,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let alertAction = UIAlertAction(
            title: actionTitle,
            style: UIAlertActionStyle.default){(action) in
                alert.dismiss(animated: animated, completion: nil)
        }
        alert.addAction(alertAction)
        parentVC.present(alert, animated: animated, completion: nil)
    }
    
    static func enumerateFonts() {
        for fontFamily in UIFont.familyNames {
            print("Font family name = \(fontFamily as String)")
            for fontName in UIFont.fontNames(forFamilyName: fontFamily as String) {
                print("- Font name = \(fontName)")
            }
            print("\n")
        }
    }
    
    static func calcGoogleMapImageSize(size: CGSize, upscale: CGFloat) -> CGSize {
        let imageWidth = size.width * upscale <= 640 ? size.width * upscale : 640
        let imageHeight = size.height * upscale <= 640 ? size.height * upscale : 640
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
}
