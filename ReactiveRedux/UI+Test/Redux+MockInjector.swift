//
//  Redux+MockInjector.swift
//  ReactiveRedux
//
//  Created by Hai Pham on 12/11/18.
//  Copyright © 2018 Holmusk. All rights reserved.
//

import Foundation

extension Redux.UI {
  
  /// Prop injector subclass that can be used for testing. For example:
  ///
  ///     class ViewController: ReduxCompatibleView {
  ///       var staticProps: StaticProps?
  ///       ...
  ///     }
  ///
  ///     func test() {
  ///       ...
  ///       let injector = MockInjector(...)
  ///       vc.staticProps = StaticProps(injector)
  ///       ...
  ///     }
  ///
  /// This class keeps track of the injection count for each Redux-compatible
  /// view.
  public final class MockInjector<State>: PropInjector<State> {
    private var _injectCount: [String : Int]
    private var _lock: pthread_rwlock_t
    
    override public init<S>(store: S) where
      S: ReduxStoreType, S.State == State
    {
      self._injectCount = [:]
      self._lock = pthread_rwlock_t()
      super.init(store: store)
      pthread_rwlock_init(&self._lock, nil)
    }
    
    deinit { pthread_rwlock_destroy(&self._lock) }
    
    override public func injectProps<VC, MP>(
      controller: VC, outProps: VC.OutProps, mapper: MP.Type) where
      MP: ReduxPropMapperType,
      MP.ReduxView == VC,
      VC: UIViewController,
      VC.ReduxState == State
    {
      self.addInjecteeCount(controller)
    }
    
    override public func injectProps<V, MP>(
      view: V, outProps: V.OutProps, mapper: MP.Type) where
      MP: ReduxPropMapperType,
      MP.ReduxView == V,
      V: UIView,
      V.ReduxState == State
    {
      self.addInjecteeCount(view)
    }
    
    /// Check if a Redux view has been injected as many times as specified.
    ///
    /// - Parameters:
    ///   - view: A Redux-compatible view.
    ///   - times: An Int value.
    /// - Returns: A Bool value.
    public func didInject<View>(_ view: View, times: Int) -> Bool where
      View: ReduxCompatibleViewType
    {
      return self.getInjecteeCount(view) == times
    }
    
    private func read<T>(_ fn: () -> T) -> T {
      pthread_rwlock_rdlock(&self._lock)
      defer { pthread_rwlock_unlock(&self._lock) }
      return fn()
    }
    
    private func modify(_ fn: () -> Void) {
      pthread_rwlock_wrlock(&self._lock)
      defer { pthread_rwlock_unlock(&self._lock) }
      fn()
    }
    
    private func addInjecteeCount(_ id: String) {
      self.modify {
        self._injectCount[id] = self._injectCount[id, default: 0] + 1
      }
    }
    
    private func addInjecteeCount<View>(_ view: View) where
      View: ReduxCompatibleViewType
    {
      self.addInjecteeCount(String(describing: view))
    }
    
    private func getInjecteeCount(_ id: String) -> Int {
      return self.read { self._injectCount[id, default: 0] }
    }
    
    private func getInjecteeCount<View>(_ view: View) -> Int where
      View: ReduxCompatibleViewType
    {
      return self.getInjecteeCount(String(describing: view))
    }
  }
}