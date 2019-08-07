//
//  EditViewController.swift
//  Test2
//
//  Created by MCS on 7/19/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
//  @IBOutlet weak var toggleFavorite: UIButton!
  @IBOutlet weak var episodeImage: UIImageView!
  
  @IBOutlet weak var favoriteButton: UIButton!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var firstAirLabel: UILabel!
  
  @IBOutlet weak var airtimeLabel: UILabel!
  
  @IBOutlet weak var seasonLabel: UILabel!
  
  @IBOutlet weak var episodeLabel: UILabel!
  
  @IBOutlet weak var episodeSummary: UILabel!
  
  var episode: Episode?
  var favorite: Bool = false
  var favoriteList: [Data] = []
  
    override func viewDidLoad() {
      super.viewDidLoad()
      
      guard let episode = episode else { return }
      guard let url = episode.image?.original else { return }
      
      func assignData() {
        self.titleLabel.text = "Episode Title: \(episode.name)"
        self.firstAirLabel.text = "Air Data: \(episode.airdate)"
        self.airtimeLabel.text = "Airtime: \(episode.airtime)"
        self.seasonLabel.text = "Season: \(episode.season)"
        self.episodeLabel.text = "Episode: \(episode.number)"
        self.episodeSummary.text = "Summary: \(String((episode.summary.dropLast(4).dropFirst(3))))"
      }
      
      URLSession.shared.dataTask(with: url) { data, response, error in
        guard
          let responseCall = response as? HTTPURLResponse, responseCall.statusCode == 200,
          let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
          let data = data, error == nil,
          let image = UIImage(data: data) else {
            assignData()
            return
        }
        
        DispatchQueue.main.async() {
          assignData()
          self.episodeImage.image = image
        }
      }.resume()

      
    }
  
  @IBAction func favoriteEpisode(_ sender: Any) {
    let encoder = JSONEncoder()
    guard let data = try? encoder.encode(self.episode) else { return }
    favorite = !favorite
    
    favoriteList.append(data)
    
    if favorite {
      favoriteButton.setTitle("Remove from Favorites", for: .normal)
      UserDefaults.standard.set(favoriteList, forKey: "favoriteList")
    } else {
      favoriteButton.setTitle("Add to Favorites", for: .normal)
      UserDefaults.standard.removeObject(forKey: "favoritesList")
    }
  }

  
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
