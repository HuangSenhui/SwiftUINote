//
//  EditView.swift
//  SwiftUINote
//
//  Created by HuangSenhui on 2020/12/22.
//

import SwiftUI

struct EditView: View {
    
    @Binding var scrumData: DailyScrum.Data
    @State private var newAttendee = ""
    
    var body: some View {
        List {
            Section(header: Text("会议信息")) {
                TextField("标题", text: $scrumData.title)
                HStack {
                    Slider(value: $scrumData.lengthInMinutes, in: 5...30, step: 1.0) {
                        Text("时长")
                    }
                    .accessibilityValue(Text("\(Int(scrumData.lengthInMinutes))分钟"))
                    Spacer()
                    Text("\(Int(scrumData.lengthInMinutes))分钟")
                        .accessibilityHidden(true)
                }
                
                ColorPicker("颜色", selection: $scrumData.color)
                    .accessibilityLabel(Text("颜色选择器"))
            }
            
            Section(header: Text("出席嘉宾")) {
                ForEach(scrumData.attendees, id: \.self) { attendee in
                    Text(attendee)
                }
                .onDelete(perform: { indexSet in
                    scrumData.attendees.remove(atOffsets: indexSet)
                })
                
                HStack {
                    TextField("新嘉宾", text: $newAttendee)
                    Button(action: {
                        withAnimation {
                            scrumData.attendees.append(newAttendee)
                            newAttendee = ""
                        }
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel(Text("增加出场嘉宾"))
                    })
                    .disabled(newAttendee.isEmpty)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(scrumData: .constant(DailyScrum.data[0].data))
    }
}
