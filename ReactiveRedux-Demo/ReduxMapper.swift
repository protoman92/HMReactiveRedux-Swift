//
//  ReduxMapper.swift
//  ReactiveRedux-Demo
//
//  Created by Hai Pham on 11/28/18.
//  Copyright © 2018 Hai Pham. All rights reserved.
//

import ReactiveRedux
import SafeNest

extension ViewController: ReduxPropMapperType {
  typealias ReduxState = SafeNest
  
  static func map(state: ReduxState, outProps: OutProps) -> StateProps {
    return state
      .decode(at: AppRedux.Path.rootPath, ofType: StateProps.self)
      .getOrElse(StateProps())
  }
  
  static func map(dispatch: @escaping Redux.Dispatch,
                  outProps: OutProps) -> DispatchProps {
    return DispatchProps(
      incrementNumber: {dispatch(AppRedux.NumberAction.add)},
      decrementNumber: {dispatch(AppRedux.NumberAction.minus)},
      updateSlider: {dispatch(AppRedux.SliderAction.input($0))},
      updateString: {dispatch(AppRedux.StringAction.input($0))},
      deleteText: {dispatch(AppRedux.TextAction.delete($0))},
      addOneText: {dispatch(AppRedux.TextAction.addItem)}
    )
  }
}

extension ConfirmButton: ReduxPropMapperType {
  typealias ReduxState = SafeNest
  
  static func map(state: ReduxState, outProps: OutProps) -> StateProps {
    return StateProps()
  }
  
  static func map(dispatch: @escaping Redux.Dispatch,
                  outProps: OutProps) -> DispatchProps {
    return DispatchProps(
      confirmEdit: {dispatch(AppRedux.ClearAction.triggerClear)}
    )
  }
}

extension TableCell: ReduxPropMapperType {
  typealias ReduxState = SafeNest
  
  static func map(state: ReduxState, outProps: OutProps) -> StateProps {
    return StateProps(
      text: state.value(at: AppRedux.Path
        .textItemPath(outProps))
        .cast(String.self).value
    )
  }
  
  static func map(dispatch: @escaping Redux.Dispatch,
                  outProps: OutProps) -> DispatchProps {
    return DispatchProps(
      updateText: {dispatch(AppRedux.TextAction.input(outProps, $0))}
    )
  }
}
