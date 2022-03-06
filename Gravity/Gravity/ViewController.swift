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
        collision.collisionMode = .everything
        collision.collisionDelegate = self
        
        let rectangle2 = UIView(frame: boundaryFrame)
        rectangle2.backgroundColor = .systemOrange.withAlphaComponent(0.3)
        rectangle2.isOpaque = false
        self.front = rectangle2
        self.front.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userDidTap(_:))))
        self.view.addSubview(rectangle2)
        
        self.queue = OperationQueue.current
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.gravity = UIGravityBehavior(items: self.items)
        motion = CMMotionManager()
        
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
    }
    
    private func createItems() -> [UIView] {
        var items = [UIView]()
        let scale: CGFloat = 0.3
        var zIndex: CGFloat = 10
        for _ in 1...300 {
            let imageView = UIImageView(image: UIImage(named: "rain_drop"))

//            imageView.contentMode = .scaleToFill
            
            let myView = UIView()
            myView.frame.origin = CGPoint(x: self.view.bounds.width / 2, y: 500)
            myView.frame.size = CGSize(width: imageView.image!.size.width * scale, height: imageView.image!.size.height * scale)
            myView.addSubview(imageView)
            
            items.append(myView)
            self.view.insertSubview(myView, belowSubview: front)
            zIndex += 1
            myView.layer.zPosition = zIndex
            imageView.layer.zPosition = zIndex
            self.collision.addItem(myView)
//            imageView.backgroundColor = .systemPurple
//            imageView.layer.borderColor = UIColor.systemYellow.cgColor
//            imageView.layer.borderWidth = 2
        }
        return items
    }
    
    @objc func userDidTap(_ gestureRecognizer:  UITapGestureRecognizer) {
        let scale = 0.2
        let imageView = UIImageView(image: UIImage(named: "rain_drop"))

//            imageView.contentMode = .scaleToFill
        
        let myView = UIView()
        myView.frame.origin = CGPoint(x: self.view.bounds.width / 2 - [10, 0, -10].randomElement()!, y: 180)
        myView.frame.size = CGSize(width: imageView.image!.size.width * scale, height: imageView.image!.size.height * scale)
        myView.addSubview(imageView)
        self.items.append(myView)
        self.view.insertSubview(myView, belowSubview: front)
        self.gravity.addItem(myView)
        self.collision.addItem(myView)
        
    }


}

extension ViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item1: UIDynamicItem, with item2: UIDynamicItem) {
        guard let item1 = item1 as? UIImageView,
              let item2 = item2 as? UIImageView
        else { return }
        
        item1.layer.zPosition = item2.layer.zPosition + 10000
//        item1.frame = CGRect(origin: p, size: item1.frame.size)
//        item2.frame = CGRect(origin: p, size: item1.frame.size)
        print("overlap")
    }
//    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
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
