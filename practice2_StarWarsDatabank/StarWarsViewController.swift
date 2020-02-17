//
//  StarWarsViewController.swift
//  practice2_StarWarsDatabank
//
//  Created by Anna Krasilnikova on 14.02.2020.
//  Copyright © 2020 Anna Krasilnikova. All rights reserved.
//

import UIKit

class StarWarsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
   
    
    final let urlString = "https://swapi.co/api/people"
    var characterNamesArray = [String]()
    var currentCharacterNamesArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getInfoFromUrl()
        setUpSearchBar()
    }
    
    //MARK: get info from api
    func getInfoFromUrl (){
        guard let url = URL(string: urlString) else { return }
        var downoadTask = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        downoadTask.httpMethod = "GET"
        URLSession.shared.dataTask(with: downoadTask , completionHandler: {(data, response, error ) -> Void in
            guard let data = data else { return }
            let character = try! JSONDecoder().decode(Characters.self, from: data)
            for i in 0..<character.results.count{
                self.characterNamesArray.append(character.results[i].name)
            }
            if let error = error {
                self.getAlert(error: error)
                return
            }
        }).resume()
        currentCharacterNamesArray = characterNamesArray
        tableView.reloadData()
    }
    
    func getAlert(error: Error){
        let alert = UIAlertController(title: "Error!",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok",
                                         style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}

//MARK: for save info about characters
struct Characters: Codable {
    let results: [Character]
}

struct Character: Codable {
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
    let homeworld: String
    let films: [String]
    let species: [String]
    let vehicles: [String]
    let starships: [String]
    let created: String
    let edited: String
    let url: String
}

extension StarWarsViewController: UISearchBarDelegate {
    private func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentCharacterNamesArray = characterNamesArray
            tableView.reloadData()
            return
        }
        currentCharacterNamesArray = characterNamesArray.filter({ character -> Bool in
            character.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

extension StarWarsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCharacterNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell")
        guard let characterCell = cell as? CharacterTableViewCell else { return UITableViewCell() }
        characterCell.characterLabel.text = currentCharacterNamesArray[indexPath.row]
        return characterCell
    }
}

extension StarWarsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


