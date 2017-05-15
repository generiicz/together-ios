//
//  UIImageExtensions.swift
//  Together
//
//  Created by Андрей Цай on 07.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import CoreLocation
import AlamofireImage

extension UIImageView {
    func setTemplateRenderingModeImage(_ image: UIImage) {
        self.image = image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    }
    
    func setStaticGoogleMap(location: CLLocationCoordinate2D, placeholderImage: UIImage, upscale: CGFloat = 2.2, zoom: Int = 19, googleScale: Int = 1, placeMarker: Bool = true) {
        let googleSize = GUItools.calcGoogleMapImageSize(size: self.frame.size, upscale: upscale)
        let imageURL = BackEndOverlay.makeGoogleStaticMapURL(
            location.latitude,
            longitude: location.longitude,
            width: Int(googleSize.width),
            height: Int(googleSize.height),
            zoom: zoom,
            scale: googleScale,
            placeMarker: placeMarker
        )
        let imageFilter  = AspectScaledToFillSizeFilter(size: self.frame.size)
        self.af_setImage(
            withURL: imageURL,
            placeholderImage: UIImage(named: "Synchronize")!,
            filter: imageFilter,
            progressQueue: DispatchQueue.global(qos: .background)
        )
    }
    
}
