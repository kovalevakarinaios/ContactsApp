//
//  Storage.swift
//  ContactsApp
//
//  Created by Karina Kovaleva on 1.05.24.
//

import Foundation

class Storage {
    
    static public func readContacts() -> [Contact]? {
        guard let fileURL = self.makeURL(fileName: "contacts.json") else { return nil }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let readingData = try decoder.decode([Contact].self, from: data)
            return readingData
        } catch {
            print("Error decoding data: \(error)")
            return nil
        }
    }
    
    static public func saveContacts(contacts: [Contact]) {
        guard let fileURL = self.makeURL(fileName: "contacts.json") else { return }
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(contacts)
            try jsonData.write(to: fileURL)
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    static private func makeURL(fileName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return url.appendingPathComponent(fileName)
    }
    
}
