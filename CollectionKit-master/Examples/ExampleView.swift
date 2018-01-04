//
//  ExampleView.swift
//  CollectionKitExample
//
//  Created by Luke Zhao on 2017-09-04.
//  Copyright © 2017 lkzhao. All rights reserved.
//

import UIKit
import CollectionKit

//MARK: 展示视图
//展示的Collection示例的背景视图
class ExampleView: UIView {
  let titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.font = .boldSystemFont(ofSize: 24)
    return titleLabel
  }()

  let cardView: UIView = {
    let cardView = UIView()
    cardView.backgroundColor = .white
    cardView.layer.cornerRadius = 8
    cardView.layer.shadowColor = UIColor.black.cgColor
    cardView.layer.shadowOffset = CGSize(width: 0, height: 12)
    cardView.layer.shadowRadius = 10
    cardView.layer.shadowOpacity = 0.1
    cardView.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
    cardView.layer.borderWidth = 0.5
    return cardView
  }()

  private var contentVC: UIViewController?

  /**
   对于懒加载创建并且使用AutoLayout的自定义视图, 我们可能无法再初始化方法里面获取到该视图的frame
   因此我们可以在初始化方法里添加自视图, 在layoutSubviews方法里面对视图进行布局
   */
  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(titleLabel)
    addSubview(cardView)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    let size = titleLabel.sizeThatFits(bounds.size)
    titleLabel.frame = CGRect(origin: CGPoint(x: 0, y: 10), size: size)
    let labelHeight = titleLabel.frame.maxY + 10
    cardView.frame = CGRect(x: 0, y: labelHeight, width: bounds.width, height: bounds.height - labelHeight)
    contentVC?.view.frame = cardView.bounds
  }
  
  // 添加视图控制器视图的方法
  func populate(title: String,
                contentViewControllerType: UIViewController.Type) {
    titleLabel.text = title
    contentVC?.view.removeFromSuperview()
    contentVC = contentViewControllerType.init()
    let contentView = contentVC!.view!
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = 8
    cardView.addSubview(contentView)
    //重新调用layoutSubviews()
    setNeedsLayout()
  }
}
