//
//  DetailView.swift
//  SwiftUINote
//
//  Created by HuangSenhui on 2020/12/22.
//

import SwiftUI

struct DetailView: View {
    
    @Binding var scrum: DailyScrum
    @State private var data = DailyScrum.Data()
    @State private var isPresented = false
    
    var body: some View {
        List {
            Section(header: Text("会议信息")) {
                NavigationLink(
                    destination: MeetingView(scrum: $scrum),
                    label: {
                        Label("开始会议", systemImage: "timer")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .accessibilityLabel(Text("开始会议"))
                    })
                HStack {
                    Label("时长", systemImage: "clock")
                        .accessibilityLabel(Text("会议时长"))
                    Spacer()
                    Text("\(scrum.lengthInMinutes)分钟")
                }
                HStack {
                    Label("Color", systemImage: "paintpalette")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(scrum.color)
                }
                .accessibilityElement(children: .ignore)
            }
            
            Section(header: Text("出场嘉宾")) {
                ForEach(scrum.attendees, id: \.self) { attendee in
                    Label(attendee, systemImage: "person")
                        .accessibilityLabel(Text("出席者"))
                        .accessibilityValue(Text(attendee))
                }
            }
            
            Section(header: Text("历史记录")) {
                if scrum.history.isEmpty {
                    Label("没有记录", systemImage: "calendar.badge.exclamationmark")
                }
                
                ForEach(scrum.history) { history in
                    NavigationLink(
                        destination: HistoryView(history: history),
                        label: {
                            HStack {
                                Image(systemName: "calendar")
                                Text(history.date, style: .date)
                            }
                        })
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button(action: {
            isPresented = true
            data = scrum.data
        }, label: {
            Text("编辑")
        }))
        .navigationTitle(scrum.title)
        .fullScreenCover(isPresented: $isPresented, content: {
            NavigationView {
                EditView(scrumData: $data)
                    .navigationTitle(scrum.title)
                    .navigationBarItems(leading: Button(action: {
                        isPresented = false
                    }, label: {
                        Text("取消")
                    }), trailing: Button(action: {
                        isPresented = false
                        scrum.update(from: data)
                    }, label: {
                        Text("完成")
                    }))
            }
        })
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(scrum: .constant(DailyScrum.data[0]))
        }
    }
}
