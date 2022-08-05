//
//  JSONReadWriteTest.swift
//  PrivacyAnalyticsApp
//
//  Created by Henri Bredt on 05.08.22.
//

import Foundation

func saveLocalData(_ data: Data) {
    do {
        print("Saving")
        let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("privacyReport.json")

        let data = try JSONEncoder().encode(data)
        try data.write(to: fileURL)
        print(data)
    } catch {
        print(error)
    }
}

func loadLocalData(named fileName: String){
    do {
        print("Loading")
        let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(fileName)

        let data = try Data(contentsOf: fileURL)
        print(data)
        
        // Decode data when whe have a model for the data, for now, I'm happy with simply printing the size
        // let appData = try JSONDecoder().decode(AppData.self, from: data)

    } catch {
        print(error)
    }
}
