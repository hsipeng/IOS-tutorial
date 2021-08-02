//
//  TodoItem.swift
//  todo
//
//  Created by 彭熙 on 2021/7/31.
//

import SwiftUI

class Todo: NSObject, NSCoding, Identifiable {
    var title: String = ""
    var dueDate: Date = Date()
    var checked: Bool = false
    var i: Int = 0
    
    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.dueDate, forKey: "dueDate")
        coder.encode(self.checked, forKey: "checked")
    }
    
    required init?(coder: NSCoder) {
        self.title = coder.decodeObject(forKey: "title") as? String ?? ""
        self.dueDate = coder.decodeObject(forKey: "dueDate") as? Date ?? Date()
        self.checked = coder.decodeBool(forKey: "checked")
        
    }
    
    init(title: String, dueDate: Date, checked: Bool = false) {
        self.title = title
        self.dueDate = dueDate
        self.checked = checked
    }
}

var emptyTodo: Todo = Todo(title: "", dueDate: Date())

struct TodoItem: View {
    @ObservedObject var main: Main
    @Binding var todoIndex: Int
    @State var checked: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
                editingMode = true
                editingTodo = self.main.todos[self.todoIndex]
                editingIndex = self.todoIndex
                self.main.detailsTitle = editingTodo.title
                self.main.detailsDueDate = editingTodo.dueDate
                self.main.detailsShowing = true
                detailsShouldUpdateTitle = true
            }, label: {
                HStack {
                    VStack {
                        Rectangle()
                            .fill(Color("theme"))
                            .frame(width: 8)
                    }
                    Spacer().frame(width: 10)
                    VStack {
                        Spacer().frame(width: 10)
                        HStack {
                            Text(main.todos[todoIndex].title).font(.headline)
                            Spacer()
                        }.foregroundColor(Color("todoItemTitle"))
                        Spacer().frame(width: 4)
                        HStack{
                            Image(systemName: "clock")
                                .resizable()
                                .frame(width: 12, height: 12)
                            Text(formatter.string(from: main.todos[todoIndex].dueDate))
                                .font(.subheadline)
                            Spacer()
                        }
                        .foregroundColor(Color("todoItemSubTitle"))
                        Spacer()
                            .frame(height: 12)
                    }
                }
                Button(action: {
                    self.main.todos[self.todoIndex].checked.toggle()
                    self.checked = self.main.todos[self.todoIndex].checked
                    do {
                        let archiveData = try NSKeyedArchiver.archivedData(withRootObject: self.main.todos, requiringSecureCoding: false)
                        UserDefaults.standard.set(archiveData, forKey: "todos")
                    } catch {
                        print("error")
                    }
                }, label: {
                    Spacer().frame(width: 12)
                    HStack {
                        VStack {
                            Spacer()
                            Image(systemName: self.checked ? "checkmark.square.fill" : "square")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                    Spacer().frame(width: 14)
                }).onAppear(perform: {
                    self.checked = self.main.todos[self.todoIndex].checked
                })
                
            })
        }
        .background(Color(checked ? "todoItem-bg-checked" : "todoItem-bg"))
        .animation(.spring())
        
    }
}

struct TodoItem_Previews: PreviewProvider {
        static var previews: some View {
        TodoList(main: Main())
    }
}
