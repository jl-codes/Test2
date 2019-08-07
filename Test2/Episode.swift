//
//  Episode.swift
//  Test2
//
//  Created by MCS on 7/22/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation

struct Episode: Codable {
  var image: Image?
  let name: String
  let airdate: String
  let airtime: String
  let season: Int
  let number: Int
  let summary: String
}
