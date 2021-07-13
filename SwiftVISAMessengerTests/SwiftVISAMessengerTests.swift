//
//  SwiftVISAMessengerTests.swift
//  SwiftVISAMessengerTests
//
//  Created by Connor Barnes on 7/12/21.
//

import XCTest
@testable import SwiftVISAMessenger

class SwiftVISAMessengerTests: XCTestCase {
  func testStringEscaping() {
    let tests: [(String, String)] = [
      ("", ""),
      ("\n", "\\n"),
      ("\0", "\\0"),
      ("\\", "\\\\"),
      ("\u{c06}", "\\u{0C06}"),
      ("hello\n world \u{aaa}!", "hello\\n world \\u{0AAA}!")
    ]
    
    for (value, expected) in tests {
      XCTAssertEqual(value.escape(), expected)
    }
    
    for (expected, value) in tests {
      XCTAssertEqual(value.unescape(), expected)
    }
  }
}
