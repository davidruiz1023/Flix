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
   
    var dataManager = HTTPRequestHandler()
    var movies: [Movie] = []
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        // Do any additional setup after loading the view.
        dataManager.downloadMovieData(from: APIURLS.nowPlayingMoviesURL) { (movieList: [Movie]) in // Object received from closure
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MovieDetailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = moviesTableView.indexPath(for: cell)!
            let movie = movies[indexPath.row]
            
            let movieDetailsViewController = segue.destination as! MovieDetailsViewController
            movieDetailsViewController.movie = movie
            moviesTableView.deselectRow(at: indexPath, animated: true)
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! customMovieCell
        
        cell.movieTitle.text = movies[indexPath.row].title
        cell.movieDescription.text = movies[indexPath.row].overview
        
        let basePosterURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movies[indexPath.row].posterPath
        let posterURL = URL(string: basePosterURL + posterPath!)
        cell.movieImage.af.setImage(withURL: posterURL!)
        
        return cell
        
       }
    
}

