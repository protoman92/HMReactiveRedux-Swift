//
//  Redux+Saga.swift
//  ReactiveRedux-Demo
//
//  Created by Hai Pham on 12/4/18.
//  Copyright © 2018 Hai Pham. All rights reserved.
//

import ReactiveRedux
import SafeNest

final class AppReduxSaga {
  typealias State = SafeNest
  
  static func extractAutocompleteInput(_ action: AppRedux.Action) -> String? {
    switch action {
    case .string(let input): return input
    default: return nil
    }
  }
  
  static func autocompleteSaga(_ input: String) -> Redux.Saga.Effect<State, Any> {
    return Redux.Saga.Effect<State, Bool>
      .just(true).put(AppRedux.Action.progress)
      .then(input).call(Api.performAutocomplete)
      .doOnError({print($0)})
      .catchError({["Error was caught: \($0)"]})
      .doOnValue({print($0)})
      .delay(bySeconds: 0.5)
      .put(AppRedux.Action.texts)
      .then(false).put(AppRedux.Action.progress)
  }
  
  static func sagas() -> [Redux.Saga.Effect<State, Any>] {
    return [
      Redux.Saga.Effect.takeEvery(
        paramExtractor: extractAutocompleteInput,
        effectCreator: autocompleteSaga,
        options: Redux.Saga.TakeOptions.builder().with(debounce: 0.5).build())
    ]
  }
}
