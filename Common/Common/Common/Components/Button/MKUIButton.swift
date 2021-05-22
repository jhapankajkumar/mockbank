//
//  MKUIButton.swift
//  Common
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import UIKit

@IBDesignable public class MKUIButton: UIButton {
    @IBInspectable public var buttonStyle: Int {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var buttonShape: Int {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var isActive: Bool {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var hasShadow: Bool {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var imagePosition: Int {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var primaryImage: UIImage? {
        didSet {
            primaryImage = primaryImage?.withRenderingMode(.alwaysTemplate)
            setNeedsLayout()
        }
    }
    
    @IBInspectable var secondaryImage: UIImage? {
        didSet {
            secondaryImage = secondaryImage?.withRenderingMode(.alwaysTemplate)
            setNeedsLayout()
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                setButtonHighlightStyle()
            } else {
                setButtonNormalStyle()
            }
        }
    }
    
    // MARK: override methods
    // to observe re-layout caused by Auto Layout
    public override func layoutSubviews() {
        setButtonNormalStyle()
        super.layoutSubviews()
    }
    
    public override init(frame: CGRect) {
        self.buttonStyle    = MKUIButtonStyle.primary.rawValue
        self.buttonShape    = MUIButtonShape.pill.rawValue
        self.isActive       = true
        self.hasShadow      = true
        self.imagePosition  = MUIButtonImagePosition.left.rawValue
        super.init(frame: frame)
        setButtonNormalStyle()
    }
    
    // MARK: MandiriUIButton init methods
    public init(frame: CGRect,
                buttonStyle: MKUIButtonStyle,
                buttonShape: MUIButtonShape = .pill,
                imagePosition: MUIButtonImagePosition = .left,
                primaryImage: UIImage?,
                secondaryImage: UIImage?) {
        
        self.buttonStyle    = buttonStyle.rawValue
        self.buttonShape    = buttonShape.rawValue
        self.isActive       = true
        self.hasShadow      = true
        self.primaryImage   = primaryImage
        self.secondaryImage = secondaryImage
        self.imagePosition  = MUIButtonImagePosition.left.rawValue
        
        super.init(frame: frame)
        setButtonNormalStyle()
    }
    
    public init(buttonStyle: MKUIButtonStyle,
                buttonShape: MUIButtonShape = .pill,
                imagePosition: MUIButtonImagePosition = .left,
                primaryImage: UIImage?,
                secondaryImage: UIImage?) {
        
        self.buttonStyle = buttonStyle.rawValue
        self.buttonShape = buttonShape.rawValue
        self.isActive    = true
        self.hasShadow   = true
        self.primaryImage   = primaryImage
        self.secondaryImage  = secondaryImage
        self.imagePosition  = MUIButtonImagePosition.left.rawValue
        
        super.init(frame: .zero)
        setButtonNormalStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.buttonStyle = MKUIButtonStyle.primary.rawValue
        self.buttonShape = MUIButtonShape.pill.rawValue
        self.isActive    = true
        self.hasShadow   = true
        self.imagePosition = MUIButtonImagePosition.left.rawValue
        
        super.init(coder: aDecoder)
    }
    
    // MARK: added methods
    func setButtonNormalStyle() {
        if let buttonStyle = MKUIButtonStyle(rawValue: self.buttonStyle) {
            switch buttonStyle {
            case .primary:
                implementButtonStyle(backgroundColor: MKColor.brightBlue.get(),
                                     textColor: MKColor.white.get(),
                                     borderColor: MKColor.brightBlue.get(),state: .normal)
            case .secondary:
                implementButtonStyle(backgroundColor: MKColor.white.get(),
                                     textColor: MKColor.brightBlue.get(),
                                     borderColor: MKColor.brightBlue.get(),state: .normal)
            
            case .disabled:
                setDisableButton()
            }
        } else {
            implementButtonStyle(backgroundColor: MKColor.brightBlue.get(),
                                 textColor: MKColor.white.get(),
                                 borderColor: MKColor.brightBlue.get(),state: .normal)
        }
    }
    
    func setButtonHighlightStyle() {
        if let buttonStyle = MKUIButtonStyle(rawValue: self.buttonStyle) {
            switch buttonStyle {
            case .primary:
                implementButtonStyle(backgroundColor: MKColor.lightBlue.get(),
                                     textColor: MKColor.white.get(),
                                     borderColor: MKColor.brightBlue.get(),
                                     state: .highlighted)
            
            case .secondary:
                implementButtonStyle(backgroundColor: MKColor.lightBlue.get(),
                                     textColor: MKColor.white.get(),
                                     borderColor: .clear, state: .highlighted)
            
            case .disabled:
                setDisableButton()
            }
        } else {
            implementButtonStyle(backgroundColor: MKColor.brightBlue.get(),
                                 textColor: MKColor.white.get(),
                                 borderColor: MKColor.brightBlue.get(),state: .highlighted)
        }
    }
    func setDisableButton() {
        implementButtonStyle(backgroundColor: MKColor.babyBlue.get(),
                             textColor: MKColor.white.get(),
                             borderColor: MKColor.babyBlue.get(),state: .normal)
    }
    func implementButtonStyle(backgroundColor: UIColor,
                              textColor: UIColor,
                              borderColor: UIColor,
                              borderWidth: CGFloat = MKUIConstant.borderWidth1,
                              state: UIControl.State) {
        
        self.backgroundColor = backgroundColor
        self.setTitleColor(textColor, for: state)
        self.titleLabel?.alpha = MKUIConstant.commonAlpha2
        if self.buttonStyle == MKUIButtonStyle.primary.rawValue || self.buttonStyle == MKUIButtonStyle.disabled.rawValue {
            self.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
        }
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        implementButtonShape()
        implementButtonState()
        if self.hasShadow && self.isActive {
            implementShadow()
        } else {
            self.layer.shadowOpacity = MKUIConstant.shadowOpacityZero
        }
    }
    
    public func setDestructiveTitleColor(colour : UIColor) {
        implementButtonStyle(backgroundColor: MKColor.lightBlue.get(),
                             textColor: colour,
                             borderColor: .clear,
                             state: .highlighted)
    }
    
    func implementButtonShape() {
        if let buttonShape = MUIButtonShape(rawValue: self.buttonShape) {
            switch buttonShape {
            case .pill:
                self.layer.cornerRadius = self.frame.height / 2
            case .free:
                self.layer.cornerRadius = MKUIConstant.cornerRadius28
            }
        } else {
            self.layer.cornerRadius = self.frame.height * MKUIConstant.cornerRadius2
        }
    }
    
    func implementShadow() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
    
    func implementButtonState() {
        if self.isActive {
            self.alpha = MKUIConstant.commonAlpha2
            self.isUserInteractionEnabled = true
        } else {
            self.alpha = MKUIConstant.commonAlpha1
            self.isUserInteractionEnabled = false
        }
    }
}

