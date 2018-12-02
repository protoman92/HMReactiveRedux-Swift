//
//  ReduxCompatibleView.swift
//  ReactiveRedux
//
//  Created by Hai Pham on 11/28/18.
//  Copyright © 2018 Hai Pham. All rights reserved.
//

import UIKit

/// A view that conforms to this protocol can receive state/action props and
/// subscribe to state changes.
public protocol ReduxCompatibleViewType: class {
  associatedtype PropInjector: ReduxPropInjectorType
  
  /// This props represents data that is directly related to the parent view/
  /// view controller. For example, when we inject a table view cell, this may
  /// contain the index of that cell - which will be used to create variable
  /// props.
  associatedtype OutProps
  
  /// This represents variable state that can be used to update the UI.
  associatedtype StateProps
  
  /// This represents a set of actions that can be used to handle user
  /// interactions.
  associatedtype ActionProps
  
  typealias StaticProps = Redux.StaticProps<PropInjector>
  typealias VariableProps = Redux.VariableProps<StateProps, ActionProps>
  
  /// This prop container includes static dependencies that can be used to
  /// wire up child views/view controllers.
  var staticProps: StaticProps? { get set }
  
  /// This prop container includes variable state/action props.
  var variableProps: VariableProps? { get set }
}

/// Generally the redux view also implements the prop mapper protocol, so in
/// this case we can define some default generics.
public extension ReduxCompatibleViewType where Self: ReduxPropMapperType {
  public typealias ReduxView = Self
}