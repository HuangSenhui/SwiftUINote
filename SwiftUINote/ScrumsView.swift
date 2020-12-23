//
//  ScrumsView.swift
//  SwiftUINote
//
//  Created by HuangSenhui on 2020/12/22.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var secnePhase
    @State private var isPresented = false
    @State private var newScrumData = DailyScrum.Data()
    
    let saveAction: ()->Void
    
    var body: some View {
        List {
            ForEach(scrums) { scrum in
                NavigationLink(
                    destination: DetailView(scrum: binding(for: scrum)),
                    label: {
                        CardView(scrum: scrum)
                    })
                    .listRowBackground(scrum.color)
            }
        }
        .navigationTitle("Daily Scrums")
        .navigationBarItems(trailing: Button(action: {
            isPresented = true
        }, label: {
            Image(systemName: "plus")
        }))
        .sheet(isPresented: $isPresented, content: {
            NavigationView {
                EditView(scrumData: $newScrumData)
                    .navigationBarItems(leading: Button(action: {
                        isPresented = false
                    }, label: {
                        Text("取消")
                    }), trailing: Button(action: {
                        isPresented = false
                        let newScrum = DailyScrum(title: newScrumData.title, attendees: newScrumData.attendees, lengthInMinutes: Int(newScrumData.lengthInMinutes), color: newScrumData.color)
                        scrums.append(newScrum)
                    }, label: {
                        Text("新增")
                    }))
            }
        })
        .onChange(of: secnePhase, perform: { value in
            if value == .inactive { saveAction() }
        })
        
    }
    
    private func binding(for scrum: DailyScrum) -> Binding<DailyScrum> {
        guard let scrumIndex = scrums.firstIndex(where: { $0.id == scrum.id }) else {
            fatalError("没有找到 scrum")
        }
        return $scrums[scrumIndex]
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrumsView(scrums: .constant(DailyScrum.data), saveAction: {})
        }
    }
}
