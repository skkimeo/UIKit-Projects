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
    
    var snapshot: Snapshot!
    
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
        
        let layout = TagCollectionViewLayout()
//        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
//        layout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)

        self.collectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
}

extension ViewController {
    
    /// 처음에 데이터 연동
    func applyInitialSnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(self.content.map { Item(content: $0)} )
        
        self.snapshot = snapshot
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
            cell.firstWordLabel.text = item.content
            
            let isEven = indexPath.row % 2 == 0
//            let duration: Double = isEven ? 2 : 4
            let duration: Double = 3
            let scale: CGFloat = isEven ? 0.9 : 1.1
            let delay: Double = isEven ? 0: scale / 2
            UIView.animate(
                withDuration: duration,
                delay: delay,
                options: [.autoreverse, .repeat, .allowUserInteraction]) {
                    cell.contentView.transform = cell.contentView.transform.scaledBy(x: scale, y: scale)
                } 
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
        
        let labelSize = label.frame.size
        /// 라벨 크기에 여백 추가해서 리턴
        return CGSize(width: labelSize.width + 16, height: labelSize.height + 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        guard let content = self.dataSource.itemIdentifier(for: indexPath)?.content
        else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        let detailViewController = UIViewController().then {
            $0.view.backgroundColor = .systemTeal
        }
        
        self.snapshot = self.dataSource.snapshot()
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}
