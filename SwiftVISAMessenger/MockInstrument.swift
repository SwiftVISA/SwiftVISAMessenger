//
//  MockInstrument.swift
//  SwiftVISAMessenger
//
//  Created by Connor Barnes on 7/12/21.
//

import Foundation
import CoreSwiftVISA

actor MockSession: Session {
  func close() async throws {
    // Do nothing
  }
  
  func reconnect(timeout: TimeInterval) async throws {
    // Do nothing
  }
}

class MockInstrument {
  var lastMessage = ""
  var attributes = MessageBasedInstrumentAttributes()
  private var _session: MockSession
  
  init() {
    _session = MockSession()
  }
}

extension MockInstrument: Instrument {
  var session: Session {
    return _session
  }
}

extension MockInstrument: MessageBasedInstrument {
  func read(until terminator: String, strippingTerminator: Bool, encoding: String.Encoding, chunkSize: Int) async throws -> String {
    return lastMessage
  }
  
  func readBytes(length: Int, chunkSize: Int) async throws -> Data {
    fatalError("Unimplemented")
  }
  
  func readBytes(maxLength: Int?, until terminator: Data, strippingTerminator: Bool, chunkSize: Int) async throws -> Data {
    fatalError("Unimplemented")
  }
  
  func write(_ string: String, appending terminator: String?, encoding: String.Encoding) async throws -> Int {
    lastMessage = string + (terminator ?? "")
    return string.count
  }
  
  func writeBytes(_ data: Data, appending terminator: Data?) async throws -> Int {
    fatalError("Unimplemented")
  }
}
