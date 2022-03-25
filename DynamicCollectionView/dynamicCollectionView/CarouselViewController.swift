//
//  CarouselViewController.swift
//  DynamicCollectionView
//
//  Created by sun on 2022/03/25.
//

import UIKit

class CarouselViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Item>
    
    var snapshot: Snapshot!
    var dataSource: DataSource!
    var start: IndexPath!
    
    let content = rawData
        .components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        .filter { !$0.isEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.configureCollectionView()
        self.configureDatasource()
        self.applyInitialSnapshot()
        self.collectionView.scrollToItem(at: start, at: .centeredHorizontally, animated: true)
    }
    
    func configureCollectionView() {
        let layout = CarouselLayout()
        
        layout.itemSize = CGSize(width: 100, height: 50)
        layout.sideItemScale = 0.5
        layout.spacing = 10
        layout.sideItemAlpha = 0.5
        
        self.collectionView.collectionViewLayout = layout
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CarouselViewController {
    
    /// 처음에 데이터 연동
    func applyInitialSnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(self.content.map { Item(content: $0)} )
        
        self.snapshot = snapshot
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    /// 각 셀에 들어갈 내용 설정
    func createCellRegisteration() -> UICollectionView.CellRegistration<UICollectionViewCell, Item> {
        
//        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        return UICollectionView.CellRegistration<UICollectionViewCell, Item> { cell, indexPath, item in
            
            var config = UIListContentConfiguration.cell()
            config.text = item.content
            
            cell.contentConfiguration = config
        }
    }
    
    /// 데이터 관리
    func configureDatasource() {
        let registeration = self.createCellRegisteration()
        self.dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, item in
                collectionView.dequeueConfiguredReusableCell(
                    using: registeration,
                    for: indexPath,
                    item: item
                )
            }
    }
}

extension CarouselViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        CGSize(width: 100, height: 50)
    }
}
