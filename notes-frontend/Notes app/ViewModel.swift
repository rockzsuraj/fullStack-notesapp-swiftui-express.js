//
//  ViewModel.swift
//  Notes app
//
//  Created by Suraj Kumar on 30/05/25.
//

import Foundation

@Observable
@MainActor
class ViewModel {
  enum FetchStatus {
    case notStarted
    case fetching
    case success
    case failed(error: Error)
  }
  
  private(set) var status: FetchStatus = .notStarted
  
  private let fetcher = FetchService()
  
  var notes: [Note] = []
  
  private func getCurrentDate() -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.timeZone = TimeZone.current
      return formatter.string(from: Date())
  }
  
  func fetchData() async {
    status = .fetching
    
    do {
      notes = try await fetcher.fetchNotes()
      status = .success
      print("notes fetched")
    } catch {
      status = .failed(error: error)
      print(error)
      notes = []
      print(notes)
    }
  }
  
  func deletData(id: String) async {
    status = .fetching
    print(id)
    do {
      try await fetcher.deleteNote(id: id)
      status = .success
      print("notes deleted")
    } catch {
      status = .failed(error: error)
      print(error)
    }
  }
  
  func createData(title: String, note: String) async {
    status = .fetching
    do {
      let currentDate = getCurrentDate()
      try await fetcher.createNote(title: title, note: note, date: currentDate)
      status = .success
      print("new note created")
    } catch {
      status = .failed(error: error)
      print(error)
    }
  }
  
  func updateData(id: String, title: String, note: String) async {
    status = .fetching
    do {
      let currentDate = getCurrentDate()
      try await fetcher.updateNote(id: id, title: title, note: note, date: currentDate)
      status = .success
      print("note updated")
    } catch {
      status = .failed(error: error)
      print(error)
    }
  }

  
}
