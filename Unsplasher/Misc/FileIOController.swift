//
//  FileIOController.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 22.11.2021.
//

import Foundation

protocol DataIOManager {
  func read(fromDocumentNamed documentName: String) -> Data?

  func write(_ data: Data, toDocumentNamed documentName: String) throws
}

class FileIOController: DataIOManager {
  private let manager = FileManager.default

  func write(_ data: Data, toDocumentNamed documentName: String) throws {
    let cachesFolder = try manager
      .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent("ImagesCaches")

    do {
      try manager.createDirectory(at: cachesFolder, withIntermediateDirectories: false, attributes: nil)
    } catch CocoaError.fileWriteFileExists {
      // Folder already exists
    } catch {
      throw error
    }

    let fileURL = cachesFolder.appendingPathComponent(documentName)

    try data.write(to: fileURL, options: .atomic)
  }

  func read(fromDocumentNamed documentName: String) -> Data? {
    let url = try? manager
      .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent("ImagesCaches")
      .appendingPathComponent(documentName)

    guard let url = url else { return nil }

    return try? Data(contentsOf: url)
  }
}
