//
//  Book.swift
//  Bookie1
//
//  Created by Sehr Abrar on 8/5/25.
//

import Foundation

enum ReadingStatus: String, Codable, CaseIterable {
    case notStarted = "Not Started"
    case reading = "Reading"
    case completed = "Completed"
    
    var emoji: String {
        switch self {
        case .notStarted: return "📕"
        case .reading: return "📘"
        case .completed: return "📗"
        }
    }
}

struct Book: Codable, Equatable {
    let id: UUID
    var title: String
    var author: String
    var note: String
    var status: ReadingStatus
    var isFavorite: Bool
    var synopsis: String?
    var imageName: String?
    
    init(id: UUID = UUID(),
         title: String,
         author: String,
         note: String = "",
         status: ReadingStatus = .notStarted,
         isFavorite: Bool = false,
         synopsis: String? = nil,
         imageName: String? = nil) {
        self.id = id
        self.title = title
        self.author = author
        self.note = note
        self.status = status
        self.isFavorite = isFavorite
        self.synopsis = synopsis
        self.imageName = imageName
    }
}
