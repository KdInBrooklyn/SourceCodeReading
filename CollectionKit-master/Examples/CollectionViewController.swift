//
//  CollectionViewController.swift
//  CollectionKitExample
//
//  Created by Luke Zhao on 2017-09-04.
//  Copyright © 2017 lkzhao. All rights reserved.
//

import UIKit
import CollectionKit

//控制器基类
class CollectionViewController: UIViewController {
  let collectionView = CollectionView()

  var provider: AnyCollectionProvider {
    get { return collectionView.provider }
    set { collectionView.provider = newValue } //CollectionKit的使用规则是: 根据数据源和视图创建provider, 然后赋值给CollectionView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
  }
  
  //对视图进行布局
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.frame = view.bounds
  }
}
