//
//  SecretDecoder.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 22/06/25.
//

import Foundation

enum Secrets {
    static var apiKey: String {
        guard let key = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            fatalError("Secret key not found")
        }
        return key
}
}
