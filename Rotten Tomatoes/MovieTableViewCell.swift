//
//  MovieTableViewCell.swift
//  Rotten Tomatoes
//
//  Created by Kenshiro Nakagawa on 2/5/15.
//  Copyright (c) 2015 Kenshiro Nakagawa. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieSynopsis: UILabel!

    var movie: NSDictionary!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        movieSynopsis.text = movie["synopsis"] as? String
        movieTitle.text = movie["title"] as? String
        
        let posterUrl = movie.valueForKeyPath("posters.thumbnail") as String
        let highResPosterUrl = posterUrl.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")
        movieImageView.setImageWithURL(NSURL(string: highResPosterUrl))
    }

}
