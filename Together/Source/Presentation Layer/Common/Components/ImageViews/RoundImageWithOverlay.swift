//
//  RoundImageWithOverlay.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class RoundImageWithOverlay: UIImageView {
    
    fileprivate var overlayImageView: UIImageView?
    fileprivate var _overlayImage: UIImage?
    fileprivate var overlayGestRec: UIGestureRecognizer?
    fileprivate var notificationParams: TogetherNotificationParameters!
    
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
    
    fileprivate func updateUI(){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width/2
        self.lineupOverlay()
    }
    
    fileprivate func updateOverlay(){
        if self.overlayImageView == nil {
            self.setupOverlay()
        } else {
            lineupOverlay()
            self.overlayImageView?.image = self._overlayImage
        }
        
    }
    
    fileprivate func setupOverlay(){
        self.overlayImageView = UIImageView(image: self.overlayImage)
        self.overlayImageView!.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.overlayImageView!.contentMode = .center
        self.lineupOverlay()
        self.addSubview(self.overlayImageView!)
        self.bringSubview(toFront: self.overlayImageView!)
    }
    
    fileprivate func lineupOverlay(){
        self.overlayImageView?.frame.origin.x = 0
        self.overlayImageView?.frame.origin.y = 0
        self.overlayImageView?.frame.size = super.bounds.size
    }
    
    @objc fileprivate func sendTapNotification(){
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: self.notificationParams.notificationType),
            object: self,
            userInfo: self.notificationParams.notificationUserDictionary
        )
    }
    
    func addTap(_ params: TogetherNotificationParameters){
        self.notificationParams = params
        guard self.overlayImageView != nil else {
            return
        }
        if !self.overlayImageView!.isUserInteractionEnabled {
            self.overlayImageView!.isUserInteractionEnabled = true
        }
        if self.overlayGestRec == nil {
            self.overlayGestRec = UITapGestureRecognizer(target: self, action: #selector(self.sendTapNotification))
            self.overlayImageView!.addGestureRecognizer(self.overlayGestRec!)
        }
    }
}
