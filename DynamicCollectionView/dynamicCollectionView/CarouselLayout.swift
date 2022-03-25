//
//  CarouselLayout.swift
//  DynamicCollectionView
//
//  Created by sun on 2022/03/25.
//

import UIKit

/// 캐러셀 뷰를 만들기 위해 사용하는 플로우 레이아웃
class CarouselLayout: UICollectionViewFlowLayout {
    
    // MARK: - Properties
    
    /// 좌우로 보일 아이템의 크기
    var sideItemScale: CGFloat = 0.5
    
    /// 좌우로 보일 아이템의 불투명도
    var sideItemAlpha: CGFloat = 0.5
    
    /// 아이템들 간 간격
    var spacing: CGFloat = 10
    
    /// 페이징 여부
    var isPagingEnables = false
    
    private var isSetup = false
    
    
    // MARK: - Functions
    
    override func prepare() {
        super.prepare()
        
        if !self.isSetup {
            self.setupLayout()
            self.isSetup.toggle()
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
        else { return nil }
        
        return attributes.map { self.transformLayoutAttributes($0) }
    }
    
    /// 최초에 캐러셀 뷰를 위한 기본 레이아웃을 설정하는 메서드
    private func setupLayout() {
        guard let collectionView = self.collectionView
        else { return }
        
        let collectionViewSize = collectionView.bounds.size
        
        let horizontalInset = (collectionViewSize.width - self.itemSize.width) / 2
        let verticalInset = (collectionViewSize.height - self.itemSize.height) / 2
        
        /// 가운데에 있을 아이템의 인셋 설정
        self.sectionInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
        
        let itemWidth = self.itemSize.width
        
        /// 처음에는 spacing 이 0이라고 하면,
        /// 좌우에 있는 아이템은 scale 만큼 축소했으므로 해당 아이템의 원래 영역에서 남게 되는 여백을 2로 나눠서 오프셋으로 설정
        let scaledItemOffset = itemWidth * (1 - self.sideItemScale) / 2
        /// 그러면 설정하려던 spacing 중의 일부를 scaledItemOffset 이 차지했으므로 이를 빼고 나머지를 minimumLinsSpacing 으로 설정
        self.minimumLineSpacing = self.spacing - scaledItemOffset
        
        self.scrollDirection = .horizontal
    }
    
    private func transformLayoutAttributes(
        _ attributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        
        guard let collectionView = self.collectionView
        else { return attributes }
        
        /// 컬렉션 뷰 중앙값(고정)
        let collectionViewCenter = collectionView.frame.size.width
        /// 사용자가 스크롤할 때 기준점으로부터 이동한 거리(가변)
        let contentOffset = collectionView.contentOffset.x
        /// 각 아이템들의 중앙값(가변)
        let itemCenter = attributes.center.x - contentOffset
        
        /// 두 아이템 사이의 거리(고정)
        let maxDistance = self.itemSize.width + self.minimumLineSpacing
        /// 컬렉션 뷰 중앙과 아이템 중앙 사이의 거리(가변)
        let distance = min(abs(collectionViewCenter - itemCenter), maxDistance)
        
        /// 컬렉션 뷰 중앙에 오면 1이 되고, 멀어지면 0이 됨
        /// 거리를 기준으로 투명도, 크기를 조정하기 위한 값
        let ratio = (maxDistance - distance) / maxDistance
        
        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemAlpha
        
        attributes.alpha = alpha
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let offset = attributes.frame.midX - visibleRect.midX
        
        var transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        transform = CATransform3DTranslate(transform, .zero, .zero, -abs(offset/1000))
        
        return attributes
    }
}
