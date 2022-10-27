//
//  ViewController.swift
//  QueryBooks
//
//  Created by Jackeline Pires De Lima on 26/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    var books: [ProductBook] = []
    var booksFilter: [ProductBook] = []
    let networking = Network()
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.delegate = self
        return search
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNetworking()
    }
    
    private func setupNetworking() {
        networking.getBooks { result in
            switch result {
            case .success(let response):
                self.books = response.books
                self.reload()
            case .failure(let failure):
                print("error \(failure)")
            }
        }
    }
    
    ///Filtrando da api buscanco por titulo
    private func setupFilterNetwork(query: String) {
        networking.filterBooksForTitle(with: query) { response in
            switch response {
            case .success(let result):
                self.booksFilter.removeAll()
                self.booksFilter = result.books
                self.reload()
            case .failure(let failure):
                print("error \(failure)")
            }
        }
    }
    
    private func setupView() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func isSearchBarEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    ///Filtro para o que ja foi salvo no carregamento por código do status do livro
    private func filterBooks(_ query: String) {
        
        booksFilter = books.filter({ book in
            return book.titulo.lowercased().contains(query.lowercased())
        })
        reload()
    }
    
    private func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


//MARK: UITableViewDelegate, UITableViewDataSource
extension ViewController:  UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isSearchBarEmpty() {
            return booksFilter.count
        }
        return books.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if !isSearchBarEmpty() {
            cell.textLabel?.text = booksFilter[indexPath.row].titulo
        } else {
            cell.textLabel?.text = books[indexPath.row].titulo
        }
        
        return cell
    }
}

//MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        setupFilterNetwork(query: searchText)
    }
}



