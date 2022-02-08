//
//  MainViewController.swift
//  ISSLive
//
//  Created by Alex on 07/02/22.
//

import Foundation
import UIKit

final class MainViewController: UIViewController {
    private var leftMenuViewController: LeftMenuViewController?
    private var leftMenuShadowView: UIView?
    private var leftMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    private var leftMenuTrailingConstraint: NSLayoutConstraint?
    private var revealLeftMenuOnTop: Bool = true
    private var gestureEnabled: Bool = true
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    private var revealSideMenuOnTop: Bool = true
    
    override func viewDidLoad() {
        setupMenu()
    }
    
    private func setupMenu() {
        // Shadow Background View
        leftMenuShadowView = UIView(frame: self.view.bounds)
        leftMenuShadowView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        leftMenuShadowView?.backgroundColor = .black
        leftMenuShadowView?.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(tapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        if self.revealSideMenuOnTop,
           let menuShadow = leftMenuShadowView {
            view.insertSubview(menuShadow, at: 1)
        }
        
        // Left Menu
        let storyboard = UIStoryboard(name: Constant.Main.navId, bundle: Bundle.main)
        leftMenuViewController = storyboard.instantiateViewController(withIdentifier: Constant.Menu.navId) as? LeftMenuViewController
        leftMenuViewController?.delegate = self
        if let menuView = leftMenuViewController,
           let leftMenuView = leftMenuViewController?.view {
            view.insertSubview(leftMenuView, at: revealLeftMenuOnTop ? 2 : 0)
            addChild(menuView)
            menuView.didMove(toParent: self)
        }

        // Left Menu AutoLayout
        leftMenuViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        
        if revealLeftMenuOnTop {
            leftMenuTrailingConstraint = leftMenuViewController?.view.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                                                               constant: -leftMenuRevealWidth - paddingForRotation)
            leftMenuTrailingConstraint?.isActive = true
        }
        
        if let menuView = leftMenuViewController?.view {
            let widthAnchor = menuView.widthAnchor.constraint(equalToConstant: leftMenuRevealWidth)
            let bottomAnchor = menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            let topAnchor = menuView.topAnchor.constraint(equalTo: view.topAnchor)
            NSLayoutConstraint.activate([
                widthAnchor,
                bottomAnchor,
                topAnchor
            ])
        }
        
        // Side Menu Gestures
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
        
        // Default Home View Controller
        showViewController(viewController: UINavigationController.self, storyboardId: Constant.Home.navId)
    }

    // Call this Button Action from the View Controller you want to Expand/Collapse when you tap a button
    @IBAction
    public func revealSideMenu() {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
}


extension MainViewController: LeftMenuViewControllerDelegate {
    func selectedCell(_ row: Int) {
        switch row {
        case 0:
            showViewController(viewController: UINavigationController.self, storyboardId: Constant.Home.navId)
        case 1:
            showViewController(viewController: UINavigationController.self, storyboardId: Constant.Logs.navId)
        case 2:
            showViewController(viewController: UINavigationController.self, storyboardId: Constant.Contact.navId)
        default:
            break
        }
        
        // Collapse side menu with animation
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
    }
    
    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String) -> () {
        // Remove the previous View
        for subview in view.subviews {
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
        let storyboard = UIStoryboard(name: Constant.Main.navId, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        vc.view.tag = 99
        view.insertSubview(vc.view, at: revealLeftMenuOnTop ? 0 : 1)
        addChild(vc)
        if !self.revealLeftMenuOnTop {
            if isExpanded {
                vc.view.frame.origin.x = leftMenuRevealWidth
            }
            if let leftMenu = leftMenuShadowView {
                vc.view.addSubview(leftMenu)
            }
        }
        vc.didMove(toParent: self)
    }
    
    func sideMenuState(expanded: Bool) {
        if expanded {
            animateSideMenu(targetPosition: revealLeftMenuOnTop ? 0 : leftMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            // Animate Shadow (Fade In)
            UIView.animate(withDuration: 0.5) { self.leftMenuShadowView?.alpha = 0.6 }
        }
        else {
            animateSideMenu(targetPosition: revealLeftMenuOnTop ? (-leftMenuRevealWidth - paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.5) { self.leftMenuShadowView?.alpha = 0.0 }
        }
    }

    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealLeftMenuOnTop {
                self.self.leftMenuTrailingConstraint?.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    @objc
    func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
    }

    // Close side menu when you tap on the shadow background view
    @objc
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if let leftMenu = leftMenuViewController,
           (touch.view?.isDescendant(of: leftMenu.view))! {
            return false
        }
        return true
    }
    
    // Dragging Side Menu
    @objc
    private func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        guard gestureEnabled == true else { return }

        let position: CGFloat = sender.translation(in: self.view).x
        let velocity: CGFloat = sender.velocity(in: self.view).x

        switch sender.state {
        case .began:

            // If the user tries to expand the menu more than the reveal width, then cancel the pan gesture
            if velocity > 0, self.isExpanded {
                sender.state = .cancelled
            }

            // If the user swipes right but the side menu hasn't expanded yet, enable dragging
            if velocity > 0, !self.isExpanded {
                self.draggingIsEnabled = true
            }
            // If user swipes left and the side menu is already expanded, enable dragging
            else if velocity < 0, self.isExpanded {
                self.draggingIsEnabled = true
            }

            if self.draggingIsEnabled {
                // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    self.sideMenuState(expanded: self.isExpanded ? false : true)
                    self.draggingIsEnabled = false
                    return
                }

                if self.revealSideMenuOnTop {
                    self.panBaseLocation = 0.0
                    if self.isExpanded {
                        self.panBaseLocation = leftMenuRevealWidth
                    }
                }
            }

        case .changed:

            // Expand/Collapse side menu while dragging
            if self.draggingIsEnabled {
                if self.revealSideMenuOnTop {
                    // Show/Hide shadow background view while dragging
                    let xLocation: CGFloat = self.panBaseLocation + position
                    let percentage = (xLocation * 150 / leftMenuRevealWidth) / leftMenuRevealWidth

                    let alpha = percentage >= 0.6 ? 0.6 : percentage
                    leftMenuShadowView?.alpha = alpha

                    // Move side menu while dragging
                    if xLocation <= leftMenuRevealWidth {
                        leftMenuTrailingConstraint?.constant = xLocation - leftMenuRevealWidth
                    }
                }
                else {
                    if let recogView = sender.view?.subviews[1] {
                        // Show/Hide shadow background view while dragging
                        let percentage = (recogView.frame.origin.x * 150 / leftMenuRevealWidth) / leftMenuRevealWidth

                        let alpha = percentage >= 0.6 ? 0.6 : percentage
                        leftMenuShadowView?.alpha = alpha

                        // Move side menu while dragging
                        if recogView.frame.origin.x <= leftMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x = recogView.frame.origin.x + position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
        case .ended:
            self.draggingIsEnabled = false
            // If the side menu is half Open/Close, then Expand/Collapse with animation
            if self.revealSideMenuOnTop {
                let movedMoreThanHalf = leftMenuTrailingConstraint?.constant ?? 0.0 > -(leftMenuRevealWidth * 0.5)
                self.sideMenuState(expanded: movedMoreThanHalf)
            }
            else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > leftMenuRevealWidth * 0.5
                    self.sideMenuState(expanded: movedMoreThanHalf)
                }
            }
        default:
            break
        }
    }
}
