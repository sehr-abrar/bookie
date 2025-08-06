//
//  AddEditBookViewController.swift
//  Bookie1
//
//  Created by Sehr Abrar on 8/5/25.
//

import UIKit

protocol AddEditBookDelegate: AnyObject {
    func didSaveBook()
}

class AddEditBookViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var statusPickerView: UIPickerView!
    
    var bookToEdit: Book?
    weak var delegate: AddEditBookDelegate?
    
    private var statusOptions = ReadingStatus.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = bookToEdit == nil ? "Add Book" : "Edit Book"
        
        statusPickerView.delegate = self
        statusPickerView.dataSource = self
        
        if let book = bookToEdit {
            titleTextField.text = book.title
            authorTextField.text = book.author
            noteTextField.text = book.note
            if let index = statusOptions.firstIndex(of: book.status) {
                statusPickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc func saveTapped() {
        guard let title = titleTextField.text, !title.isEmpty,
              let author = authorTextField.text, !author.isEmpty else {
            // show alert for missing required fields
            let alert = UIAlertController(title: "Missing Info", message: "Please enter both title and author.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let note = noteTextField.text ?? ""
        let status = statusOptions[statusPickerView.selectedRow(inComponent: 0)]
        
        if var book = bookToEdit {
            // update
            book.title = title
            book.author = author
            book.note = note
            book.status = status
            BookManager.shared.updateBook(book)
        } else {
            // add new
            let newBook = Book(title: title, author: author, note: note, status: status)
            BookManager.shared.addBook(newBook)
        }
        
        delegate?.didSaveBook()
        dismiss(animated: true)
    }
    
    // MARK: UIPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        statusOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        statusOptions[row].rawValue
    }
}
