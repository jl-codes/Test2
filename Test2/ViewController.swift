//
//  ViewController.swift
//  Test2
//
//  Created by MCS on 7/19/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var episodeTableView: UITableView!
  
  var gameOfThrones: GameOfThrones? = nil
  var searchController: UISearchController!
  var episodes: [Episode]? = nil
  var filteredEpisodes: [Episode]? = nil
  var sectionedEpisodes: [Int: [Episode]] = [:]
  var filteredSectionedEpisodes: [Int: [Episode]] = [:]
 // let manager = CoreDataManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    episodeTableView.dataSource = self
    episodeTableView.delegate = self
    episodeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.sizeToFit()
    episodeTableView.tableHeaderView = searchController.searchBar
    
    definesPresentationContext = true
  
    
    let gameOfThronesURLString = "https://api.tvmaze.com/shows/82?embed=seasons&embed=episodes"
    if let url = URL(string: gameOfThronesURLString) {
      URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
          print("FAILURE: api call unsuccessful")
          return
        }
        
        if let gameOfThrones = try? JSONDecoder().decode(GameOfThrones.self, from: data) {
          DispatchQueue.main.async {
            self.gameOfThrones = gameOfThrones
            if let episodes = (self.gameOfThrones?.embedded.episodes) {
              self.episodes = episodes
              
              for i in 1...8 {
                self.sectionedEpisodes[i] = episodes.filter{ $0.season == i }
                self.filteredSectionedEpisodes[i] = self.sectionedEpisodes[i]
              }
            }
            self.episodeTableView.reloadData()
          }
        } else {
          print("FAILURE: api call unsuccessful")
        }
      }.resume()
    }
  }
}

extension ViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if let search = searchController.searchBar.text {
      if search.isEmpty {
        filteredSectionedEpisodes = sectionedEpisodes
      } else {
        for key in sectionedEpisodes.keys {
          filteredSectionedEpisodes[key] = sectionedEpisodes[key]?.filter({(episode: Episode?) -> Bool in return episode?.name.range(of: search, options: .caseInsensitive) != nil
          })
        }
      }
      episodeTableView.reloadData()
    }
  }
}

extension ViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return filteredSectionedEpisodes.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var dictionaryKeys = Array(filteredSectionedEpisodes.keys)
    dictionaryKeys.sort(by: <)
    
    guard let count = filteredSectionedEpisodes[dictionaryKeys[section]]?.count else { return 0 }
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    var dictionaryKeys = Array(filteredSectionedEpisodes.keys)
    dictionaryKeys.sort(by: <)
    
    guard let episodeList = filteredSectionedEpisodes[dictionaryKeys[indexPath.section]] else { return cell }
    
    guard let url = episodeList[indexPath.row].image?.medium else { return cell }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let callResponse = response as?HTTPURLResponse, callResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data) else { return }
      
      DispatchQueue.main.async() {
        cell.imageView?.image = image
        cell.textLabel?.text = episodeList[indexPath.row].name
        cell.detailTextLabel?.text = "Episode \(episodeList[indexPath.row].number)"
      }
    }.resume()
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var dictionaryKeys = Array(filteredSectionedEpisodes.keys)
    dictionaryKeys.sort(by: <)
    if dictionaryKeys.count != 0 {
      return "Season \(dictionaryKeys[section])"
    } else { return "" }
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let editViewController = storyboard.instantiateViewController(withIdentifier: "EditViewController") as? EditViewController {
      editViewController.episode = self.gameOfThrones!.embedded.episodes[indexPath.row]
      navigationController?.pushViewController(editViewController, animated: true)
    }
  }
}
