//
//  Post.swift
//  Crewlo
//
//  Created by Corey Howell on 2/6/16.
//  Copyright © 2016 Crewlo. All rights reserved.
//

import Foundation
import Alamofire

class Post {
    let body: String
    let latitude: Double
    let longitude: Double
    let userId: Int
    
    init(userId: Int, body: String, latitude: Double, longitude: Double) {
        self.userId = userId;
        self.body = body;
        self.latitude = latitude;
        self.longitude = longitude;
    }
    
    func save() {
        let parameters: Dictionary<String, AnyObject> = [
            "user_id": userId,
            "body": body,
            "latitude": latitude,
            "longitude": longitude
        ];
        Alamofire.request(.POST, "http://Coreys-MacBook-Pro.local:3000/api/v1/posts", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                let message = response.result;
                print(message);
        }
    }
}