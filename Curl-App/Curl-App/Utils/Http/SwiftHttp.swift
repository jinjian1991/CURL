//
//  SwiftHttp.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/9.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import UIKit

class SwiftHttp: NSObject {
    //     func showDialog(_ title: String, message: String) {

    public func POST(_ url: String, body: Any) {
        let aUrl = URL(string: url)
        let session = URLSession.shared
        var request = URLRequest(url: aUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body,
                                                          options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data,
                                                               options: .mutableContainers) as? [String: Any] {
                    // handler json
                    print("response_data_type: \(type(of: data))")
                    print("response_json_type: \(type(of: json))")
                    print("response_json: \(json)")
                }
            } catch let error {
                print("json_error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
