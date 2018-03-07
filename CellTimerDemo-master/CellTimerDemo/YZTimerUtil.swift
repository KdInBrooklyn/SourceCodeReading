//
//  YZTimerUtil.swift
//  CellTimerDemo
//
//  Created by Yasin on 2017/9/12.
//  Copyright © 2017年 Yasin. All rights reserved.
//

import UIKit

let reloadTimeInterval: TimeInterval = 15

@objc protocol TimerListener: class {
    func didOnTimer(announcer: YZTimerUtil, timeInterval: TimeInterval)
}

class YZTimerUtil: NSObject {
    static let sharedInstance = YZTimerUtil()
    
    //用于弱引用添加遵守了TimerLisenter协议的对象, 因为Set默认对元素是持有强引用,会导致循环引用的发生
    private let map: NSHashTable<TimerListener> = NSHashTable<TimerListener>.weakObjects()
    private var timer:Timer?
    
    /// 和服务器时间差,用于服务器时间同步
    var serverTimeInterval: TimeInterval = 0
    /// 和服务器时间对比后的当前时间戳
    var nowTimeInterval = NSDate().timeIntervalSince1970
    
    override init() {
        super.init()
        // 默认暂停定时器,定时器默认是加载到当前runloop中的，在进行UI界面操作比如滑动列表时，由于在main runloop中NSTimer是同步交付的被“阻塞”，就会导致NSTimer计时出现延误
        // 解决这种延误的方法，一种是在子线程中进行NSTimer的操作，在主线程中修改UI界面显示操作结果；另一种是仍然在主线程中进行NSTimer操作，但是将NSTimer实例加到main runloop的特定mode（模式）中。避免被复杂运算操作或者UI界面刷新所干扰。
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[unowned self] (_) in
            self.onTimer()
        })
        //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true) //这种方法要求onTimer是@objc
        timerPause()
    }
    
    // MARK: - public methods
    //添加新的需要倒计时显示的对象
    func addListener(listener: TimerListener) {
        map.add(listener)
    }
    //移除相关的对象,主要用于在需要倒计时显示的对象被销毁时将其移除.
    func removeListener(listener: TimerListener) {
        map.remove(listener)
    }
    
    /// 从服务器请求最新的时间
    func resetServerTime() {
        // 从服务器请求最新的时间
        // 。。。
        var success = true
        
        if success {
            // 请求成功
            serverTimeInterval = 0
        } else {
            // 如果请求失败，隔一段时间再请求一次
            perform(#selector(resetServerTime), with: nil, afterDelay: reloadTimeInterval)
        }
    }
    
    /// 当没有定时器需求的时候暂停定时器
    func timerPause() {
        timer?.fireDate = Date.distantFuture
    }
    
    /// 启动定时器
    func timerStart() {
        timer?.fireDate = Date.distantPast
    }
    
    /// 提供时间差值计算方法
    ///
    /// - Parameter time: 比如限时活动开始时间、结束时间
    /// - Returns: 时间差
    func lefTimeInterval(time: TimeInterval) -> TimeInterval {
        let leftTime = time - self.nowTimeInterval
        return leftTime
    }
    
    // MARK: private method
    private func onTimer() {
        //将服务器返回的时间节点和当前时间进行做差比较
        nowTimeInterval = NSDate().timeIntervalSince1970 - serverTimeInterval
        //将时间间隔通过协议方法的形式发送出去
        for listener in self.map.allObjects {
            listener.didOnTimer(announcer: self, timeInterval: self.nowTimeInterval)
        }
    }

}
