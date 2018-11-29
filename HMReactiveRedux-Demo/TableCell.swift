//
//  TableCell.swift
//  HMReactiveRedux-Demo
//
//  Created by Hai Pham on 11/29/18.
//  Copyright © 2018 Holmusk. All rights reserved.
//

import HMReactiveRedux
import UIKit

final class TableCell: UITableViewCell {
  @IBOutlet private weak var textInput: UITextField!
  
  var textIndex: Int?
  var staticProps: StaticProps?
  
  var variableProps: VariableProps? {
    didSet {
      if let props = self.variableProps {
        self.didSetProps(props)
      }
    }
  }
  
  private func didSetProps(_ props: VariableProps) {
    textInput.text = props.nextState.text
  }
  
  @IBAction func updateText(_ sender: UITextField) {
    self.variableProps?.dispatch.updateText(sender.text)
  }
}

extension TableCell: ReduxCompatibleViewType {
  struct StateProps: Equatable {
    let text: String?
  }
  
  struct DispatchProps {
    let updateText: (String?) -> Void
  }
}