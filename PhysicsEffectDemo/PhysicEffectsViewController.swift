//
//  PhysicEffectsViewController.swift
//  Chat
//
//  Created by Diego Freniche Brito on 28/11/2019.
//  Copyright © 2019 Teamwork.com. All rights reserved.
//

import UIKit

class PhysicEffectsViewController: UIViewController {

    public var message: String = ""
    public var font = UIFont.preferredFont(forTextStyle: .title1)
    public var textColor = UIColor.white
    public var textBackgroundColor = UIColor.clear

    private var gravity: UIGravityBehavior? = nil
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = .clear
        
        reload()
    }
    
    public func reload() {

        resetScreen()
        animateLabels()
    }
    
    private var animator: UIDynamicAnimator? = nil
    
    private func resetScreen() {
        
        let _ =
            self.view.subviews
            .filter { (view) in type(of: view) == UILabel.self }
            .map { (view: UIView) -> Void in
                UIView.animate(withDuration: 1.0, animations: {
                    
                    view.alpha = 0.0
                }) { (finished: Bool) in
                    
                    view.removeFromSuperview()
                }
            }
        
        animator = nil
    }
    
    private func animateLabels() {
        
        guard animator == nil else { return }
        
        // 1: split the message up into words
        let words = message.components(separatedBy: " ")
        
        // 2: create an empty array of labels
        var labels = [UILabel]()
        
        // 3: convert each word into a label
        for (index, word) in words.enumerated() {
            
            let label = UILabel()
            label.font = self.font
            label.backgroundColor = self.textBackgroundColor
            label.textColor = self.textColor
            
            // 4: position the labels one above the other
            label.center = CGPoint(x: view.frame.midX, y: 200 + CGFloat(30 * index))
            label.text = word
            label.sizeToFit()
            view.addSubview(label)
            
            labels.append(label)
        }
        
        // 5: create a gravity behaviour for our labels
        self.gravity = UIGravityBehavior(items: labels)
        gravity?.gravityDirection = CGVector(dx: -0.01, dy: -0.1)
        animator = UIDynamicAnimator(referenceView: view)
        animator?.addBehavior(gravity!)
        
        // 6: create a collision behavior for our labels
        let collisions = UICollisionBehavior(items: labels)
                
        // 7: give some boundaries for the collisions
        collisions.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collisions)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let touchPoint = touch.location(in: view)
            
            var gx = touchPoint.x / (self.view.frame.size.width / 2)
            var gy = touchPoint.y / (self.view.frame.size.height / 2)

            if gx < 1 {
                
                gx = gx * -1
            }
            
            if gy < 1 {
                
                gy = gy * -1
            }
            
            gravity?.gravityDirection = CGVector(dx: gx, dy: gy)
        }
    }
    
}

// capture the "shake device" gesture App wide
extension UIWindow {
    
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        guard
            motion == .motionShake,
            let topMostController = UIApplication.topViewController()
        else { return }
                       
        // if we already seeing a PhysicEffectsViewController, we just reload the controller
        if let physicsViewController = topMostController as? PhysicEffectsViewController {
            
            physicsViewController.reload()
            return
        }
    
        let easterEggViewController = PhysicEffectsViewController()
        let message = "😀 😅 😃 😂 😄 🤣 😁 PHYSICS ARE AMAZING 😆 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗😙😚 😋😛😝 😜🤪🤨 🧐🤓😎 🤩🥳😏 😒 😞"
        
        easterEggViewController.message = message
        easterEggViewController.textColor = .white
        
        topMostController.present(easterEggViewController, animated: true, completion: nil)
    }
}

// finds topmost ViewController for us
extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UIKit.UINavigationController {
        
            return topViewController(controller: navigationController.topViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            
            if let selected = tabController.selectedViewController {
            
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
        
            return topViewController(controller: presented)
        }
        
        return controller
    }
}
