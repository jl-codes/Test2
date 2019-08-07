//
//  Image.swift
//  Test2
//
//  Created by MCS on 7/22/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation

struct Image: Codable {
  var medium: URL?
  var original: URL?
  
  enum ImageCodingKeys: String, CodingKey {
    case medium
    case original
  }
}
