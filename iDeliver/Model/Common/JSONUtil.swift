//
//  JSONUtil.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation

class JSONUtil {
    static func loadJSON<T>(fileName file: String) -> T? where T : Codable {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
            print("Error reading file: \(file)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(T.self, from: data)
            return jsonData
        } catch {
            print("Error decoding data: \(error)")
            return nil
        }
    }
    
}
