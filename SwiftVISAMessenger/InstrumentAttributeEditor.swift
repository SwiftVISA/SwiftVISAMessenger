//
//  InstrumentAttributeEditor.swift
//  SwiftVISAMessenger
//
//  Created by Connor Barnes on 7/13/21.
//

import SwiftUI
import SwiftVISASwift
import SeeayaUI

struct InstrumentAttributeEditor: View {
  @Binding var attributes: MessageBasedInstrumentAttributes
  
  var body: some View {
    VStack {
      HStack {
        Text("Writing terminator: ")
        terminatorTextField("Writing terminator", value: $attributes.writeTerminator)
      }
      
      HStack {
        Text("Reading terminator: ")
        terminatorTextField("Reading terminator", value: $attributes.readTerminator)
      }
    }
  }
}

// MARK: - Subviews
private extension InstrumentAttributeEditor {
  @ViewBuilder
  func terminatorTextField(_ title: String, value: Binding<String>) -> some View {
    ValidatingTextField(title, value: value) { value in
      value.escape()
    } validate: { string in
      string.unescape()
    }
  }
}

// MARK: - Previews
struct InstrumentAttributeEditor_Previews: PreviewProvider {
  static var previews: some View {
    InstrumentAttributeEditor(attributes: .constant(.init()))
  }
}
