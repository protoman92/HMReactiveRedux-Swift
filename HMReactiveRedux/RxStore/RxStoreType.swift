//
//  RxReduxStoreType.swift
//  HMReactiveRedux
//
//  Created by Hai Pham on 27/10/17.
//  Copyright © 2017 Hai Pham. All rights reserved.
//

import RxSwift

/// Classes that implement this protocol should act as a redux-compliant store.
public protocol RxReduxStoreType: ReduxStoreType, RxReduxStateFactoryType {
  typealias Action = ReduxActionType

  /// Trigger an action.
  func actionTrigger() -> AnyObserver<Action?>

  /// Subscribe to this stream to receive state notifications.
  func stateStream() -> Observable<State>
}

public extension RxReduxStoreType {

  /// Dispatch an action.
  ///
  /// - Parameter action: An Action instance.
  public func dispatch(_ action: Action) {
    actionTrigger().onNext(action)
  }
}