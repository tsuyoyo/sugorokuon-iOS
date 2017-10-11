//
//  OnAirSongViewController.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/03.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import SafariServices

class OnAirSongViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider {

    private var viewModel : OnAirSongViewModel!
    private var onAirSongs: OnAirSongsList!
    private var feedApi : FeedApi!
    private let disposeBag: DisposeBag = DisposeBag()
    
    private var songs : Array<OnAirSong> = []
    
    @IBOutlet weak var table: UITableView!
    
    private var refreshControl: UIRefreshControl!

    func set(onAirSongs: OnAirSongsList, feedApi: FeedApi) {
        self.onAirSongs = onAirSongs
        self.feedApi = feedApi
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            refreshControl.addTarget(self, action: #selector(OnAirSongViewController.refreshOnAirSong), for: .valueChanged)
            table.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
        
        viewModel = OnAirSongViewModel(onAirSongs: onAirSongs, feedApi: feedApi)
        viewModel.onAirSongs
            .observeOn(MainScheduler.instance)
            .subscribe { event in
                self.songs = event.element!
                self.table.reloadData()
            }
            .addDisposableTo(disposeBag)
        
        viewModel.isFetching
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { fetching in
                if fetching {
                    self.refreshControl.beginRefreshing()
                } else {
                    self.refreshControl.endRefreshing()
                }
            })
            .addDisposableTo(disposeBag)
        
    }
    
    func refreshOnAirSong() {
        viewModel.fetchOnAirSongs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "testCell")!
        
        let image = cell.viewWithTag(1) as! UIImageView?
        let startTime = cell.viewWithTag(2) as! UILabel?
        let title = cell.viewWithTag(4) as! UILabel?
        let artist = cell.viewWithTag(5) as! UILabel?

        let song = songs[indexPath.row]

        // image
        if let imageUrl = song.image, !song.image!.isEmpty {
            image?.sd_setImage(with: URL(string: imageUrl))
        } else {
            image?.image = UIImage(named: "ic_audiotrack_2x.png")
        }

        // OnAir time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        startTime?.text = dateFormatter.string(from: song.onAirTime)

        // Title
        title?.text = song.title

        // Artist
        artist?.text = song.artist
        
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]
        
        // When Japanese is included in urlStr, encode is required otherwise URL(...) returns nil
        let urlStr = "https://www.google.co.jp/search?q=\(song.artist)+\(song.title)"
        let encodedURL = urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL(string: encodedURL!)!

        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: onAirSongs.station.name)
    }

}
