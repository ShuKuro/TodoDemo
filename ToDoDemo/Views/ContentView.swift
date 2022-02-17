//
//  ContentView.swift
//  ToDoDemo
//
//  Created by Shuhei Kuroda on 2022/01/26.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  @StateObject var realmManager = RealmManager()
  @State private var showAddTaskView = false
  
  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      TasksView(
        store: Store(
          initialState: Tasks(),
          reducer: tasksReducer,
          environment: TasksEnvironment(
            realmManager: realmManager
          )
        )
      )
        .environmentObject(realmManager)
      
      SmallAddButton()
        .padding()
        .onTapGesture {
          showAddTaskView.toggle()
        }
    }
    .sheet(isPresented: $showAddTaskView) {
      AddTaskView(
        store: Store(
          initialState: AddTaskState(),
          reducer: addTaskReducer,
          environment: AddTaskEnvironment(
            realmManager: realmManager
          )
        )
      )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    .background(Color(hue: 0.086, saturation: 0.141, brightness: 0.972))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
