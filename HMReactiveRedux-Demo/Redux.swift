//
//  Redux.swift
//  HMReactiveRedux-Demo
//
//  Created by Hai Pham on 11/22/18.
//  Copyright © 2018 Holmusk. All rights reserved.
//

import HMReactiveRedux
import SafeNest

extension UIViewController {
  typealias PropsConnector = ReduxConnector<RxReduxStore<SafeNest>>
}

extension UIView {
  typealias PropsConnector = ReduxConnector<RxReduxStore<SafeNest>>
}

final class Redux {
  typealias Action = ReduxActionType
  typealias State = SafeNest
  
  final class Path {
    static var rootPath: String {
      return "main"
    }
    
    static var numberPath: String {
      return "\(Path.rootPath).number"
    }
    
    static var stringPath: String {
      return "\(Path.rootPath).string"
    }
    
    static var sliderPath: String {
      return "\(Path.rootPath).slider"
    }
    
    static var textPath = "\(Path.rootPath).texts"
    
    static func textItemPath(_ textIndex: Int) -> String {
      return "\(textPath).\(textIndex)"
    }
  }
  
  enum ClearAction: ReduxActionType {
    case triggerClear
    case resetClear
    
    static var path: String {
      return "clear"
    }
    
    static var clearPath: String {
      return "\(path).value"
    }
  }
  
  enum NumberAction: Action {
    case add
    case minus
  }
  
  enum StringAction: Action {
    case input(String?)
  }
  
  enum SliderAction: Action {
    case input(Double)
  }
  
  enum TextAction: Action {
    case input(Int, String?)
    case delete(Int)
  }
  
  final class Reducer {
    static func main(_ state: State, _ action: Action) -> SafeNest {
      do {
        switch action {
        case let action as ClearAction: return try clear(state, action)
        case let action as NumberAction: return try number(state, action)
        case let action as StringAction: return try string(state, action)
        case let action as SliderAction: return try slider(state, action)
        case let action as TextAction: return try text(state, action)
        default: return state
        }
      } catch (let e) {
        fatalError(e.localizedDescription)
      }
    }
    
    static func clear(_ state: State, _ action: ClearAction) throws -> State {
      switch action {
      case .triggerClear:
        return try state
          .updating(at: Path.numberPath, value: nil)
          .updating(at: Path.stringPath, value: nil)
          .updating(at: Path.sliderPath, value: nil)
          .updating(at: ClearAction.clearPath, value: true)
        
      case .resetClear:
        return try state.updating(at: ClearAction.clearPath, value: nil)
      }
    }
    
    static func number(_ state: State, _ action: NumberAction) throws -> State {
      switch action {
      case .add:
        return try state.mapping(at: Path.numberPath, withMapper: {
          return $0.cast(Int.self).getOrElse(0) + 1
        })
        
      case .minus:
        return try state.mapping(at: Path.numberPath, withMapper: {
          return $0.cast(Int.self).getOrElse(0) - 1
        })
      }
    }
    
    static func string(_ state: State, _ action: StringAction) throws -> State {
      switch action {
      case .input(let string):
        return try state.updating(at: Path.stringPath, value: string)
      }
    }
    
    static func slider(_ state: State, _ action: SliderAction) throws -> State {
      switch action {
      case .input(let value):
        return try state.updating(at: Path.sliderPath, value: value)
      }
    }
    
    static func text(_ state: State, _ action: TextAction) throws -> State {
      switch action {
      case .input(let index, let value):
        return try state.updating(at: Path.textItemPath(index), value: value)
        
      case .delete(let index):
        let mapper: State.TypedMapper<[String?], [String?]> = {
          var arrCopy = $0
          arrCopy?.remove(at: index)
          return arrCopy
        }
        
        return try state.mapping(at: Path.textPath, withMapper: mapper)
      }
    }
  }
}
