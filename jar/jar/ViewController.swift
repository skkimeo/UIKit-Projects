//
//  ViewController.swift
//  jar
//
//  Created by sun on 2022/03/15.
//

import UIKit

import Then

class ViewController: UIViewController {
    
    /// 쪽지를 담고 물리엔진이 작용할 영역
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    /// 물리엔진과 관련 애니메이션을 관리
    private var animator: UIDynamicAnimator!
    
    /// 중력을 적용
    private var gravity: UIGravityBehavior!
    
    /// 충돌 구현
    private var collision: UICollisionBehavior!
    
    /// 쪽지 이미지들
    private var notes = [UIView]()
    
    private let noteViewSize: CGFloat = 15
    
    private var count = 0
    
//    private var timer = Timer(
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.configureAnimator()
//        self.configureGravity()
//        self.configureCollision()
        self.configureGrid()
        
//        for index in 0..<1{
//            let randomPosition = self.notePosisition()
//            self.spawnNote(at: CGPoint(x: randomPosition.x, y: 10))
//        }
        // Do any additional setup after loading the view.
//        let behavior = UIDynamicItemBehavior(items: self.notes)
//        behavior.elasticity = 0
//        behavior.friction = 1
//        behavior.density = 10000
//        behavior.charge = 0
//        behavior.resistance = 1
//        behavior.allowsRotation = false
//        animator.addBehavior(behavior)
//        self.timer.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.notes.forEach {
//            self.gravity.removeItem($0)
//            self.collision.removeItem($0)
//        }
    }
    
    private func configureAnimator() {
        self.animator = UIDynamicAnimator(referenceView: self.containerView)
    }
    
    private func configureGravity() {
        self.gravity = UIGravityBehavior(items: self.notes).then {
            self.animator.addBehavior($0)
        }
    }
    
    private func configureCollision() {
        self.collision = UICollisionBehavior(items: self.notes).then {
            $0.translatesReferenceBoundsIntoBoundary = true
            self.animator.addBehavior($0)
            $0.collisionDelegate = self
        }
    }
    
    private func spawnNote(at point: CGPoint) {
//        let point = CGPoint(x: x, y: y)
        var zPosition: CGFloat = 1
        let noteView = UIView().then {
            $0.frame.origin = point
            $0.frame.size = CGSize(width: self.noteViewSize, height: self.noteViewSize)
            self.containerView.addSubview($0)
            self.collision.addItem($0)
            self.gravity.addItem($0)
            self.notes.append($0)
            $0.layer.cornerRadius = self.noteViewSize / 2
            zPosition += 1
            $0.layer.zPosition = zPosition
//            $0.backgroundColor = .systemBlue
        }
        let scale: CGFloat = 1.5
        let imageView = UIImageView(image: UIImage(named: "note")).then {
            $0.frame.size = CGSize(width: self.noteViewSize * scale, height: self.noteViewSize * scale)
            print($0)
        }
        
        noteView.addSubview(imageView)
//        noteView.addSubview(imageView)
    }
    
    var stopped = false
    
    var tapCount:CGFloat = 0
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !stopped {
//            print("stop")
//            self.notes.forEach {
//                self.gravity.removeItem($0)
//                self.collision.removeItem($0)
//
//            }
//            stopped.toggle()
//            return
//        }
//        self.notes.forEach {
//            print("Start")
////            self.gravity.addItem($0)
//            self.collision.addItem($0)
//            stopped.toggle()
//        }
        
//        let randomPosition = self.notePosisition()
//        let height = self.containerView.frame.size.height
        tapCount += 1.5
        for _ in 0..<1 {
            
        let randomPosition = self.notePosisition()
        let height = self.containerView.frame.size.height
//        self.spawnNote(at: CGPoint(x: randomPosition.x, y: height - tapCount * noteViewSize))
            self.spawnNote(at: CGPoint(x: 150, y: 0))
        }
        print("Total notes: \(self.total)")
    }
    
    var total : Int {
        self.notes.count
    }
    
    private func notePosisition() -> CGPoint {
        let frame = self.containerView.frame
        
        var xRange = [CGFloat]()
        for number in 0..<Int(frame.width) - 1{
            xRange.append(CGFloat(number) + 1)
        }
        
        var yRange = [CGFloat]()
        for number in 0..<Int(frame.height) {
            yRange.append(frame.origin.y + CGFloat(number) + 1)
        }
        
        let yStart = frame.origin.y + frame.size.height
        let yPosition: [Int: CGFloat] = [
            0: yStart - 2 * self.noteViewSize,
            50: yStart - 2 * self.noteViewSize,
            100: yStart - 3 * self.noteViewSize,
            150: yStart - 4 * self.noteViewSize,
            200: yStart - 5 * self.noteViewSize,
            250: yStart - 6 * self.noteViewSize,
            300: yStart - 7 * self.noteViewSize,
            350: frame.origin.y + 1
        ]
        print(self.notes.count)
        let currentY = yPosition[self.notes.count/50] ?? 100
        let currentX = xRange.randomElement()!
        
        return CGPoint(x: currentX, y: currentY)
    }
    
    var contact = 0
    
    private func configureGrid() {
//        print("hi")
        
//        var grid = Grid(layout: .aspectRatio(1), frame: self.containerView.bounds)
//        grid.cellCount = 7
        
        var grid = Grid(
            frame: self.containerView.bounds,
            cellCount: 365,
            aspectRatio: 1
        )
        
        
//        print(grid.cellSize)
//        grid.cellCount = 365
//        print(grid.cellSize)
//        print(grid.frame.size)
//        print(grid.dimensions)
//        grid.cellCount = 25 * 15
//        print(grid.frame.origin)
//        grid.frame.origin = CGPoint(x: -7, y: 0)
        for index in 0..<180 {
            let view = UIView(frame: grid[index] ?? .zero).then {
                $0.backgroundColor = [UIColor.systemBlue, .systemGreen, .systemYellow, .systemPurple, .systemPink].randomElement()!.withAlphaComponent(0.5)
                $0.layer.zPosition = [3, 4, 5, 6, 7, 8, 9, 10].randomElement()!
//                self.view.addSubview($0)
                self.containerView.addSubview($0)
            }
            
            let scale: CGFloat = 1.5
            let randomImage = ["green", "note", "pink", "purple", "yellow"].randomElement()!
            let imageView = UIImageView(image: UIImage(named: randomImage)).then {
                $0.frame.size = CGSize(
                    width: view.frame.size.width * scale,
                    height: view.frame.size.height * scale
                )
                let randomDegrees: CGFloat = 2 * .pi / [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36].randomElement()!
                let randomScale: CGFloat = [0.8, 0.7, 0.9].randomElement()!
                $0.transform = $0.transform.scaledBy(x: randomScale, y: randomScale)
                $0.transform = $0.transform.rotated(by: randomDegrees)
            }
//            view.addSubview(imageView)
            self.notes.append(view)
        }
//        grid.frame.origin = .zero
        let width: CGFloat = grid.cellSize.width * CGFloat(grid.dimensions.columnCount)
        let height: CGFloat = grid.cellSize.height * CGFloat(grid.dimensions.rowCount)
        print(grid.frame.origin)
        print(containerView.frame.origin)
//        grid.frame.size = CGSize(width: width, height: height)
//        self.containerView.frame.size = CGSize(width: width-100, height: height)
        self.containerWidth.constant = width
        self.containerHeight.constant = height
        let wantedSize = CGSize(width: width, height: height)
        self.containerView.frame.size = wantedSize
        self.containerView.backgroundColor = .brown
        grid.frame = self.containerView.frame
        print(self.containerView.frame.origin)
        print("real size: \(containerView.frame.size)")
        print("wanted size: \(wantedSize)")
        self.configureAnimator()
        self.configureGravity()
        self.configureCollision()

        self.notes.forEach {
            self.gravity.addItem($0)
            self.collision.addItem($0)
        }
        
    }
}


extension ViewController: UICollisionBehaviorDelegate {
    
//    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item1: UIDynamicItem, with item2: UIDynamicItem) {
//        <#code#>
//    }
//
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        
//        self.collision.removeItem(item1)
//        let index = self.notes.firstIndex(of: item1 as! UIView)!
        
//        self.collision.removeItem(item2)
//        let index2 = self.notes.firstIndex(of: item2 as! UIView)!
        if count < 365 {
//            let randomPosition = self.notePosisition()
//            self.spawnNote(at: CGPoint(x: randomPosition.x, y: 30))
//            count += 1
        } else {
//            self.gravity.removeItem(item1)
//            self.gravity.removeItem(item2)
        }
//        self.notes.forEach {
//            self.gravity.removeItem(item1)
//            self.collision.removeItem(item1)
//
//        self.gravity.removeItem(item2)
//        self.collision.removeItem(item2)
//        }
        print(#function)
        contact += 1
        print(contact)
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if count < 365 {
//            let randomPosition = self.notePosisition()
//            self.spawnNote(at: CGPoint(x: randomPosition.x, y: 30))
//            count += 1
        }
//        self.collision.removeItem(item)
//        let index = self.notes.firstIndex(of: item as! UIView)!
//        self.notes.forEach {
//            self.gravity.removeItem($0)
//            self.collision.removeItem($0)
//        }
        print(#function)
        contact+=1
        print(contact)
    }
}
