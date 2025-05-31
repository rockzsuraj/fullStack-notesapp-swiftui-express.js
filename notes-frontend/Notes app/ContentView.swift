//
//  ContentView.swift
//  Notes app
//
//  Created by Suraj Kumar on 30/05/25.
//

import SwiftUI

struct ContentView: View {
  
  @State private var viewModel = ViewModel()
  
    var body: some View {
      NavigationStack {
          List(viewModel.notes, id: \.id) { note in
          NavigationLink{
            AddNote(existingNote: note)
          } label : {
            VStack(alignment: .leading) {
              Text(note.title)
                .font(.headline)
                .fontWeight(.bold)
              Text(note.note)
              Text(note.date)
            }
          }
      }
        .navigationTitle("Notes")
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            NavigationLink{
              VStack {
                AddNote(existingNote: nil)
              }
            } label: {
              Text("Add Note").foregroundColor(.green)
            }
          }
          ToolbarItem(placement: .topBarLeading) {
                             Button(action: {
                                 Task {
                                     await viewModel.fetchData()
                                 }
                             }) {
                                 Image(systemName: "arrow.clockwise")
                             }
                         }
        }
        .refreshable {
            await viewModel.fetchData()
        }
        .onAppear {
            Task {
                await viewModel.fetchData()
            }
        }
      }
      .task {
        print(viewModel.notes)
        await viewModel.fetchData()
      }
      .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
