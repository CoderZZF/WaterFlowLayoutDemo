//
//  ViewController.swift
//  瀑布流布局
//
//  Created by zhangzhifu on 2017/2/23.
//  Copyright © 2017年 seemygo. All rights reserved.
//

import UIKit

private let kTestCellID = "kTestCellID"

class ViewController: UIViewController {

    fileprivate var itemCount = 30
    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = ZFWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.cols = 2
        layout.dataSource = self
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kTestCellID)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.addSubview(collectionView)
    }
}


extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTestCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        
        if indexPath.item == itemCount - 1 {
            itemCount += 30
            collectionView.reloadData()
        }
        
        return cell
    }
}


extension ViewController : ZFWaterfallLayoutDataSource {
    func waterfallLayout(_ layout: ZFWaterfallLayout, itemIndex: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(150) + 100)
    }
}
