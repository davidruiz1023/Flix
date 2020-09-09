//
//  DataManager.swift
//  Flix
//
//  Created by David Ruiz on 9/8/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import Foundation

struct Movies: Codable {
    var results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([Movie].self, forKey: .results)!
    }
}

struct Movie : Codable {

        let adult : Bool?
        let backdropPath : String?
        let genreIds : [Int]?
        let id : Int?
        let originalLanguage : String?
        let originalTitle : String?
        let overview : String?
        let popularity : Float?
        let posterPath : String?
        let releaseDate : String?
        let title : String?
        let video : Bool?
        let voteAverage : Float?
        let voteCount : Int?

        enum CodingKeys: String, CodingKey {
                case adult = "adult"
                case backdropPath = "backdrop_path"
                case genreIds = "genre_ids"
                case id = "id"
                case originalLanguage = "original_language"
                case originalTitle = "original_title"
                case overview = "overview"
                case popularity = "popularity"
                case posterPath = "poster_path"
                case releaseDate = "release_date"
                case title = "title"
                case video = "video"
                case voteAverage = "vote_average"
                case voteCount = "vote_count"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
                backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
                genreIds = try values.decodeIfPresent([Int].self, forKey: .genreIds)
                id = try values.decodeIfPresent(Int.self, forKey: .id)
                originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
                originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
                overview = try values.decodeIfPresent(String.self, forKey: .overview)
                popularity = try values.decodeIfPresent(Float.self, forKey: .popularity)
                posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
                releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
                title = try values.decodeIfPresent(String.self, forKey: .title)
                video = try values.decodeIfPresent(Bool.self, forKey: .video)
                voteAverage = try values.decodeIfPresent(Float.self, forKey: .voteAverage)
                voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
        }

}

class HTTPRequestHandler: NSObject {
    
   private func get_request(_ data_url: String) -> URLRequest {
        var request = URLRequest(url:  URL(string: data_url)!)
        request.httpMethod = "GET"
        return request
    }
    
    //  Function to execute GET request and pass data from escaping closure
   private func executeGetRequest(with urlString: String, completion: @escaping (Data?) -> ()) {

        let url = URL.init(string: urlString)
        let urlRequest = get_request(url!.absoluteString)

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            //  Log errors (if any)
            if error != nil {
                print(error.debugDescription)
            } else {
                //  Passing the data from closure to the calling method
                //print("JSON String: \(String(describing: String(data: data!, encoding: .utf8)))")
                completion(data)
            }
        }.resume()  // Starting the dataTask
    }
    
    //  Function to perform a task - Calls executeGetRequest(with urlString:) and receives data from the closure.
    func downloadMovieData(from urlString: String, completion: @escaping ([Movie]) -> ()) {
        //  Calling executeGetRequest(with:)
        executeGetRequest(with: urlString) { (data) in  // Data received from closure
                //  JSON parsing
                let decoder = JSONDecoder()
                guard let results = try? decoder.decode(Movies.self, from: data!) else {
                    print("no results")
                    return
                }
                
                let movieList: [Movie] = results.results
                //  Passing parsed JSON data from closure to the calling method.
                completion(movieList)
        }
    }
    
}
