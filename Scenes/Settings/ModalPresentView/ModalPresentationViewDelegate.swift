//
//  ModalPresentationViewDelegate.swift
//  Omni
//
//  Created by ahmetAltintop on 2.08.2024.
//

import UIKit

class ModalPresentationViewDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalPresentationViewController(presentedViewController: presented, presenting: presenting)
    }
    
}
