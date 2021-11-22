//
//  Digest+hexStr.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 22.11.2021.
//

import Foundation
import CryptoKit

extension Digest {
  var bytes: [UInt8] { Array(makeIterator()) }

  var hexStr: String {
    bytes.map { String(format: "%02X", $0) }.joined()
  }
}
