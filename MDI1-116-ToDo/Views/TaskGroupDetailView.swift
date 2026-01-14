//
//  TaskGroupDetailView.swift
//  MDI1-114-ToDo
//
//  Created by Christian Bonilla on 09/12/25.
//

import SwiftUI

struct TaskGroupDetailView: View {
    @Binding var groups: TaskGroup
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        VStack {
            List {
                if sizeClass == .regular {
                    GroupStatsView(group: groups, tasks: groups.tasks)
                }
                ForEach($groups.tasks) { $task in
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(task.isCompleted ? .cyan : .gray)
                            .onTapGesture {
                                withAnimation {
                                    task.isCompleted.toggle()
                                }
                            }
                        
                        TextField("Task Title", text: $task.title)
                            .strikethrough(task.isCompleted)
                    }
                }
                .onDelete { index in
                    groups.tasks.remove(atOffsets: index)
                }
            }
        }
        .navigationTitle(groups.title)
        .toolbar {
            Button("Add Task") {
                withAnimation {
                    groups.tasks.append(TaskItem(title: ""))
                }
            }
            .accessibilityIdentifier("addTaskButton")
        }
    }
}
