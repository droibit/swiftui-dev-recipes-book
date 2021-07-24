//
//  TodoDetailView.swift
//  TodoReminder
//
//  Created by Shinya Kumagai on 2021/07/24.
//

import SwiftUI

struct TodoDetailView: View {
    let todo: TodoListItem

    var body: some View {
        Form {
            Section(header: Text("タイトル")) {
                Text(todo.title)
            }

            Section(header: Text("優先度")) {
                Picker("優先度", selection: .constant(todo.priority)) {
                    Text("低")
                        .tag(TodoPriority.low)
                    Text("中")
                        .tag(TodoPriority.medium)
                    Text("高")
                        .tag(TodoPriority.high)
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(true)
            }

            Section(header: Text("メモ")) {
//                TextEditor(text: .constant(todo.note))
                Text(todo.note)
                    .foregroundColor(.black)
                    .frame(height: 200, alignment: .topLeading)
            }
        }
        .navigationTitle("詳細")
    }
}

struct TodoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailView(
            todo: TodoListItem(
                startDate: Date(),
                note: "アジェンダを事前に作成しておく",
                priority: .low,
                title: "開発MTG"
            )
        )
    }
}
