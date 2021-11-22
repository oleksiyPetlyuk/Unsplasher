//
//  String+sha256.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 22.11.2021.
//

import Foundation
import CryptoKit

extension String {
  var sha256: String? {
    guard let data = self.data(using: .utf8) else { return nil }

    let digest = SHA256.hash(data: data)

    return digest.hexStr
  }
}
