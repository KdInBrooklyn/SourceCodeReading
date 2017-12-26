//
//  ServiceProvider.swift
//  RxTodo
//
//  Created by Suyeol Jeon on 12/01/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

// 协议声明时带一个class关键字表明该协议只能由类来继承
protocol ServiceProviderType: class {
  //存储服务
  var userDefaultsService: UserDefaultsServiceType { get }
  //提醒服务
  var alertService: AlertServiceType { get }
  //任务服务
  var taskService: TaskServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
  lazy var userDefaultsService: UserDefaultsServiceType = UserDefaultsService(provider: self)
  lazy var alertService: AlertServiceType = AlertService(provider: self)
  lazy var taskService: TaskServiceType = TaskService(provider: self)
}
