//
//  GUIdata.swift
//  Together
//
//  Created by Андрей Цай on 02.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

struct TogetherFontNames {
    static let SFUIDisplayBlack = "SFUIDisplay-Black"
    static let SFUIDisplaySemibold = "SFUIDisplay-Semibold"
    static let SFUIDisplayThin = "SFUIDisplay-Thin"
    static let SFUIDisplayLight = "SFUIDisplay-Light"
    static let SFUIDisplayRegular = "SFUIDisplay-Regular"
    static let SFUIDisplayBold = "SFUIDisplay-Bold"
    static let SFUIDisplayUltralight = "SFUIDisplay-Ultralight"
    static let SFUIDisplayMedium = "SFUIDisplay-Medium"
    static let SFUIDisplayHeavy = "SFUIDisplay-Heavy"
}

struct TogetherColors {
    static let BlueButtonDefault = UIColor.colorFromRGB(51, green: 176, blue: 255, alpha: 255)
    static let BlueButtonDark = UIColor.colorFromRGB(61, green: 186, blue: 255, alpha: 255)
    static let BlueTwitter = UIColor.colorFromRGB(0, green: 171, blue: 241, alpha: 255)
    static let BlueTwitterDark = UIColor.colorFromRGB(10, green: 181, blue: 251, alpha: 255)
    static let BlueFacebook = UIColor.colorFromRGB(58, green: 88, blue: 158, alpha: 255)
    static let BlueFacebookDark = UIColor.colorFromRGB(68, green: 98, blue: 168, alpha: 255)
    static let RedMain = UIColor.colorFromRGB(236, green: 72, blue: 72, alpha: 255)
    static let RedMainDark = UIColor.colorFromRGB(246, green: 82, blue: 82, alpha: 255)
    static let GrayFontDark = UIColor.colorFromRGB(86, green: 90, blue: 92, alpha: 255)
}

struct ButtonParameters {
    // These properties should be immutable (lets)
    var backgroundColor: UIColor
    var titleBackgroundColor: UIColor
    var fontColor: UIColor
    var borderColor: UIColor
    var borderWidth: CGFloat
    var cornerRadius: CGFloat
    var charactersSpacing: CGFloat
    var underlineStyle: NSUnderlineStyle
    var underlineColor: UIColor
    
    init(
        backgroundColor: UIColor,
        titleBackgroundColor: UIColor,
        fontColor: UIColor,
        cornerRadius: CGFloat = 0,
        charactersSpacing: CGFloat = 0,
        underlineStyle: NSUnderlineStyle = .styleNone,
        underlineColor: UIColor = UIColor.black,
        borderColor: UIColor = UIColor.black,
        borderWidth: CGFloat = 0
        ){
        self.backgroundColor = backgroundColor
        self.titleBackgroundColor = titleBackgroundColor
        self.fontColor = fontColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.charactersSpacing = charactersSpacing
        self.underlineStyle = underlineStyle
        self.underlineColor = underlineColor
    }
}

struct TogetherPrettyButtonProfiles {
    static let BlueLoginButton: [UInt: ButtonParameters] = [
        UIControlState().rawValue: ButtonParameters(
            backgroundColor: TogetherColors.BlueButtonDefault,
            titleBackgroundColor: TogetherColors.BlueButtonDefault,
            fontColor: UIColor.white,
            cornerRadius: 2,
            charactersSpacing: 1.5),
        UIControlState.disabled.rawValue: ButtonParameters(
            backgroundColor: UIColor.grayColor(198),
            titleBackgroundColor: UIColor.grayColor(198),
            fontColor: UIColor.grayColor(178),
            cornerRadius: 2,
            charactersSpacing: 1.5),
        UIControlState.highlighted.rawValue: ButtonParameters(
            backgroundColor: TogetherColors.BlueButtonDark,
            titleBackgroundColor: TogetherColors.BlueButtonDark,
            fontColor: UIColor.white,
            cornerRadius: 2,
            charactersSpacing: 1.5)
    ]
    static let BlueBorderedButton: [UInt: ButtonParameters] = [
        UIControlState().rawValue: ButtonParameters(
            backgroundColor: UIColor.white,
            titleBackgroundColor: UIColor.white,
            fontColor: TogetherColors.BlueButtonDefault,
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: TogetherColors.BlueButtonDefault,
            borderWidth: 2),
        UIControlState.highlighted.rawValue: ButtonParameters(
            backgroundColor: UIColor.lightGray,
            titleBackgroundColor: UIColor.lightGray,
            fontColor: TogetherColors.BlueButtonDefault,
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: TogetherColors.BlueButtonDefault,
            borderWidth: 2),
        UIControlState.disabled.rawValue: ButtonParameters(
            backgroundColor: UIColor.white,
            titleBackgroundColor: UIColor.white,
            fontColor: UIColor.grayColor(195),
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: UIColor.grayColor(195),
            borderWidth: 2),
        ]
    static func GrayLinkButton(_ grayGrade: Int) -> [UInt: ButtonParameters]{
        let darkerGray = grayGrade - 20 >= 0 ? grayGrade - 20 : 0
        let lighterGray = 198
        return [
            UIControlState().rawValue: ButtonParameters(
                backgroundColor: UIColor.clear,
                titleBackgroundColor: UIColor.clear,
                fontColor: UIColor.grayColor(grayGrade),
                underlineStyle: NSUnderlineStyle.styleSingle,
                underlineColor: UIColor.grayColor(grayGrade)),
            UIControlState.disabled.rawValue: ButtonParameters(
                backgroundColor: UIColor.clear,
                titleBackgroundColor: UIColor.clear,
                fontColor: UIColor.grayColor(lighterGray),
                underlineStyle: NSUnderlineStyle.styleSingle,
                underlineColor: UIColor.grayColor(lighterGray)),
            UIControlState.highlighted.rawValue: ButtonParameters(
                backgroundColor: UIColor.clear,
                titleBackgroundColor: UIColor.clear,
                fontColor: UIColor.grayColor(darkerGray),
                underlineStyle: NSUnderlineStyle.styleSingle,
                underlineColor: UIColor.grayColor(darkerGray))
        ]
    }
    static let MainGraySignInButton: [UInt: ButtonParameters] = [
        UIControlState().rawValue: ButtonParameters(
            backgroundColor: UIColor.white,
            titleBackgroundColor: UIColor.white,
            fontColor: UIColor.grayColor(61),
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: UIColor.grayColor(195),
            borderWidth: 2),
        UIControlState.highlighted.rawValue: ButtonParameters(
            backgroundColor: UIColor.lightGray,
            titleBackgroundColor: UIColor.lightGray,
            fontColor: UIColor.grayColor(61),
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: UIColor.grayColor(175),
            borderWidth: 2),
        UIControlState.disabled.rawValue: ButtonParameters(
            backgroundColor: UIColor.white,
            titleBackgroundColor: UIColor.white,
            fontColor: UIColor.grayColor(195),
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: UIColor.grayColor(195),
            borderWidth: 2),
    ]
    static let CreateButton: [UInt: ButtonParameters] = [
        UIControlState().rawValue: ButtonParameters(
            backgroundColor: UIColor.white,
            titleBackgroundColor: UIColor.white,
            fontColor: UIColor.grayColor(0),
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: UIColor.grayColor(0),
            borderWidth: 2),
        UIControlState.highlighted.rawValue: ButtonParameters(
            backgroundColor: UIColor.lightGray,
            titleBackgroundColor: UIColor.lightGray,
            fontColor: UIColor.grayColor(61),
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: UIColor.grayColor(175),
            borderWidth: 2),
        UIControlState.disabled.rawValue: ButtonParameters(
            backgroundColor: UIColor.white,
            titleBackgroundColor: UIColor.white,
            fontColor: UIColor.grayColor(195),
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: UIColor.grayColor(195),
            borderWidth: 2),
        ]
    static let TwitterLoginButton: [UInt: ButtonParameters] = [
        UIControlState().rawValue: ButtonParameters(
            backgroundColor: TogetherColors.BlueTwitter,
            titleBackgroundColor: TogetherColors.BlueTwitter,
            fontColor: UIColor.white,
            cornerRadius: 2,
            charactersSpacing: 1.5),
        UIControlState.highlighted.rawValue: ButtonParameters(
            backgroundColor: TogetherColors.BlueTwitterDark,
            titleBackgroundColor: TogetherColors.BlueTwitterDark,
            fontColor: UIColor.white,
            cornerRadius: 2,
            charactersSpacing: 1.5),
        UIControlState.disabled.rawValue: ButtonParameters(
            backgroundColor: UIColor.lightGray,
            titleBackgroundColor: UIColor.lightGray,
            fontColor: UIColor.darkGray,
            cornerRadius: 2,
            charactersSpacing: 1.5)
    ]
    static let FacebookLoginButton: [UInt: ButtonParameters] = [
        UIControlState().rawValue: ButtonParameters(
            backgroundColor: TogetherColors.BlueFacebook,
            titleBackgroundColor: TogetherColors.BlueFacebook,
            fontColor: UIColor.white,
            cornerRadius: 2,
            charactersSpacing: 1.5),
        UIControlState.highlighted.rawValue: ButtonParameters(
            backgroundColor: TogetherColors.BlueFacebookDark,
            titleBackgroundColor: TogetherColors.BlueFacebookDark,
            fontColor: UIColor.white,
            cornerRadius: 2,
            charactersSpacing: 1.5),
        UIControlState.disabled.rawValue: ButtonParameters(
            backgroundColor: UIColor.lightGray,
            titleBackgroundColor: UIColor.lightGray,
            fontColor: UIColor.darkGray,
            cornerRadius: 2,
            charactersSpacing: 1.5)
    ]
    static let RedUnderlinedButton = [
        UIControlState().rawValue: ButtonParameters(
            backgroundColor: UIColor.clear,
            titleBackgroundColor: UIColor.clear,
            fontColor: TogetherColors.RedMain,
            underlineStyle: NSUnderlineStyle.styleSingle,
            underlineColor: TogetherColors.RedMain),
        UIControlState.disabled.rawValue: ButtonParameters(
            backgroundColor: UIColor.lightGray,
            titleBackgroundColor: UIColor.lightGray,
            fontColor: UIColor.colorFromRGB(206, green: 72, blue: 72, alpha: 255),
            underlineStyle: NSUnderlineStyle.styleSingle,
            underlineColor: UIColor.colorFromRGB(206, green: 72, blue: 72, alpha: 255)),
        UIControlState.highlighted.rawValue: ButtonParameters(
            backgroundColor: UIColor.clear,
            titleBackgroundColor: UIColor.clear,
            fontColor: .colorFromRGB(246, green: 72, blue: 72, alpha: 255),
            underlineStyle: NSUnderlineStyle.styleSingle,
            underlineColor: .colorFromRGB(246, green: 72, blue: 72, alpha: 255))
    ]
    static let RedBorderedButton: [UInt: ButtonParameters] = [
        UIControlState().rawValue: ButtonParameters(
            backgroundColor: UIColor.white,
            titleBackgroundColor: UIColor.white,
            fontColor: TogetherColors.RedMain,
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: TogetherColors.RedMain,
            borderWidth: 2),
        UIControlState.highlighted.rawValue: ButtonParameters(
            backgroundColor: UIColor.lightGray,
            titleBackgroundColor: UIColor.lightGray,
            fontColor: TogetherColors.RedMain,
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: TogetherColors.RedMain,
            borderWidth: 2),
        UIControlState.disabled.rawValue: ButtonParameters(
            backgroundColor: UIColor.white,
            titleBackgroundColor: UIColor.white,
            fontColor: UIColor.grayColor(195),
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: UIColor.grayColor(195),
            borderWidth: 2),
        ]
    static let RedBorderedGrayBackButton: [UInt: ButtonParameters] = [
        UIControlState().rawValue: ButtonParameters(
            backgroundColor: UIColor.grayColor(248),
            titleBackgroundColor: UIColor.grayColor(248),
            fontColor: TogetherColors.RedMain,
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: TogetherColors.RedMain,
            borderWidth: 2),
        UIControlState.highlighted.rawValue: ButtonParameters(
            backgroundColor: UIColor.lightGray,
            titleBackgroundColor: UIColor.lightGray,
            fontColor: TogetherColors.RedMain,
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: TogetherColors.RedMain,
            borderWidth: 2),
        UIControlState.disabled.rawValue: ButtonParameters(
            backgroundColor: UIColor.grayColor(248),
            titleBackgroundColor: UIColor.grayColor(248),
            fontColor: UIColor.grayColor(195),
            cornerRadius: 2,
            charactersSpacing: 1.5,
            borderColor: UIColor.grayColor(195),
            borderWidth: 2),
        ]
    static let RedPlainButton: [UInt: ButtonParameters] = [
        UIControlState().rawValue: ButtonParameters(
            backgroundColor: TogetherColors.RedMain,
            titleBackgroundColor: TogetherColors.RedMain,
            fontColor: UIColor.white,
            cornerRadius: 2,
            charactersSpacing: 1.5),
        UIControlState.highlighted.rawValue: ButtonParameters(
            backgroundColor: TogetherColors.RedMainDark,
            titleBackgroundColor: TogetherColors.RedMainDark,
            fontColor: UIColor.white,
            cornerRadius: 2,
            charactersSpacing: 1.5),
        UIControlState.disabled.rawValue: ButtonParameters(
            backgroundColor: UIColor.white,
            titleBackgroundColor: UIColor.white,
            fontColor: UIColor.grayColor(195),
            cornerRadius: 2,
            charactersSpacing: 1.5)
        ]
    static let RedTextButton: [UInt: ButtonParameters] = [
        UIControlState().rawValue: ButtonParameters(
            backgroundColor: UIColor.white,
            titleBackgroundColor: UIColor.white,
            fontColor: TogetherColors.RedMain,
            cornerRadius: 2,
            charactersSpacing: 1.5),
        UIControlState.highlighted.rawValue: ButtonParameters(
            backgroundColor: TogetherColors.RedMainDark,
            titleBackgroundColor: TogetherColors.RedMainDark,
            fontColor: UIColor.white,
            cornerRadius: 2,
            charactersSpacing: 1.5),
        UIControlState.disabled.rawValue: ButtonParameters(
            backgroundColor: UIColor.white,
            titleBackgroundColor: UIColor.white,
            fontColor: UIColor.grayColor(195),
            cornerRadius: 2,
            charactersSpacing: 1.5)
    ]
}
