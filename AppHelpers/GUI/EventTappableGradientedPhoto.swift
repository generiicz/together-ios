//
//  EventTappableGradientedPhoto.swift
//  Together
//
//  Created by Андрей Цай on 31.10.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class EventTappableGradientedPhoto: GradientedImage, AddTapNotification {
    internal var tapRec: UIGestureRecognizer?
    internal var selectron: TapSelectron!
}
