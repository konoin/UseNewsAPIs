//
//  ViewController.swift
//  UseWebAPIs
//
//  Created by Никита Полыко on 25.03.21.
//

import UIKit

class NewsViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var chooseCategory: UIBarButtonItem!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "list.bullet"), primaryAction: nil, menu: menuItem())
    }
    
    func menuItem() -> UIMenu {
        
        let addMenuLine = UIMenu(title: "Chose category", options: .destructive, children: [
        
            UIAction(title: "Business", image: UIImage(systemName: "briefcase"), handler: { (_) in
                print("It's work")
            }),
            UIAction(title: "Entertainment", image: UIImage(systemName: "tv"), handler: { (_) in
                print("Seond work")
            }),
            UIAction(title: "General", image: UIImage(systemName: "book"), handler: { (_) in
                            print("Seond work")
            }),
            UIAction(title: "Health", image: UIImage(systemName: "stethoscope"), handler: { (_) in
                            print("Seond work")
            }),
            UIAction(title: "Sport", image: UIImage(systemName: "sportscourt"), handler: { (_) in
                            print("Seond work")
            }),
            UIAction(title: "Technology", image: UIImage(systemName: "desktopcomputer"), handler: { (_) in
                print("Somethink work")
            }),
            UIAction(title: "Science", image: UIImage(systemName: "function"), handler: { (_) in
                print("Very interesting")
            })
        
        ])
      return addMenuLine
    }
    
    
    @IBAction func chooseCategoryTapped(_ sender: UIBarButtonItem) {
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
