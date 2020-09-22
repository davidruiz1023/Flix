//
//  DataManager.swift
//  Flix
//
//  Created by David Ruiz on 9/8/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import Foundation

struct APIURLS {
    static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    static let nowPlayingMoviesURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)"
    
    static func getSimilarMoviesURL(movieID: String) -> String {
        return "https://api.themoviedb.org/3/movie/\(movieID)/similar?api_key=\(apiKey)"
    }
    
    static func getMovieTrailerKey(movieID: String) -> String {
        return "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiKey)"
    }
}

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

struct MovieTrailers : Codable {

        let results : [MovieTrailer]

        enum CodingKeys: String, CodingKey {
                case results = "results"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
            results = try values.decodeIfPresent([MovieTrailer].self, forKey: .results)!
        }

}

struct MovieTrailer : Codable {

        let id : String?
        let iso31661 : String?
        let iso6391 : String?
        let key : String?
        let name : String?
        let site : String?
        let size : Int?
        let type : String?

        enum CodingKeys: String, CodingKey {
                case id = "id"
                case iso31661 = "iso_3166_1"
                case iso6391 = "iso_639_1"
                case key = "key"
                case name = "name"
                case site = "site"
                case size = "size"
                case type = "type"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                iso31661 = try values.decodeIfPresent(String.self, forKey: .iso31661)
                iso6391 = try values.decodeIfPresent(String.self, forKey: .iso6391)
                key = try values.decodeIfPresent(String.self, forKey: .key)
                name = try values.decodeIfPresent(String.self, forKey: .name)
                site = try values.decodeIfPresent(String.self, forKey: .site)
                size = try values.decodeIfPresent(Int.self, forKey: .size)
                type = try values.decodeIfPresent(String.self, forKey: .type)
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
    
    func downloadSimilarMovieData(from urlString: String, completion: @escaping ([Movie]) -> ()) {
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
    
    func downloadMovieTrailers(from urlString: String, completion: @escaping ([MovieTrailer]) -> ()) {
        //  Calling executeGetRequest(with:)
        executeGetRequest(with: urlString) { (data) in  // Data received from closure
                //  JSON parsing
                let decoder = JSONDecoder()
                guard let results = try? decoder.decode(MovieTrailers.self, from: data!) else {
                    print("no results")
                    return
                }
                
                let movieTrailerList: [MovieTrailer] = results.results
                //  Passing parsed JSON data from closure to the calling method.
                completion(movieTrailerList)
        }
    }
    
}
