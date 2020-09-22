//
//  MovieTrailerViewController.swift
//  Flix
//
//  Created by David Ruiz on 9/21/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import WebKit

class MovieTrailerViewController: UIViewController {
    
    var movie: Movie!
    var dataManager = HTTPRequestHandler()
    
    //var trailerWebView = WKWebView()
    
    @IBOutlet weak var trailerWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        trailerWebView.configuration.allowsInlineMediaPlayback = true
//        trailerWebView.configuration.mediaTypesRequiringUserActionForPlayback = []
//
//        dataManager.downloadMovieTrailers(from: APIURLS.getMovieTrailerKey(movieID: movie.id!.description)) { (movieTrailerList: [MovieTrailer]) in
//            self.loadTrailer(videoKey: movieTrailerList[0].key!)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        trailerWebView.configuration.allowsInlineMediaPlayback = true
        trailerWebView.configuration.mediaTypesRequiringUserActionForPlayback = []

        dataManager.downloadMovieTrailers(from: APIURLS.getMovieTrailerKey(movieID: movie.id!.description)) { (movieTrailerList: [MovieTrailer]) in
            self.loadTrailer(videoKey: movieTrailerList[0].key!)
        }
    }
    
    func loadTrailer(videoKey: String) {
        let videoURLString = "https://www.youtube.com/watch?v=\(videoKey)"
        let link = URL(string: videoURLString)!
        let request = URLRequest(url: link)
        DispatchQueue.main.async {
            self.trailerWebView.load(request)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
