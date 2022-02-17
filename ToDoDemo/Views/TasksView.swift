//
//  TasksView.swift
//  ToDoDemo
//
//  Created by Shuhei Kuroda on 2022/02/04.
//

import SwiftUI
import ComposableArchitecture
import RealmSwift

struct Tasks: Equatable {
  var tasks: [Task] = []
}

enum TasksAction: Equatable {
  case onAppear
  case onTap(id: ObjectId, completed: Bool)
  case onSwipe(id: ObjectId)
  case onUpdated
}

struct TasksEnvironment {
  var realmManager: RealmManager
}

let tasksReducer = Reducer<Tasks, TasksAction, TasksEnvironment> { state, action, environment in
  switch action {
  case .onAppear:
    return Effect(value: .onUpdated)
    
  case .onTap(id: let id, completed: let completed):
    environment.realmManager.updateTask(id: id, completed: !completed)
    return Effect(value: .onUpdated)
    
  case .onSwipe(id: let id):
    environment.realmManager.deleteTask(id: id)
    return Effect(value: .onUpdated)
    
  case .onUpdated:
    state.tasks = environment.realmManager.tasks
    return .none
  }
}

struct TasksView: View {
  @EnvironmentObject var realmManager: RealmManager
  let store: Store<Tasks, TasksAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        Text("My taks")
          .font(.title3).bold()
          .padding()
          .frame(maxWidth: .infinity, alignment: .leading)
        
        List {
          ForEach(realmManager.tasks, id: \.id) { task in
            if !task.isInvalidated {
              TaskRow(
                store: Store(
                  initialState: TaskState(
                    task: task.title,
                    completed: task.completed
                  ),
                  reducer: taskReducer,
                  environment: TaskEnvironment()
                )
              )
                .onTapGesture {
                  viewStore.send(.onTap(id: task.id, completed: task.completed))
                }
                .swipeActions(edge: .trailing) {
                  Button(role: .destructive) {
                    viewStore.send(.onSwipe(id: task.id))
                  } label: {
                    Label("Delete", systemImage: "trash")
                  }
                }
            }
          }
          .listRowSeparator(.hidden)
        }
        .onAppear {
          UITableView.appearance().backgroundColor = UIColor.clear
          UITableViewCell.appearance().backgroundColor = UIColor.clear
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color(hue: 0.086, saturation: 0.141, brightness: 0.972))
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

struct TasksView_Previews: PreviewProvider {
  static var previews: some View {
    TasksView(
      store: Store(
        initialState: Tasks(),
        reducer: tasksReducer,
        environment: TasksEnvironment(
          realmManager: RealmManager()
        )
      )
    )
      .environmentObject(RealmManager())
  }
}
