//
//  Notes_appApp.swift
//  Notes app
//
//  Created by Suraj Kumar on 30/05/25.
//

import SwiftUI

struct Note: Decodable, Identifiable {
  let id: String
  let note: String
  let date: String
  let title: String
  
  enum CodingKeys: String, CodingKey {
      case id = "_id"
      case note
      case date
      case title
  }
}

class FetchService {
  private enum FetchError: Error {
    case networkError(Error)
    case decodingError(Error)
    case badResponse
  }
  private let baseUrl = URL(string: "http://192.168.1.2:8081")!
  
  func fetchNotes() async throws -> [Note] {
    let fetchUrl = baseUrl.appending(path: "fetch")
    let (data, response) = try await URLSession.shared.data(from: fetchUrl)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200..<300).contains(httpResponse.statusCode) else {
      throw FetchError.badResponse
    }
    do {
       let notes = try JSONDecoder().decode([Note].self, from: data)
       return notes
     } catch {
       print("Decoding error details:", error)
       throw FetchError.decodingError(error)
     }
  }
  
  func deleteNote (id: String) async throws {
      let deleteUrl = baseUrl.appending(queryItems: [URLQueryItem(name: "id", value: id)])
      .appendingPathComponent("delete")
      print(deleteUrl)
    var request = URLRequest(url: deleteUrl)
    request.httpMethod = "POST"
    
    do {
      let _ = try await URLSession.shared.data(for: request)
    } catch {
      print("Error: unable to delete notes", error)
    }
  }
  
  func createNote (title: String, note: String, date: String) async throws {
    let createUrl = baseUrl
      .appendingPathComponent("create")
    print(createUrl)
    let payload = [
      "title": title,
      "note": note,
      "date": date
    ]
    var request = URLRequest(url: createUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
      request.httpBody = try JSONEncoder().encode(payload)
      let (_, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode) else {
          throw FetchError.badResponse
      }
    } catch {
      print("Error: unable to create notes", error)
    }
  }
  
  func updateNote (id: String, title: String, note: String, date: String) async throws {
    let updateUrl = baseUrl
      .appendingPathComponent("update")
      print(updateUrl)
    let payload = [
      "id": id,
      "title": title,
      "note": note,
      "date": date
    ]
    
    print("payload", payload)
    var request = URLRequest(url: updateUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
      request.httpBody = try JSONEncoder().encode(payload)
      let (_, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode) else {
          throw FetchError.badResponse
      }
    } catch {
      print("Error: unable to create notes", error)
    }
  }

  
}
