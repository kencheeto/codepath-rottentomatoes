//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Kenshiro Nakagawa on 2/5/15.
//  Copyright (c) 2015 Kenshiro Nakagawa. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var refreshControl: UIRefreshControl!
    var movies: [NSDictionary] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        self.networkErrorLabel.hidden = true

        fetch()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieTableViewCell") as MovieTableViewCell
        var movie = self.movies[indexPath.row]
        cell.movie = movie
        cell.setup()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func fetch() {
        SVProgressHUD.show()
        self.networkErrorLabel.hidden = true
        let url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ezghpzed6xckr24nv36b2de8")
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            self.refreshControl.endRefreshing()
            if error != nil {
//            if true {
                self.networkErrorLabel.hidden = false
                self.tableView.hidden = true
            } else {
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = dictionary["movies"] as [NSDictionary]
            }
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        })
    }
    
    func onRefresh() {
        fetch()
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
