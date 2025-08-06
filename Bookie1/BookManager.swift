//
//  BookManager.swift
//  Bookie1
//
//  Created by Sehr Abrar on 8/5/25.
//

import Foundation

class BookManager {
    static let shared = BookManager()
    
    private(set) var books: [Book] = []
    
    private let userDefaultsKey = "books"
    
    private init() {
        loadBooks()
    }
    
    func addBook(_ book: Book) {
        guard !books.contains(where: { $0.title == book.title && $0.author == book.author }) else { return }
        books.append(book)
        saveBooks()
    }
    
    func updateBook(_ updatedBook: Book) {
        if let index = books.firstIndex(where: { $0.id == updatedBook.id }) {
            books[index] = updatedBook
            saveBooks()
        }
    }
    
    func deleteBooks(at indexes: IndexSet) {
        for index in indexes {
            books.remove(at: index)
        }
        saveBooks()
    }
    
    func toggleFavorite(for book: Book) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index].isFavorite.toggle()
            saveBooks()
        }
    }
    
    private func saveBooks() {
        if let data = try? JSONEncoder().encode(books) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func loadBooks() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedBooks = try? JSONDecoder().decode([Book].self, from: data) {
            books = savedBooks
        }
    }
}
