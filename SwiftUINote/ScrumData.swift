//
//  ScrumData.swift
//  SwiftUINote
//
//  Created by HuangSenhui on 2020/12/23.
//

import Foundation

class ScrumData: ObservableObject {
    
    private static var documents: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask,appropriateFor: nil,create: false)
        } catch  {
            fatalError("目录不存在")
        }
    }
    private static var fileURL: URL {
        let path = documents.appendingPathComponent("scrums.data")
        print(path)
        return path
    }
    
    @Published var scrums: [DailyScrum] = []
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                #if DEBUG
                DispatchQueue.main.async {
                    self?.scrums = DailyScrum.data
                }
                #endif
                return
            }
            
            guard let dailyscrums = try? JSONDecoder().decode([DailyScrum].self, from: data) else {
                fatalError("Scrum 数据解码失败")
            }
            DispatchQueue.main.async {
                self?.scrums = dailyscrums
            }
        }
    }
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let scrums = self?.scrums else { return }
            guard let data = try? JSONEncoder().encode(scrums) else { fatalError("scrum 数据出错")}
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile)
            } catch {
                fatalError("写入文件出错")
            }
        }
    }
}
