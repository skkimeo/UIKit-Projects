//
//  ViewController.swift
//  dynamic tableView
//
//  Created by sun on 2022/03/24.
//

import CoreData
import UIKit


enum Section {
    case main
}

struct Item: Hashable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.id == rhs.id
    }
    

    init(content: String) {
        self.content = content
    }
    
    var content: String!
    let id = UUID()
}

class ViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Item>
    
    
    @IBOutlet weak var collectionView: UICollectionView!

    var dataSource: DataSource!
    
    let content = rawData
        .components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        .filter { !$0.isEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.configureDatasource()
        self.applyInitialSnapshot()
        
    }
}

extension ViewController {
    
    /// 처음에 데이터 연동
    func applyInitialSnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(self.content.map { Item(content: $0)} )
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    /// 각 셀에 들어갈 내용 설정
    func createCellRegisteration() -> UICollectionView.CellRegistration<CollectionViewCell, Item> {
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        
        return UICollectionView.CellRegistration<CollectionViewCell, Item>(
            cellNib: nib
        ) { cell, indexPath, item in
            
            cell.contentLabel.text = item.content
            
        }
    }
    
    func configureDatasource() {
        let registeration = self.createCellRegisteration()
        self.dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, item in
                collectionView.dequeueConfiguredReusableCell(
                    using: registeration,
                    for: indexPath
                    , item: item
                )
            }
    }
}

//extension ViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        self.content.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//
//}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let content = self.dataSource.itemIdentifier(for: indexPath)?.content
        else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
    }
}
