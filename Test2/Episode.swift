//
//  Episode.swift
//  Test2
//
//  Created by MCS on 7/22/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation

struct Episode: Codable {
  let image: Image
  let name: String
  let airdate: String
  let airtime: String
  let season: Int
  let number: Int
  let summary: String
  
  enum EpisodeCodingKeys: String, CodingKey {
    case image
    case name
    case airdate
    case airtime
    case season
    case number
    case summary
    
  }
  
  init(from decoder: Decoder) throws {
    let episodeContainer = try decoder.container(keyedBy: EpisodeCodingKeys.self)
    self.image = try episodeContainer.decode(Image.self, forKey: .image)
    self.name = try episodeContainer.decode(String.self, forKey: .name)
    self.airdate = try episodeContainer.decode(String.self, forKey: .airdate)
    self.airtime = try episodeContainer.decode(String.self, forKey: .airtime)
    self.season = try episodeContainer.decode(Int.self, forKey: .season)
    self.number = try episodeContainer.decode(Int.self, forKey: .number)
    self.summary = try episodeContainer.decode(String.self, forKey: .summary)
  }
  
  func encode(to encoder: Encoder) throws {
    var episodeContainer = encoder.container(keyedBy: EpisodeCodingKeys.self)
    try episodeContainer.encode(self.image, forKey: .image)
    try episodeContainer.encode(self.name, forKey: .name)
    try episodeContainer.encode(self.airdate, forKey: .airdate)
    try episodeContainer.encode(self.airtime, forKey: .airtime)
    try episodeContainer.encode(self.season, forKey: .season)
    try episodeContainer.encode(self.number, forKey: .number)
    try episodeContainer.encode(self.summary, forKey: .summary)
  }
}
