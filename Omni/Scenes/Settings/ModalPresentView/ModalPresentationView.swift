//
//  ModalPresentationView.swift
//  Omni
//
//  Created by ahmetAltintop on 2.08.2024.
//

import UIKit

protocol ModalContentHeightCalculable {  // Her ViewController'ın içerik yüksekliğini hesaplayabilmek için . .
    func calculateContentHeight() -> CGFloat
}

class ModalPresentationViewController: UIPresentationController {
    
    private var originalHeight: CGFloat = 0
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        // Eğer sunulan view controller protokolü uyguluyorsa
        if let heightCalculableVC = presentedViewController as? ModalContentHeightCalculable {
            let contentHeight = heightCalculableVC.calculateContentHeight()
            let targetHeight = min(contentHeight + 60, containerView.bounds.height)
            originalHeight = targetHeight
            
            return CGRect(x: 0,
                          y: containerView.bounds.height - targetHeight,
                          width: containerView.bounds.width,
                          height: targetHeight)
        }
        return super.frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else { return }
        
        let dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.alpha = 0
        containerView.addSubview(dimmingView)
        dimmingView.frame = containerView.bounds
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           dimmingView.addGestureRecognizer(tapGesture)
           
           presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
               dimmingView.alpha = 1
           }, completion: nil)
        
    }
    
    // Settings Ekranında klavye kapansın diye . .
    @objc private func dismissKeyboard() {
        self.containerView?.endEditing(true)
    }
    
    func adjustHeightForKeyboard(keyboardHeight: CGFloat) {
        guard let containerView = containerView else { return }
        
        let newHeight = min(originalHeight + keyboardHeight, containerView.bounds.height)
        UIView.animate(withDuration: 0.3) {
            self.presentedView?.frame = CGRect(x: 0,
                                               y: containerView.bounds.height - newHeight,
                                               width: containerView.bounds.width,
                                               height: newHeight)
        }
    }
    
    func resetHeight() {
        guard let containerView = containerView else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.presentedView?.frame = CGRect(x: 0,
                                               y: containerView.bounds.height - self.originalHeight,
                                               width: containerView.bounds.width,
                                               height: self.originalHeight)
        }
    }
    
    func updateHeight() {
        guard let containerView = containerView else { return }
        
        let newFrame = frameOfPresentedViewInContainerView
        UIView.animate(withDuration: 0.3) {
            self.presentedView?.frame = newFrame
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        containerView?.subviews.last?.alpha = 1
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.containerView?.subviews.last?.alpha = 0
        }, completion: { _ in
            self.containerView?.subviews.last?.removeFromSuperview()
        })
    }
}
