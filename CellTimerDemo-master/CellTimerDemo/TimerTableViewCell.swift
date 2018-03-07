//
//  TimerTableViewCell.swift
//  CellTimerDemo
//
//  Created by Yasin on 2017/9/12.
//  Copyright © 2017年 Yasin. All rights reserved.
//

import UIKit

class TimerTableViewCell: UITableViewCell, TimerListener {
    
    var time = NSDate().timeIntervalSince1970 {
        didSet {
            onTimer()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //在加载是添加倒计时监听者
        YZTimerUtil.sharedInstance.addListener(listener: self)
    }
    
    deinit {
        YZTimerUtil.sharedInstance.removeListener(listener: self)
    }
    
    //MARK: 协议方法
    func didOnTimer(announcer: YZTimerUtil, timeInterval: TimeInterval) {
        onTimer()
    }
    
    private func onTimer() {
        let leftTime = YZTimerUtil.sharedInstance.lefTimeInterval(time: time)
        if leftTime > 0 {
            self.detailTextLabel?.text = "倒计时 \(Int(leftTime)/3600):\(Int(leftTime)/60%60):\(Int(leftTime)%60)"
        } else {
            self.detailTextLabel?.text = "活动已开始"
        }
    }
}
