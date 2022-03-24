//
//  TagCollectionViewFlowLayout.swift
//  DynamicCollectionView
//
//  Created by sun on 2022/03/24.
//

import UIKit

class TagCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        print(#function)
    }
    
    override var collectionViewContentSize: CGSize {
        print("CollectionViewContentSize")
        
        return super.collectionViewContentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        print(#function)
        
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
        else { return [] }
        
        let leftMargin = self.sectionInset.left
        
        for (index, value) in attributes.enumerated() {
            guard value.frame.origin.x != leftMargin,
                  index - 1 >= 0
            else { continue }
            
            let previousCellmaxX = attributes[index - 1].frame.maxX
            
            value.frame.origin.x = previousCellmaxX + self.minimumLineSpacing
        }
        
        return attributes
    }
}
