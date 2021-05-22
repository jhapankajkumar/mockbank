//
//  LoadingIndicator.swift
//  Common
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import UIKit

public class MKLoadingView: UIView {
    var loadingIndicator: UIView!
    
    public init(attachTo parent: UIView) {
        super.init(frame: parent.frame)
        componentSetup()
        setComponentConstraints()
        attachWithAnimation(to: parent)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func componentSetup() {
        self.backgroundColor = MKColor.black.get().withAlphaComponent(0.4)
        
        self.loadingIndicator = MKLoadingIndicator(frame: .zero)
        self.addSubview(loadingIndicator)
    }
    
    public func setupDarkMode() {
        self.backgroundColor = MKColor.black.get().withAlphaComponent(0.65)
    }
    
    public func setupNormalMode() {
        self.backgroundColor = MKColor.black.get().withAlphaComponent(0.4)
    }
    
    func setComponentConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.loadingIndicator.widthAnchor.constraint(equalTo: self.widthAnchor,
                                                         multiplier: MKUIConstant.loadingIndicatorWidthRatioToContainer),
            self.loadingIndicator.heightAnchor.constraint(equalTo: self.loadingIndicator.widthAnchor),
            self.loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setFullScreen() {
        guard let parent = self.superview else { return }
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parent.topAnchor),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
        ])
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func attachWithAnimation(to parent: UIView) {
        UIView.transition(with: parent,
                          duration: MKUIConstant.defaultDurationShort,
                          options: .transitionCrossDissolve,
                          animations: {
                            parent.addSubview(self)
                            self.setFullScreen()
        }, completion: nil)
    }
    
    public func dismiss() {
        if let parent = self.superview {
            UIView.transition(with: parent,
                              duration: MKUIConstant.defaultDurationShort,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.removeFromSuperview()
            }, completion: nil)
        }
    }
    
    public func setTopScreen(top: CGFloat, size: CGFloat) {
        guard let parent = self.superview else { return }
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: top),
            self.heightAnchor.constraint(equalToConstant: size),
            self.widthAnchor.constraint(equalToConstant: size),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
    }
}
