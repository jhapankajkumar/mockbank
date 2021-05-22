//
//  LoadingIndicator.swift
//  Common
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import UIKit

public class MKLoadingIndicator: UIView {
    // MARK: Components -
    let circleLayer = CAShapeLayer()
    let strokeEndAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = 2.5
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
    }()
    let strokeStartAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = 2.5
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
    }()
    
    // MARK: Init -
    
    /// To get Mandiri's loading indicator, with default color of
    /// Background: White
    /// Indicator: Blue
    ///
    /// To override this color, just set background color and tint color respectively.
    ///
    /// - Parameter frame: CGRect will overriden by constraint
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: View -
    func setup() {
        backgroundColor = MKColor.white.get()
        
        circleLayer.lineWidth = 3
        circleLayer.fillColor = nil
        circleLayer.strokeColor = MKColor.primaryBlue.get().cgColor
        self.layer.addSublayer(circleLayer)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.circleLayer.add(self.strokeEndAnimation, forKey: "strokeEnd")
            self.circleLayer.add(self.strokeStartAnimation, forKey: "strokeStart")
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = min(bounds.height, bounds.width) / 2
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 *  0.75
        
        let startAngle = CGFloat(-Double.pi/2)
        let endAngle = startAngle + CGFloat(Double.pi * 2)
        let path = UIBezierPath(arcCenter: .zero,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle, clockwise: true)
        
        circleLayer.position = center
        circleLayer.path = path.cgPath
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        circleLayer.strokeColor = tintColor.cgColor
    }
    
    // MARK: Methods -
    public func attachToMiddle(of target: UIView, size: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerYAnchor.constraint(equalTo: target.centerYAnchor),
            self.centerXAnchor.constraint(equalTo: target.centerXAnchor),
            self.widthAnchor.constraint(equalToConstant: size),
            self.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    public func attachToTop(of target: UIView, size: CGFloat, top: CGFloat  ) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: target.topAnchor, constant: top),
            self.centerXAnchor.constraint(equalTo: target.centerXAnchor),
            self.widthAnchor.constraint(equalToConstant: size),
            self.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    public func addBorder(of borderWidth: CGFloat, borderColor: CGColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
}
