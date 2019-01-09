import UIKit
class FilesCollectionViewLayout: UICollectionViewLayout {
    var rects = [CGRect]() {
        didSet {
            invalidateLayout()
        }
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    override var collectionViewContentSize: CGSize {
        return self.collectionView?.frame.size ?? .zero
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var index = 0
        return rects.compactMap { (itemRect: CGRect) -> UICollectionViewLayoutAttributes? in
            let attrs = rect.intersects(itemRect) ? self.layoutAttributesForItem(at: IndexPath(item: index, section: 0)) : nil
            index += 1
            return attrs
        }
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attrs.frame = rects[indexPath.item]
        return attrs
    }
}
