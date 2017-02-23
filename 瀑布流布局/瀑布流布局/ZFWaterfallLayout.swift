//
//  ZFWaterfallLayout.swift
//  瀑布流布局
//
//  Created by zhangzhifu on 2017/2/23.
//  Copyright © 2017年 seemygo. All rights reserved.
//

import UIKit

protocol ZFWaterfallLayoutDataSource : class {
    func waterfallLayout(_ layout : ZFWaterfallLayout, itemIndex : Int) -> CGFloat
}

class ZFWaterfallLayout: UICollectionViewFlowLayout {
    var cols = 2
    weak var dataSource : ZFWaterfallLayoutDataSource?
    fileprivate lazy var attributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var maxHeight : CGFloat = self.sectionInset.top + self.sectionInset.bottom
    fileprivate lazy var heights : [CGFloat] = Array(repeating: self.sectionInset.top, count: self.cols)
}

/*
var minH = sectionInset.top
for height in heights {
    if minH  > height {
        minH = height
    }
}
*/


// MARK:- 准备所有cell的布局
extension ZFWaterfallLayout {
    override func prepare() {
        super.prepare()
        
        // 1. 校验collectionView是否有值
        guard let collectionView = collectionView else { return }
        
        // 2. 获取cell的个数
        let count = collectionView.numberOfItems(inSection: 0)
        
        // 3. 遍历所有的cell,给每一个cell准备一个UICollectionViewLayoutAttributes
        let itemW = (collectionView.bounds.width - sectionInset.left - sectionInset.right - (CGFloat(cols) - 1) * minimumInteritemSpacing) / CGFloat(cols)
        
        for i in attributes.count..<count {
            // 3.1 创建UICollectionViewLayoutAttributes,并且传入indexPath
            let indexPath = IndexPath(item: i, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 3.2 给attributes设置frame
            /*
            guard let itemH = dataSource?.ZFWaterfallLayout(self, itemIndex: i) else {
                fatalError("请设置数据源,再用我的瀑布流布局")
            }
            */
            let itemH = dataSource?.waterfallLayout(self, itemIndex: i) ?? 100
            let minH = heights.min()! // 获取数组中最小的值
            let minIndex = heights.index(of: minH)! // 获取最小值对应的组数
            let itemX = sectionInset.left + (minimumInteritemSpacing + itemW) * CGFloat(minIndex)
            let itemY = minH
            
            attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
            
            // 3.3 将attribute添加到数组中
            attributes.append(attribute)
            
            // 3.4 改变minIndex位置的高度
            heights[minIndex] = attribute.frame.maxY + minimumLineSpacing
        }
        
        // 4. 获取最大的高度
        maxHeight = heights.max()! - minimumLineSpacing
    }
}


// MARK:- 告知系统我已经准备好了布局
extension ZFWaterfallLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}


// MARK:- 告诉系统滚动范围
extension ZFWaterfallLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxHeight + sectionInset.bottom)
    }
}
