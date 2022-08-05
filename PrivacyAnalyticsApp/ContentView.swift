//
//  ContentView.swift
//  PrivacyAnalyticsApp
//

import SwiftUI

struct ContentView: View {
    
    @State private var isImporting = false
    @State private var reportURL: URL? = nil
    @State private var content: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading) {
                    loadJSONButton
                        .buttonStyle(.bordered)
                    
                    TextEditor(text: $content)
                }
            }
            .padding()
            .navigationTitle("Welcome")
        }
    }
    
    var loadJSONButton: some View {
        Button(action: {
            isImporting = true
        }) {
            HStack(spacing: 12){
                Image(systemName: "doc.badge.plus")
                Text("Import privacy report")
                Spacer()
            }
            .padding(EdgeInsets(top: 5, leading: 4, bottom: 5, trailing: 4))
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.text],
            allowsMultipleSelection: false
        ) { result in
            if case .success = result {
                do {
                    let url: URL = try result.get().first!
                    if url.startAccessingSecurityScopedResource() {
                        reportURL = url
                        
                        if let safeReportURL = reportURL {
                            let text = try String(contentsOf: safeReportURL)
                            content = text
                            
                            // TEST: save and load the file
                            let data = try Data(contentsOf: safeReportURL)
                            saveLocalData(data)
                            loadLocalData(named: "privacyReport.json")
                            
                        } else {
                            print("No URL found")
                        }
                    }
                } catch {
                    let nsError = error as NSError
                    fatalError("File Import Error \(nsError), \(nsError.userInfo)")
                }
            } else {
                print("File Import Failed")
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
