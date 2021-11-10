//
//  Unsplash.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 03.11.2021.
//

import Foundation
import Moya

enum Unsplash {
  static private let accessKey = "bTrKmuQBRW6IiZw3p1WL3FhtVVCqiNE-6Q6xgBBEpv0"

  case getTopicsPhotos(topic: Topic)
}

extension Unsplash: TargetType {
  var baseURL: URL {
    // swiftlint:disable:next force_unwrapping
    return URL(string: "https://api.unsplash.com")!
  }

  var path: String {
    switch self {
    case .getTopicsPhotos(let topic):
      return "/topics/\(topic.rawValue)/photos"
    }
  }

  var method: Moya.Method {
    switch self {
    case .getTopicsPhotos: return .get
    }
  }

  var task: Task {
    switch self {
    case .getTopicsPhotos:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    return [
      "Content-Type": "application/json",
      "Accept-Version": "v1",
      "Authorization": "Client-ID \(Unsplash.accessKey)"
    ]
  }

  var validationType: ValidationType {
    return .successCodes
  }

  var sampleData: Data {
    switch self {
    case .getTopicsPhotos(let topic):
      let fileName = "Unsplash+\(topic.rawValue)"

      guard
        let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
        let data = try? Data(contentsOf: url) else {
          return Data()
        }

      return data
    }
  }
}
