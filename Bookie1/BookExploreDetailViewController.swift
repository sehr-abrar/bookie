//
//  BookExploreDetailViewController.swift
//  Bookie1
//
//  Created by Sehr Abrar on 8/5/25.
//

import UIKit

class BookExploreDetailViewController: UIViewController {
    
    var book: Book!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Book Details"
        
        titleLabel.text = book.title
        authorLabel.text = "by \(book.author)"
        synopsisLabel.text = book.synopsis ?? ""
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        // Add book to My Books with default status and empty note
        let newBook = Book(title: book.title, author: book.author, note: "", status: .notStarted)
        BookManager.shared.addBook(newBook)
        
        let alert = UIAlertController(title: "Added!", message: "\"\(book.title)\" has been added to your books.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
