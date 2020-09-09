//
//  ViewController.swift
//  Flix
//
//  Created by David Ruiz on 9/8/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import AlamofireImage

class customMovieCell: UITableViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
}

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    
    @IBOutlet weak var moviesTableView: UITableView!
    var dataManager = HTTPRequestHandler()
    var apiURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        // Do any additional setup after loading the view.
        dataManager.downloadMovieData(from: apiURL) { (movieList: [Movie]) in // Object received from closure
            DispatchQueue.main.async {
                self.movies.append(contentsOf: movieList)
                self.moviesTableView.reloadData()
            }
            
            
            print(movieList.count)
            for movie in movieList {
                print(movie)
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! customMovieCell
        
        cell.movieTitle.text = movies[indexPath.row].title
        cell.movieDescription.text = movies[indexPath.row].overview
        
        let basePosterURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movies[indexPath.row].posterPath
        let posterURL = URL(string: basePosterURL + posterPath!)
        cell.movieImage.af.setImage(withURL: posterURL!)
        
        return cell
        
       }
    
}

