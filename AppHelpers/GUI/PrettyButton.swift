//
//  PrettyButton.swift
//  Together
//
//  Created by Андрей Цай on 09.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import RxSwift

class PrettyButton: UIButton {

    fileprivate var paramsForStates: [UInt: ButtonParameters] = [:]
    
    override var isEnabled: Bool {
        didSet{
            applyParamsForCurrentState()
        }
    }
    override var isHighlighted: Bool {
        didSet{
            applyParamsForCurrentState()
        }
    }
    override var isSelected: Bool {
        didSet{
            applyParamsForCurrentState()
        }
    }
    
    fileprivate func applyParamsForCurrentState(){
        guard let stateParams = paramsForStates[self.state.rawValue] else { return }
        applyParamsForState(self.state, stateParams: stateParams)
        
    }
    
    fileprivate func setAttributedTitleFontColorForCurrentState (_ color: UIColor){
        setAttributedTitleAttributeForState(self.state, attrName: NSForegroundColorAttributeName, attrValue: color)
    }
    
    fileprivate func setAttributedTitleBackgroundColorForCurrentState (_ color: UIColor){
        setAttributedTitleAttributeForState(self.state, attrName: NSBackgroundColorAttributeName, attrValue: color)
    }
    
    fileprivate func setAttributedTitleAttributeForState(_ state: UIControlState, attrName: String, attrValue: AnyObject){
        guard let aTitle = self.attributedTitle(for: state) else { return }
        let attributedString = NSMutableAttributedString(attributedString: aTitle)
        let applyRange = NSMakeRange(0, attributedString.mutableString.lowercased.characters.count)
        attributedString.addAttribute(
            attrName,
            value: attrValue,
            range: applyRange)
        self.setAttributedTitle(attributedString, for: state)
    }
    
    fileprivate func loadParamsForState(_ state: UIControlState) -> ButtonParameters {
        let backColor = backgroundColor ?? UIColor.white
        let titleBackColor: UIColor = titleLabel?.backgroundColor ?? UIColor.white
        var fontColor: UIColor =  titleColor(for: state) ?? UIColor.black
        var res = ButtonParameters(backgroundColor: backColor, titleBackgroundColor: titleBackColor, fontColor: fontColor)
        if let attrTitle = self.attributedTitle(for: state) {
            res.titleBackgroundColor = attrTitle.attribute(NSBackgroundColorAttributeName, at: 0, effectiveRange: nil) as? UIColor ?? UIColor.white
            res.fontColor = attrTitle.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: nil) as? UIColor ?? UIColor.black
            res.charactersSpacing = attrTitle.attribute(NSKernAttributeName, at: 0, effectiveRange: nil) as? CGFloat ?? 0
            let uStyle = (attrTitle.attribute(NSUnderlineStyleAttributeName, at: 0, effectiveRange: nil) as? Int ) ?? res.underlineStyle.rawValue
            res.underlineStyle = NSUnderlineStyle(rawValue: uStyle) ?? res.underlineStyle
            fontColor = attrTitle.attribute(NSUnderlineColorAttributeName, at: 0, effectiveRange: nil) as? UIColor ?? UIColor.black
        }
        res.borderColor = UIColor(cgColor: layer.borderColor ?? UIColor.black.cgColor)
        res.borderWidth = layer.borderWidth 
        res.cornerRadius = layer.cornerRadius
        return res
    }
    
    fileprivate func applyParamsForState(_ state: UIControlState, stateParams: ButtonParameters){
        self.backgroundColor = stateParams.backgroundColor
        if self.attributedTitle(for: state) != nil {
            setAttributedTitleAttributeForState(state, attrName: NSForegroundColorAttributeName, attrValue: stateParams.fontColor)
            setAttributedTitleAttributeForState(state, attrName: NSBackgroundColorAttributeName, attrValue: stateParams.titleBackgroundColor)
            setAttributedTitleAttributeForState(state, attrName: NSKernAttributeName, attrValue: stateParams.charactersSpacing as AnyObject)
            setAttributedTitleAttributeForState(state, attrName: NSUnderlineStyleAttributeName, attrValue: stateParams.underlineStyle.rawValue as AnyObject)
            setAttributedTitleAttributeForState(state, attrName: NSUnderlineColorAttributeName, attrValue: stateParams.underlineColor)
        } else {
            self.setTitleColor(stateParams.fontColor, for: state)
            self.titleLabel?.backgroundColor = stateParams.titleBackgroundColor
        }
        self.layer.borderColor = stateParams.borderColor.cgColor
        self.layer.borderWidth = stateParams.borderWidth
        self.layer.cornerRadius = stateParams.cornerRadius
    }
    
    func loadStatesProfile(_ profile: [UInt: ButtonParameters]){
        paramsForStates = profile
        applyParamsForCurrentState()
    }
    
    func setParamsForState(_ state: UIControlState, params: ButtonParameters){
        paramsForStates[state.rawValue] = params
        if self.state == state {
            applyParamsForCurrentState()
        }
    }
    
}
