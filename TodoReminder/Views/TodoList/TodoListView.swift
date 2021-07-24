import SwiftUI

struct TodoListView: View {
    @State private var isShow = false
    @StateObject private var viewModel = TodoListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.todoList) { todoItem in
                NavigationLink(
                    destination: TodoDetailView(todo: todoItem),
                    tag: todoItem.id,
                    selection: $viewModel.activeTodoId
                ) {
                    HStack {
                        switch todoItem.priority {
                        case .low:
                            Circle()
                                .fill(Color.green)
                                .frame(width: 40)
                        case .medium:
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 40)
                        case .high:

                            Circle()
                                .fill(Color.red)
                                .frame(width: 40)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("\(todoItem.title)")
                            .font(.title)
                        Text(todoItem.startDate, style: .date)
                            .font(.subheadline)
                        Text(todoItem.startDate, style: .time)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("TodoList")
            .navigationBarItems(trailing: Button {
                isShow.toggle()
            } label: {
                Text("追加")
            })
        }
        .navigationViewStyle(DefaultNavigationViewStyle())
        .onAppear {
            viewModel.apply(inputs: .onAppear)
        }
        .sheet(isPresented: $isShow) {
            AddTodoView(isShow: $isShow)
        }
        .onOpenURL { url in
            viewModel.apply(inputs: .openFromWidget(url: url))
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
