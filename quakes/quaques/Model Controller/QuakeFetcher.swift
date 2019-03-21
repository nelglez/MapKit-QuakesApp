//
//  QuakeFetcher.swift
//  quaques
//
//  Created by Nelson Gonzalez on 3/21/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation

class QuakeFetcher {
    
    enum FetcherError: Int, Error {
        case invalidURL
        case APIError
        case noDataReturned
        case decodingError
        case dateMathError
    }
    
    
    //Conveniece method to fetch the quakes in the last week
    
    func fetchuakes(completion: @escaping([Quake]?, FetcherError?) -> Void) {
        
        let calendar = Calendar.current
        
        //end date for API
        let now = Date()
        
        var dateComponents = DateComponents() //date, month, year, weekday, era, etc...
        dateComponents.calendar = calendar
        dateComponents.day = -7
        
        guard let oneWeekAgo = calendar.date(byAdding: dateComponents, to: now) else {
            completion(nil, .dateMathError)
            return
        }
        
        let interval = DateInterval(start: oneWeekAgo, end: now)
        
        //Same thing as the bottom one
        /*
        fetchQuake(from: interval) { (quakes, error) in
            completion(quakes, error)
        }
        */
        fetchQuake(from: interval, completion: completion)
        
        
    }
    
    
    
    //we just want to create one in memery to not waste resources
    let dateFormatter = ISO8601DateFormatter()
    
    let baseURL = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query")!
    
    func fetchQuake(from dateInterval: DateInterval, completion: @escaping([Quake]?, FetcherError?) -> Void) {
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let startTime = dateFormatter.string(from: dateInterval.start)
        let endTime = dateFormatter.string(from: dateInterval.end)
        
        let queryItems = [URLQueryItem(name: "format", value: "geojson"),
                          URLQueryItem(name: "endtime", value: endTime),
                          URLQueryItem(name: "starttime", value: startTime)]
        
        components?.queryItems = queryItems
        
        //get the fully formatted url from the components
        
        guard let requestURL = components?.url else {
            NSLog("Error creating URL from components")
            completion(nil, .invalidURL)
            return
        }
        
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching Quakes: \(error)")
                completion(nil, .APIError)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned drom data task")
                completion(nil, .noDataReturned)
                return
            }
            
            //decode the Quakes
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .millisecondsSince1970
                
                let quakes = try jsonDecoder.decode(QuakeResults.self, from: data).features //get array of quakes
                completion(quakes, nil)
                
            } catch {
                NSLog("Error decoding JSON: \(error)")
                completion(nil, .decodingError)
                return
            }
            
        }.resume()
        
    }
    
    
    
    
    
    
    
}
