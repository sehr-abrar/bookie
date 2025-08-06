//
//  BookExploreViewController.swift
//  Bookie1
//
//  Created by Sehr Abrar on 8/5/25.
//

import UIKit

class BookExploreViewController: UITableViewController {
    
    let catalog: [Book] = [
        Book(title: "1984", author: "George Orwell", synopsis: "Dystopian novel about totalitarian regime.", imageName: "book.closed"),
        Book(title: "Pride and Prejudice", author: "Jane Austen", synopsis: "Classic romance novel set in 19th century England.", imageName: "book.closed"),
        Book(title: "The Hobbit", author: "J.R.R. Tolkien", synopsis: "Fantasy adventure of Bilbo Baggins in Middle-earth.", imageName: "book.closed"),
        Book(title: "To Kill a Mockingbird", author: "Harper Lee", synopsis: "Novel about racial injustice in the American South.", imageName: "book.closed"),
        // Add more as needed
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BookExplore"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        catalog.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreBookCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ExploreBookCell")
        let book = catalog[indexPath.row]
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author + (book.synopsis != nil ? " — \(book.synopsis!)" : "")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // On tap, show detail with add button
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = catalog[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "BookExploreDetailViewController") as? BookExploreDetailViewController {
            detailVC.book = book
            navigationController?.pushViewController(detailVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
