//
//  MovieGridViewController.swift
//  Flix
//
//  Created by David Ruiz on 9/21/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    
}

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var dataManager = HTTPRequestHandler()
    var movies: [Movie] = []
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        let layout = moviesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 3/2)
        
        dataManager.downloadSimilarMovieData(from: APIURLS.getSimilarMoviesURL(movieID: "297762")) { (movieList: [Movie]) in // Object received from closure
            DispatchQueue.main.async {
                self.movies.append(contentsOf: movieList)
                self.moviesCollectionView.reloadData()
            }
            
            
            print(movieList.count)
            for movie in movieList {
                print(movie)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MovieDetailsSegue" {
            let cell = sender as! UICollectionViewCell
            let indexPath = moviesCollectionView.indexPath(for: cell)!
            let movie = movies[indexPath.row]
            
            let movieDetailsViewController = segue.destination as! MovieDetailsViewController
            movieDetailsViewController.movie = movie
            moviesCollectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MoviesCollectionViewCell
        
        let basePosterURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movies[indexPath.row].posterPath
        let posterURL = URL(string: basePosterURL + posterPath!)
        cell.posterImageView.af.setImage(withURL: posterURL!)
        
        return cell
    }

}
