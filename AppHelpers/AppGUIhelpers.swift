//
//  AppGUIhelpers.swift
//  Together
//
//  Created by Андрей Цай on 18.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation
import UIKit

struct drawPath{
    var lineWidth: CGFloat
    var lineColor: UIColor
    var pathPoints: [CGPoint]
}

extension UIButton {
    func addCharactersSpacing(spacing:CGFloat, state: UIControlState) {
        if let sourceText = self.attributedTitleForState(state){
            let attributedString = NSMutableAttributedString(attributedString: sourceText)
            attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, attributedString.mutableString.lowercaseString.characters.count-1))
            self.setAttributedTitle(attributedString, forState: state)
        }
    }
    
    func addUnderline(underlineType: Int, underlineColor: UIColor, state: UIControlState){
        if let sourceText = self.attributedTitleForState(state) {
            let attributedString = NSMutableAttributedString(attributedString: sourceText)
            let applyRange = NSMakeRange(0, attributedString.mutableString.lowercaseString.characters.count-1)
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: underlineType, range: applyRange)
            attributedString.addAttribute(NSUnderlineColorAttributeName, value: underlineColor, range: applyRange)
            self.setAttributedTitle(attributedString, forState: state)
        }
    }
}

extension UILabel {
    func addCharactersSpacing(spacing:CGFloat) {
        if let sourceText = self.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: sourceText)
            attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, attributedString.mutableString.lowercaseString.characters.count-1))
            self.attributedText = attributedString
        }
    }
    
    func addUnderline(underlineType: Int, underlineColor: UIColor){
        if let sourceText = self.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: sourceText)
            let applyRange = NSMakeRange(0, attributedString.mutableString.lowercaseString.characters.count-1)
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: underlineType, range: applyRange)
            attributedString.addAttribute(NSUnderlineColorAttributeName, value: underlineColor, range: applyRange)
            self.attributedText = attributedString
        }
    }
}

extension UIViewController {
    
    func setBackgroundImage (image: UIImage) -> UIImageView {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = image
        self.view.insertSubview(imageView, atIndex: 0)
        return imageView
    }
    
}

class drawingView: UIView {
    
    private var drawPaths: [drawPath]?
    
    func addDrawPath(path: drawPath){
        if self.drawPaths == nil {
            self.drawPaths = [drawPath]()
        }
        self.drawPaths?.append(path)
        //self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        guard self.drawPaths != nil else {return}
        for dPath in self.drawPaths! {
            let bPath = UIBezierPath()
            bPath.lineWidth = dPath.lineWidth
            dPath.lineColor.setStroke()
            //UIColor.blackColor().setStroke()
            for i in 0...dPath.pathPoints.count - 1 {
                if i == 0 {
                    bPath.moveToPoint(dPath.pathPoints[i])
                } else {
                    bPath.addLineToPoint(dPath.pathPoints[i])
                }
            }
            bPath.stroke()
        }
    }
}

class RoundImageWithOverlay: UIImageView {
    
    private var overlayImageView: UIImageView?
    private var _overlayImage: UIImage?
    private var overlayGestRec: UIGestureRecognizer?
    private var notificationParams: TogetherNotificationParameters!
    
    var overlayImage: UIImage? {
        get{ return self._overlayImage }
        set {
            self._overlayImage = newValue
            self.updateOverlay()
        }
    }
    
    override var image: UIImage? {
        get { return super.image }
        set {
            super.image = newValue
            self.updateUI()
        }
    }
    
    override var bounds: CGRect {
        get { return super.bounds }
        set {
            super.bounds = newValue
            self.updateUI()
        }
    }
    
    private func updateUI(){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width/2
        self.lineupOverlay()
    }
    
    private func updateOverlay(){
        if self.overlayImageView == nil {
            self.setupOverlay()
        } else {
            lineupOverlay()
            self.overlayImageView?.image = self._overlayImage
        }
        
    }
    
    private func setupOverlay(){
        self.overlayImageView = UIImageView(image: self.overlayImage)
        self.overlayImageView!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        self.overlayImageView!.contentMode = .Center
        self.lineupOverlay()
        self.addSubview(self.overlayImageView!)
        self.bringSubviewToFront(self.overlayImageView!)
    }
    
    private func lineupOverlay(){
        self.overlayImageView?.frame.origin.x = 0
        self.overlayImageView?.frame.origin.y = 0
        self.overlayImageView?.frame.size = super.bounds.size
    }
    
    @objc private func sendTapNotification(){
        NSNotificationCenter.defaultCenter().postNotificationName(
            self.notificationParams.notificationType,
            object: self,
            userInfo: self.notificationParams.notificationUserDictionary
        )
    }
    
    func addTap(params: TogetherNotificationParameters){
        self.notificationParams = params
        guard self.overlayImageView != nil else {
            return
        }
        if !self.overlayImageView!.userInteractionEnabled {
            self.overlayImageView!.userInteractionEnabled = true
        }
        if self.overlayGestRec == nil {
            self.overlayGestRec = UITapGestureRecognizer(target: self, action: #selector(self.sendTapNotification))
            self.overlayImageView!.addGestureRecognizer(self.overlayGestRec!)
        }
    }
}

class RoundImage: UIImageView {
    
    private var gestRec: UIGestureRecognizer?
    private var notificationParams: TogetherNotificationParameters!
    
    private func updateUI (){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width/2
    }
    
    override var bounds: CGRect {
        get { return super.bounds }
        set {
            super.bounds = newValue
            self.updateUI()
        }
    }
    
    @objc private func sendTapNotification(){
        NSNotificationCenter.defaultCenter().postNotificationName(
            self.notificationParams.notificationType,
            object: self,
            userInfo: self.notificationParams.notificationUserDictionary
        )
    }
    
    func addTap(params: TogetherNotificationParameters){
        self.notificationParams = params
        if !self.userInteractionEnabled {
            self.userInteractionEnabled = true
        }
        if self.gestRec == nil {
            self.gestRec = UITapGestureRecognizer(target: self, action: #selector(self.sendTapNotification))
            self.addGestureRecognizer(self.gestRec!)
        }
    }
}
