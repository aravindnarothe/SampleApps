//
//  FileManager.swift
//  DemoClassifieds
//
//  Created by Aravind on 11/12/2021.
//

import UIKit

final class AppFileManager {
    
    static let sharedInstance = AppFileManager()
    
    private init() {}
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save(data: Data, name: String) {
        let documentsDirectoryPath = getDocumentsDirectory()
        let imagePath = documentsDirectoryPath.appendingPathComponent(name)
        do {
            try data.write(to: imagePath)
        } catch {
            print("Unable to Write Data to Disk (\(error))")
        }
    }

    func getFile(path: String) -> Data? {
        let url = URL(fileURLWithPath: path)
        return try? Data(contentsOf: url)
    }
    
}
