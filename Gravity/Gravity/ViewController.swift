//
//  ViewController.swift
//  Gravity
//
//  Created by sun on 2022/03/06.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var motion: CMMotionManager!
    private var front: UIView!
    private var queue: OperationQueue!  // used for updating UI objects with motion
    private var collision: UICollisionBehavior!
    
    lazy private var items = createItems()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let boundaryFrame = CGRect(
            x: 65,
            y: 150,
            width: self.view.frame.width * 0.7,
            height: self.view.frame.height * 0.5)
        let rectangle = UIView(frame: boundaryFrame)
        rectangle.backgroundColor = .systemTeal
        self.view.insertSubview(rectangle, at: 1)
        self.collision = UICollisionBehavior(items: [])
        collision.addBoundary(
            withIdentifier: "borders" as NSCopying,
            for: UIBezierPath(rect: boundaryFrame)
        )
//        collision.collisionMode = .everything
        
        collision.collisionDelegate = self
        
        let rectangle2 = UIView(frame: boundaryFrame)
        rectangle2.backgroundColor = .systemOrange.withAlphaComponent(0.3)
        rectangle2.isOpaque = false
        self.front = rectangle2
        self.front.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userDidTap(_:))))
        self.view.addSubview(rectangle2)
        
        self.queue = OperationQueue.current
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.gravity = UIGravityBehavior(items: [])
        motion = CMMotionManager()
        
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        
//        self.motion.startDeviceMotionUpdates(to: queue) { motion, error in
//            guard let motion = motion else { return }
//
//            let grav: CMAcceleration = motion.gravity
//            let x = CGFloat(grav.x)
//            let y = CGFloat(grav.y)
//            var p = CGPoint(x: x, y: y)
//
//            if let orientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
//                if orientation == .landscapeLeft {
//                    let t = p.x
//                    p.x = 0 - p.y
//                    p.y = t
//                } else if orientation == .landscapeRight {
//                    let t = p.x
//                    p.x = p.y
//                    p.y = 0 - t
//                } else if orientation == .portraitUpsideDown {
//                    p.x *= -1
//                    p.y *= -1
//                }
//            }
//
//            let v = CGVector(dx: p.x, dy: 0 - p.y)
//            self.gravity.gravityDirection = v
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        items.count
    }
    
    private func createItems() -> [UIView] {
        var items = [UIView]()
        let scale: CGFloat = 0.9
        var zIndex: CGFloat = 10
        for index in 1..<365 {
            
            var numbers = [CGFloat]()
            
            for number in -100...100 {
                numbers.append(CGFloat(number))
            }
            let scale = 0.8
            let imageView = UIImageView(image: UIImage(named: "greenNote"))
            let myView = UIView(frame: CGRect(origin: imageView.frame.origin, size: CGSize(width: imageView.frame.width * scale, height: imageView.frame.height * scale)))
    //            imageView.contentMode = .scaleToFill
            myView.frame.origin = CGPoint(x: self.view.bounds.width / 2 - numbers.randomElement()!, y: 10 + CGFloat(index) * 0.7)
            myView.addSubview(imageView)
            items.append(myView)
            self.view.insertSubview(myView, belowSubview: front)
    //        imageView.layer.zPosition = zIndex
            self.collision.addItem(myView)
            self.gravity.addItem(imageView)
//            let imageView = UIImageView(image: UIImage(named: "rain_drop"))
//
////            imageView.contentMode = .scaleToFill
//
////            let myView = UIView()
////            myView.frame.origin = CGPoint(x: self.view.bounds.width / 2, y: 500)
////            myView.frame.size = CGSize(width: imageView.image!.size.width * scale, height: imageView.image!.size.height * scale)
////            myView.addSubview(imageView)
//
//            zIndex += 1
////            items.append(myView)
////            self.view.insertSubview(myView, belowSubview: front)
//            imageView.frame.origin = CGPoint(x: self.view.bounds.width / 2 - [30, 0, -30].randomElement()!, y: 180)
//            imageView.layer.zPosition = zIndex
//            self.items.append(imageView)
//            self.view.insertSubview(imageView, belowSubview: front)
//            self.collision.addItem(imageView)
////            myView.layer.zPosition = zIndex
////            self.collision.addItem(myView)
////            imageView.backgroundColor = .systemPurple
////            imageView.layer.borderColor = UIColor.systemYellow.cgColor
////            imageView.layer.borderWidth = 2
        }
        return items
    }
    
    @objc func userDidTap(_ gestureRecognizer:  UITapGestureRecognizer) {
        let scale = 0.8
        let imageView = UIImageView(image: UIImage(named: "greenNote"))
        let myView = UIView(frame: CGRect(origin: imageView.frame.origin, size: CGSize(width: imageView.frame.width * scale, height: imageView.frame.height * scale)))
//            imageView.contentMode = .scaleToFill
        myView.frame.origin = CGPoint(x: self.view.bounds.width / 2 - [30, 0, -30].randomElement()!, y: 180)
        myView.addSubview(imageView)
        items.append(myView)
        self.view.insertSubview(myView, belowSubview: front)
//        imageView.layer.zPosition = zIndex
        self.collision.addItem(myView)
        self.gravity.addItem(myView)
//        imageView.fr
//        let myView = UIView()
//        myView.frame.origin = CGPoint(x: self.view.bounds.width / 2 - [10, 0, -10].randomElement()!, y: 180)
//        myView.frame.size = CGSize(width: imageView.image!.size.width * scale, height: imageView.image!.size.height * scale)
//        myView.addSubview(imageView)
//        self.items.append(myView)
//        self.view.insertSubview(myView, belowSubview: front)
//        self.gravity.addItem(myView)
//        self.collision.addItem(myView)
        
    }


}

extension ViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item1: UIDynamicItem, with item2: UIDynamicItem) {
//        guard let item1 = item1 as? UIImageView,
//              let item2 = item2 as? UIImageView
//        else { return }
//
//        item1.layer.zPosition = item2.layer.zPosition + 10000
//        print(item1.collisionBoundingPath)
//        item1.frame = CGRect(origin: p, size: item1.frame.size)
//        item2.frame = CGRect(origin: p, size: item1.frame.size)
//        print("overlap")
    }
//    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
//        guard let item1 = item1 as? UIImageView,
//              let item2 = item2 as? UIImageView
//        else { return }
//
//        item1.layer.zPosition = item2.layer.zPosition + 1
//        item1.frame = CGRect(origin: p, size: item1.frame.size)
//        item2.frame = CGRect(origin: p, size: item1.frame.size)
//        print("overlap")
//    }
}
