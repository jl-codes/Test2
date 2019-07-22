//
//  Image.swift
//  Test2
//
//  Created by MCS on 7/22/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation

struct Image: Codable {
  let medium: URL
  let original: URL
  
  enum ImageCodingKeys: String, CodingKey {
    case medium
    case original
  }
  
  init(from decoder: Decoder) throws {
    let imageContainer = try decoder.container(keyedBy: ImageCodingKeys.self)
    self.medium = try imageContainer.decode(URL.self, forKey: .medium)
    self.original = try imageContainer.decode(URL.self, forKey: .original)
  }
  
  func encode(to encoder: Encoder) throws {
    var imageContainer = encoder.container(keyedBy: ImageCodingKeys.self)
    try imageContainer.encode(self.medium, forKey: .medium)
    try imageContainer.encode(self.original, forKey: .original)
  }
}
