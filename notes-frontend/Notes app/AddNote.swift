//
//  AddNote.swift
//  Notes app
//
//  Created by Suraj Kumar on 30/05/25.
//

import SwiftUI

struct AddNote: View {
  @Environment(\.dismiss) var dismiss
  var existingNote: Note?
  
  var viewModel = ViewModel()
  @State private var id: String = ""
  @State private var title: String = ""
  @State private var noteText: String = ""
  @State private var date: String = ""
  
  var body: some View {
    Form {
      Section(header: Text("Note Details")) {
        TextField("Title", text: $title)
        TextField("Note", text: $noteText, axis: .vertical)
          .lineLimit(5...)
          .autocorrectionDisabled()
      }
      
    }
    .navigationTitle(existingNote != nil ? "Edit Note" : "Add Note")
    .onAppear {
      if let existingNote = existingNote {
        id = existingNote.id
        title = existingNote.title
        noteText = existingNote.note
        date = existingNote.date
      } else {
        // Set default date for new notes
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        date = formatter.string(from: Date())
      }
    }
    .toolbar {
      if existingNote != nil {
        ToolbarItem(placement: .topBarTrailing) {
          Button{
            Task {
              print("id", id)
                await viewModel.deletData(id: id)
                dismiss()
            }
          } label: {
            Text("Delete").foregroundColor(.red)
          }
        }
      }
      ToolbarItem(placement: .topBarTrailing) {
        Button{
          Task {
            if(existingNote != nil) {
              print(id, title, noteText)
              await viewModel.updateData(id: id, title: title, note: noteText)
            }else {
              await viewModel.createData(title: title, note: noteText)
            }
          }
        } label: {
          Text(existingNote != nil ? "Update" :"Save").foregroundColor(.blue)
        }
      }
    }
  }
}

#Preview {
    NavigationStack {
        AddNote(existingNote: nil)
    }
}
