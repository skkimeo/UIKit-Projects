//
//  CarouselViewController.swift
//  DynamicCollectionView
//
//  Created by sun on 2022/03/25.
//

import UIKit

class CarouselViewController: UIViewController {
    

    var start: IndexPath!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var previousOffset: CGFloat = 0
    private var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: self.view.bounds.width - 40, height: self.view.bounds.height - 80)
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            layout.scrollDirection = .horizontal
            layout.headerReferenceSize = CGSize(width: 200, height: self.view.bounds.height - 80)
            layout.footerReferenceSize = CGSize(width: 350, height: self.view.bounds.height - 80)
            return layout
        }()
        
        collectionView.collectionViewLayout = collectionViewLayout
        
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
    }
}
//
//extension CarouselViewController {
//
//    /// 처음에 데이터 연동
//    func applyInitialSnapshot(animatingDifferences: Bool = true) {
//        var snapshot = Snapshot()
//
//        snapshot.appendSections([.zero])
//        snapshot.appendItems(self.content.map { Item(content: $0)} )
//
//        self.snapshot = snapshot
//        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
//    }
//
//    /// 각 셀에 들어갈 내용 설정
//    func createCellRegisteration() -> UICollectionView.CellRegistration<UICollectionViewCell, Item> {
//
////        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
//        return UICollectionView.CellRegistration<UICollectionViewCell, Item> { cell, indexPath, item in
//
//            var config = UIListContentConfiguration.cell()
//            config.text = item.content
//
//            cell.contentConfiguration = config
//        }
//    }
//
//    /// 데이터 관리
//    func configureDatasource() {
//        let registeration = self.createCellRegisteration()
//        self.dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, item in
//                collectionView.dequeueConfiguredReusableCell(
//                    using: registeration,
//                    for: indexPath,
//                    item: item
//                )
//            }
//    }
//}
//
//extension CarouselViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//
//        CGSize(width: 100, height: 50)
//    }
//}
//
//import UIKit
//
//class NewViewController: UIViewController {
//
//    @IBOutlet weak var collectionView: UICollectionView! // 컬렉션뷰 사이즈: width = 315 height = 347
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addCollectionView()
//        collectionView.backgroundColor = .clear
//        self.view.backgroundColor = .brown
//    }
//
//    func addCollectionView(){
//
//        let layout = CarouselLayout()
//
//        layout.itemSize = CGSize(width: collectionView.frame.size.width*0.796, height: collectionView.frame.size.height)
//        layout.sideItemScale = 175/251
//        layout.spacing = -197
////        layout.isPagingEnabled = true
//        layout.sideItemAlpha = 0.5
//
//        collectionView.collectionViewLayout = layout
//
//        self.collectionView?.delegate = self
//        self.collectionView?.dataSource = self
//
//        self.collectionView?.register(CarouselCell.self, forCellWithReuseIdentifier: "carouselCell")
//    }
//
//
//}

extension CarouselViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MyCollectionViewCell()
        
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = .blue
        } else {
            cell.backgroundColor = .green
        }
        return cell
    }
}

extension CarouselViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point = self.targetContentOffset(scrollView, withVelocity: velocity)
        targetContentOffset.pointee = point
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
            self.collectionView.setContentOffset(point, animated: true)
        }, completion: nil)
    }
    
    func targetContentOffset(_ scrollView: UIScrollView, withVelocity velocity: CGPoint) -> CGPoint {
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        if previousOffset > collectionView.contentOffset.x && velocity.x < 0 {
            currentPage = currentPage - 1
        } else if previousOffset < collectionView.contentOffset.x && velocity.x > 0 {
            currentPage = currentPage + 1
        }
        
        let additional = (flowLayout.itemSize.width + flowLayout.minimumLineSpacing) - flowLayout.headerReferenceSize.width
        
        let updatedOffset = (flowLayout.itemSize.width + flowLayout.minimumLineSpacing) * CGFloat(currentPage) - additional
        
        previousOffset = updatedOffset
        
        return CGPoint(x: updatedOffset, y: 0)
    }
}
