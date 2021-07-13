//
//  StringEscaping.swift
//  SwiftVISAMessenger
//
//  Created by Connor Barnes on 7/13/21.
//

import Foundation

extension String {
  func escape() -> String {
    flatMap { element in
      element.unicodeScalars.map { $0.escaped(asASCII: true) }
    }.joined()
  }
  
  func unescape() -> String? {
    enum DecodeState: Equatable {
      case normal
      case escaped
      case unicodeEscaped
      case unicodeEscapedInside (String)
    }
    
    var builder: String = ""
    var state = DecodeState.normal
    
    for character in self {
      switch state {
      case .normal:
        if character == "\\" {
          state = .escaped
        } else {
          builder += String(character)
        }
      case .escaped:
        state = .normal
        switch character {
        case "0":
          builder += "\0"
        case "\\":
          builder += "\\"
        case "t":
          builder += "\t"
        case "n":
          builder += "\n"
        case "r":
          builder += "\r"
        case "u":
          state = .unicodeEscaped
        default:
          // Invalid escape character
          return nil
        }
      case .unicodeEscaped:
        if character == "{" {
          state = .unicodeEscapedInside("")
        } else {
          // Invalid escape character \u
          return nil
        }
      case .unicodeEscapedInside(let codePoint):
        if character == "}" {
          if let value = Int(codePoint, radix: 16),
             let scalar = Character.UnicodeScalarView.Element.init(value){
            builder += String(scalar)
            state = .normal
          } else {
            // Invalid number
            return nil
          }
        } else {
          state = .unicodeEscapedInside(codePoint + String(character))
        }
      }
    }
    
    guard state == .normal else { return nil }
    return builder
  }
}
