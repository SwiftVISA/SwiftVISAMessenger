//
//  ContentView.swift
//  SwiftVISAMessenger
//
//  Created by Connor Barnes on 7/12/21.
//

import SwiftUI
import SeeayaUI
import SwiftVISASwift

struct ContentView: View {
  @State private var instrument: MessageBasedInstrument?
  @State private var ipAddress: String = ""
  @State private var port: Int = 5025
  @State private var connecting = false
  @State private var error: String?
  
  var body: some View {
    VStack {
      ZStack {
        HStack {
          Image(systemName: instrument == nil ? "xmark.circle" : "checkmark.circle")
            .foregroundColor(instrument == nil ? .red : .green)
          
          Spacer()
        }
        Text("Instrument Configuration")
      }
      .font(.title)
      
      HStack {
        HStack {
          Text("IP Address: ")
          TextField("IP Address", text: $ipAddress)
        }
        
        portTextField
        
        Button("Connect") {
          connecting = true
          instrument = nil
          Task {
            await connectToInstrument()
          }
        }
        .disabled(connecting)
      }
      
      Divider()
      
      if let instrument = instrument {
        QueryView(instrument: instrument, error: $error)
        
        Divider()
        
        InstrumentAttributeEditor(attributes: Binding($instrument)!.attributes)
      }
      
      Spacer()
      
      if let error = error {
        HStack {
          Image(systemName: "exclamationmark.triangle.fill")
            .foregroundColor(.red)
          Text(error)
          Spacer()
        }
      }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

// MARK: - Subviews
private extension ContentView {
  @ViewBuilder
  var portTextField: some View {
    HStack {
      Text("Port: ")
      
      ValidatingTextField("Port", value: $port) { value in
        String(value)
      } validate: { string in
        guard let value = Int(string),
              value >= 0
        else {
          return nil
        }
        return value
      } errorMessage: { string in
        "Invalid port"
      }
    }
  }
}

// MARK: - Helpers
private extension ContentView {
  func connectToInstrument() async {
    defer {
      connecting = false
    }
    
    do {
      let instrument = try await InstrumentManager.shared
        .instrumentAt(address: ipAddress, port: port, timeout: 10)
      
      self.error = nil
      self.instrument = instrument
    } catch {
      self.error = "\(error)"
      instrument = nil
    }
  }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
