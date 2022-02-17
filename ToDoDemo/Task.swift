//
//  Task.swift
//  ToDoDemo
//
//  Created by Shuhei Kuroda on 2022/02/13.
//

import Foundation
import RealmSwift

class Task: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var title = ""
  @Persisted var completed = false 
}
