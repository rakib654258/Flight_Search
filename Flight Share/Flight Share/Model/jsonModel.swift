//
//  jsonModel.swift
//  Flight Share
//
//  Created by macOS Mojave on 14/7/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import Foundation

struct Response: Decodable {
    let IsSuccess: Bool
    let Message: String
    let ErrorLog: String
    let Results: result
}

struct result: Decodable {
    let SearchRequest: searchRequest
    let AllGroupedIternaries: [allGroupedIternaries]
    //let Currency: Any
}

struct searchRequest: Decodable {
    //let OriginDestinationInformation: {originDestinationInformation}
    let FromAirport: String
    let ToAirport: String
    let SeatRequested: Int
    let Currency: String
}

//Return Information
struct originDestinationInformation: Decodable {
    let OriginLocationCode: String //CGP
    let DestinationLocationCode: String //DAC
}
struct allGroupedIternaries: Decodable {
    let GroupOriginDestinationOptions: [groupOriginDestinationOptions]
    let AirlineName: String
    let Currency: String
    let Price: Int
}
struct groupOriginDestinationOptions: Decodable {
    let Id: String
    let GroupedOriginDestinations: [groupedOriginDestinations]
}
struct groupedOriginDestinations: Decodable {
    let DepatureAirport: String //DAC
    let ArrivalAirport: String //CGP
    let JourneyDuration: Int
    let Stops: Int
    let DepartureDate: String //with Time
    let ArrivalDate: String //with Time
}
