//
//  AlertService.swift
//  RxTodo
//
//  Created by Suyeol Jeon on 29/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxSwift
import URLNavigator

protocol AlertActionType {
  var title: String? { get }
  var style: UIAlertActionStyle { get }
}

extension AlertActionType {
  var style: UIAlertActionStyle {
    return .default
  }
}

// MARK: AlertServiceType
protocol AlertServiceType: class {
  func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertControllerStyle,
    actions: [Action]
  ) -> Observable<Action>
}

final class AlertService: BaseService, AlertServiceType {

  //实现AlertServiceType协议的方法
  func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertControllerStyle,
    actions: [Action]
  ) -> Observable<Action> {
    return Observable.create { observer in
      let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
      for action in actions {
        let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
          observer.onNext(action)
          observer.onCompleted()
        }
        alert.addAction(alertAction)
      }
      Navigator.present(alert)
      return Disposables.create {
        alert.dismiss(animated: true, completion: nil)
      }
    }
  }

}
