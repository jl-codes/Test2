//
//  GameOfThrones.swift
//  Test2
//
//  Created by MCS on 7/22/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation

struct GameOfThrones: Codable {
  let embedded: Embedded
  
  enum CodingKeys: String, CodingKey {
    case embedded = "_embedded"
  }
}
