//
//  BooksModel.swift
//  QueryBooks
//
//  Created by Jackeline Pires De Lima on 26/10/22.
//

import Foundation

// MARK: - Product
struct Product: Codable {
    let books: [ProductBook]
}

// MARK: - ProductBook
struct ProductBook: Codable {
    let isbn: String
    let formato: ProductFormato
    let titulo: String
    let subtitulo, tituloOriginal: String
    let volume, edicao: String

    enum CodingKeys: String, CodingKey {
        case isbn, formato, titulo, subtitulo
        case tituloOriginal = "titulo_original"
        case volume, edicao
    }
}

enum ProductFormato: String, Codable {
    case book = "BOOK"
}
