//
//  ViewController.swift
//  UseWebAPIs
//
//  Created by Никита Полыко on 25.03.21.
//

import UIKit

class NewsViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var listOfNews = [Articles]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.listOfNews.count) news find"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    //MARK: - TableView data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let news = listOfNews[indexPath.row]
        cell.textLabel?.text = news.author
        cell.detailTextLabel?.text = news.source.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let descriptionViewController = self.storyboard?.instantiateViewController(withIdentifier: "DescriptionViewController") as? DescriptionViewController else {
            return
        }
        descriptionViewController.articleInfo = listOfNews[indexPath.row]
        navigationController?.pushViewController(descriptionViewController, animated: true)
    }
}

extension NewsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        let newsRequest = NewsRequest(countryCode: searchBarText)
        newsRequest.getNews { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let news):
                self?.listOfNews = news.articles
                
            }
            
        }
    }
}
