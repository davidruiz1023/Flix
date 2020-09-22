//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by David Ruiz on 9/20/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    
    var movie: Movie!

    @IBOutlet weak var backgroundPosterImageView: UIImageView!
    @IBOutlet weak var smallPosterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.text = movie.title 
        movieDescriptionLabel.text = movie.overview
        downloadPosters()
        
    }
    
    func downloadPosters() {
        let basePosterURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie.posterPath
        let posterURL = URL(string: basePosterURL + posterPath!)
        smallPosterImageView.af.setImage(withURL: posterURL!)
        let backgroundPosterPath = movie.backdropPath
        let backgroundPosterURL = URL(string: "https://image.tmdb.org/t/p/w780" + backgroundPosterPath!)
        backgroundPosterImageView.af.setImage(withURL: backgroundPosterURL!)
    }
    
    @IBAction func moviePosterPressed(_ sender: Any) {
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "MovieTrailerSegue" {
            let movieTrailerViewController = segue.destination as! MovieTrailerViewController
            movieTrailerViewController.movie = movie
           
        }
        
    }
    

}
