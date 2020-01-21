//
//  FileCacher.swift
//  iOS_UI_practice1
//
//  Created by Alex on 20/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation

enum CacheWriterStatus {
    case success
    case fileExist
    case memoryException
}

class Cacher {
    
    let fileManager = FileManager.default
    
    func writeFile(file: Data, filename: String) -> CacheWriterStatus {
        let documentsDirectory = fileManager.urls(for: .documentDirectory,
            in: .userDomainMask).first!
        
        let filePath = documentsDirectory.appendingPathComponent(filename)
        
        if !fileManager.fileExists(atPath: filePath.path) {
            do {
                try file.write(to: filePath)
            } catch {
                return .memoryException
            }
        }
        
        return .success
    }
}
