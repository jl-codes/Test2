//
//  Embedded.swift
//  Test2
//
//  Created by MCS on 7/22/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation

struct Embedded: Codable {
  let episodes: [Episode]
  
  enum EmbeddedCodingKeys: String, CodingKey {
    case episodes
  }
}
