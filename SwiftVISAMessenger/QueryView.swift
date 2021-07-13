//
//  QueryView.swift
//  SwiftVISAMessenger
//
//  Created by Connor Barnes on 7/12/21.
//

import SwiftUI
import SwiftVISASwift

@MainActor
struct QueryView: View {
  @State private var lastMessage = ""
  @State private var nextMessage = ""
  @State private var performingOperation = false
  var instrument: MessageBasedInstrument
  @Binding var error: String?
  
  var body: some View {
    VStack(alignment: .leading){
      HStack {
        Text("Message: ")
          .foregroundColor(.secondary)
        
        Text(lastMessage)
      }
      
      TextField("Write", text: $nextMessage)
      
      HStack {
        Button("Read") {
          self.performingOperation = true
          
          Task {
            do {
              async let message = instrument.read()
              self.lastMessage = try await message
              self.error = nil
              self.performingOperation = false
            } catch {
              self.lastMessage = ""
              self.error = "\(error)"
              self.performingOperation = false
            }
          }
        }
        
        Button("Write") {
          self.performingOperation = true
          
          Task {
            do {
              try await instrument.write(nextMessage)
              self.error = nil
              self.performingOperation = false
            } catch {
              self.error = "\(error)"
              self.performingOperation = false
            }
          }
        }
        
        Button("Query") {
          performingOperation = true
          
          Task {
            do {
              async let message = instrument.query(nextMessage)
              self.lastMessage = try await message
              self.error = nil
              self.performingOperation = false
            } catch {
              self.lastMessage = ""
              self.error = "\(error)"
              self.performingOperation = false
            }
          }
        }
      }
      .disabled(performingOperation)
    }
  }
}

// MARK: - Previews
struct QueryView_Previews: PreviewProvider {
  static var previews: some View {
    QueryView(instrument: MockInstrument(), error: .constant(nil))
      .padding()
  }
}
