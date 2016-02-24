//
//  TransitioningDelegate.swift
//  Calendario Clases
//
//  Created by Jorge Casariego on 24/2/16.
//  Copyright © 2016 Jorge Casariego. All rights reserved.
//
//  This object is like a traffic light, tells the drivers which road they can use at the moment, the transition delegate object is the same, when you want to present a viewController it will give you an object that is responsible for presenting one. 
//  When you want to dismiss it, it will provide an object that is doing the dismissal animation.

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    // This attribute will be used to present the detailViewController from that frame, that will be the new viewController’s starting frame, and it will expand from there or shrink to that size.
    var openingFrame: CGRect?
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = PresentationAnimator()
        presentationAnimator.openingFrame = openingFrame!
        return presentationAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissAnimator = DismissalAnimator()
        dismissAnimator.openingFrame = openingFrame!
        return dismissAnimator
    }
}
