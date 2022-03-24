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
        
//        let layout = TagCollectionViewLayout()
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
//        layout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)

        self.collectionView.collectionViewLayout = layout
        
        
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
    func createCellRegisteration() -> UICollectionView.CellRegistration<TagCell, Item> {
        
//        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        
        return UICollectionView.CellRegistration<TagCell, Item> { cell, indexPath, item in
            
            cell.noteImageView.backgroundColor = [
                UIColor.systemBlue,
                .systemGreen,
                .systemYellow]
                .randomElement()!
                .withAlphaComponent(0.5)
//            cell.frame.size = CGSize(width: label.frame.width + 16, height: label.frame.height + 16)
            cell.firstWordLabel.text = item.content
        }
    }
    
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


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let content = dataSource.itemIdentifier(for: indexPath)?.content
        else { return .zero }
        let label = UILabel().then {
            $0.font = .systemFont(ofSize: 17)
            $0.text = content
            $0.sizeToFit()
        }
//        print(#function)
        let labelSize = label.frame.size
        return CGSize(width: labelSize.width + 16, height: labelSize.height + 16)
//        return
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let attributes = super.layoutAttributesForElements(in: rect)
    
    var leftMargin = sectionInset.left
    var maxY: CGFloat = -1.0
    attributes?.forEach { layoutAttribute in
      if layoutAttribute.representedElementCategory == .cell {
        if layoutAttribute.frame.origin.y >= maxY {
          leftMargin = sectionInset.left
        }
        layoutAttribute.frame.origin.x = leftMargin
        leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
        maxY = max(layoutAttribute.frame.maxY, maxY)
      }
    }
    return attributes
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
