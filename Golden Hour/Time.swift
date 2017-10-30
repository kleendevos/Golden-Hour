//
//  Time.swift
//  Golden Hour
//
//  Created by vdab cursist on 24/10/2017.
//  Copyright © 2017 vdab cursist. All rights reserved.
//

import Foundation

class Time: Codable {
    
    var sunrise: Date?
    var sunset: Date?
    var civil_twilight_begin: Date?
    var civil_twilight_end: Date?
    var astronomical_twilight_begin: Date?
    var astronomical_twilight_end: Date?
    
    //required init (from decoder: Decoder) throws {
      //  let values = try decoder.container(keyedBy: CodingKeys.self)
        //let sunriseString = try values.decode(String.self, forKey: .sunrise)
        //let sunsetString = try values.decode(String.self, forKey: .sunset)
        //sunrise = Date(sunriseString) ?? 0
        //sunset = Date(sunsetString) ?? 0
       
    //}
    
    
}
