//
//  SearchTableViewCell.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/29.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import SDWebImage

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var onAirDate: UILabel!
    
    @IBOutlet weak var onAirTime: UILabel!
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var personality: UILabel!
    
    @IBOutlet weak var stationLogo: UIImageView!
    
    private var searchResult: SearchResult?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(searchResult: SearchResult) {
        self.searchResult = searchResult
        title.text = searchResult.program.title
        personality.text = searchResult.program.personality
        
        // date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ja_JP")
        dateFormatter.dateFormat = "MM/dd(E)"
        onAirDate.text = dateFormatter.string(from: searchResult.program.startTime)
        
        // time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let startTime = timeFormatter.string(from: searchResult.program.startTime)
        let endTime = timeFormatter.string(from: searchResult.program.endTime)
        onAirTime.text = "\(startTime) - \(endTime)"
        
        // image
        if let thumbnailUrl = searchResult.program.image {
            thumbnail.clipsToBounds = true
            thumbnail.layer.cornerRadius = thumbnail.frame.height / 2
            thumbnail.sd_setImage(with: URL(string: thumbnailUrl))
        } else {
            thumbnail.sd_setImage(with: URL(string: searchResult.station.logoUrl))
        }
        
        // station
        stationLogo.sd_setImage(with: URL(string: searchResult.station.logoUrl))
    }
}
