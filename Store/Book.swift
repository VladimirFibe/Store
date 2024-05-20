//
//  Book.swift
//  Store
//
//  Created by MacService on 20.05.2024.
//

import Foundation

struct Book: Codable, Identifiable, Hashable {
  var id: UUID
  var name: String
  var edition: String
  var imageName: String
  var available: Bool
}

extension Book {
    static let books = [
        Book(
          id: UUID(),
          name: "iOS App Distribution & Best Practices",
          edition: "1st Edition",
          imageName: "pasi",
          available: true
        ),
        Book(
          id: UUID(),
          name: "SwiftUI Apprentice",
          edition: "1st Edition",
          imageName: "swiftui",
          available: false
        ),
        Book(
          id: UUID(),
          name: "Living by the Code",
          edition: "2nd Edition",
          imageName: "livingcode",
          available: true
        ),
        Book(
          id: UUID(),
          name: "Git Apprentice",
          edition: "1st Edition",
          imageName: "git",
          available: true
        ),
        Book(
          id: UUID(),
          name: "Expert Swift",
          edition: "1st Edition",
          imageName: "expertswift",
          available: false
        )
      ]
}
