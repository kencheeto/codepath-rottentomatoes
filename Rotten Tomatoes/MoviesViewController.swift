//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Kenshiro Nakagawa on 2/5/15.
//  Copyright (c) 2015 Kenshiro Nakagawa. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var movies: [NSDictionary] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ezghpzed6xckr24nv36b2de8")
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
            self.movies = dictionary["movies"] as [NSDictionary]
            self.tableView.reloadData()
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieTableViewCell") as MovieTableViewCell
        var movie = self.movies[indexPath.row]

        cell.movieSynopsis.text = movie["synopsis"] as? String
        cell.movieTitle.text = movie["title"] as? String
        
        let posterUrl = movie.valueForKeyPath("posters.thumbnail") as String
        let highResPosterUrl = posterUrl.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")
        cell.movieImageView.setImageWithURL(NSURL(string: highResPosterUrl))
        
        cell.movie = movie
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailViewController = segue.destinationViewController as MovieDetailViewController
        let tableViewCell = sender as MovieTableViewCell
        detailViewController.movie = tableViewCell.movie
    }

}
