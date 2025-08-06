//
//  MyBooksViewController.swift
//  Bookie1
//
//  Created by Sehr Abrar on 8/5/25.
//

import UIKit

class MyBooksViewController: UITableViewController {
    
    private var filteredBooks: [Book] = []
    private var selectedFilter: ReadingStatus? = nil
    private var showFavoritesOnly = false
    private var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Books"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBookTapped))
        updateFilteredBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFilteredBooks()
    }
    
    private func updateFilteredBooks() {
        filteredBooks = BookManager.shared.books.filter { book in
            (selectedFilter == nil || book.status == selectedFilter) &&
            (!showFavoritesOnly || book.isFavorite) &&
            (searchText.isEmpty || book.title.localizedCaseInsensitiveContains(searchText) || book.author.localizedCaseInsensitiveContains(searchText))
        }
        tableView.reloadData()
    }
    
    @objc private func addBookTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addVC = storyboard.instantiateViewController(withIdentifier: "AddEditBookViewController") as? AddEditBookViewController {
            addVC.delegate = self
            navigationController?.present(UINavigationController(rootViewController: addVC), animated: true)
        }
    }
    
    // MARK: TableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Use a basic cell or create a custom one
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "BookCell")
        let book = filteredBooks[indexPath.row]
        cell.textLabel?.text = "\(book.status.emoji) \(book.title)"
        cell.detailTextLabel?.text = "\(book.author) \(book.note.isEmpty ? "" : "📝 \(book.note)")"
        cell.accessoryType = book.isFavorite ? .checkmark : .none
        return cell
    }
    
    // MARK: TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = filteredBooks[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editVC = storyboard.instantiateViewController(withIdentifier: "AddEditBookViewController") as? AddEditBookViewController {
            editVC.bookToEdit = book
            editVC.delegate = self
            navigationController?.present(UINavigationController(rootViewController: editVC), animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let index = BookManager.shared.books.firstIndex(of: filteredBooks[indexPath.row]) {
                BookManager.shared.books.remove(at: index)
                BookManager.shared.saveBooks()
                updateFilteredBooks()
            }
        }
    }
}
