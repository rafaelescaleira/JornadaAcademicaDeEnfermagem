//
//  CSV.swift
//  expresso_nioaque
//
//  Created by Rafael Escaleira on 06/07/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import UIKit

public class CSV: NSObject {
    
    private static func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    public static func generateCSV(csvText: String, fileName: String) -> URL {
        
        let path = getDocumentsDirectory().appendingPathComponent("\(fileName).csv")
        
        do { try csvText.write(to: path, atomically: true, encoding: String.Encoding.utf8) }
        catch { print("Error to write") }
        
        return path
    }
}
