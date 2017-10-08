//
//  OnAirSongViewController.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/02.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift

class OnAirSongPagerViewController: ButtonBarPagerTabStripViewController {
    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    private let urlManager = UrlManager()
    private let disposeBags = DisposeBag()
    private var viewModel : OnAirSongPagerViewModel!
    private var onAirSongs : Array<OnAirSongsList> = []
    
    override func viewDidLoad() {
        setupTabBar()
        super.viewDidLoad()
        
        bindViewModel()
        viewModel.fetchOnAirSongs(region: "JP13")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var views : [UIViewController] = []

        onAirSongs.forEach {
            let vc = UIStoryboard(name: "TimeTable", bundle: nil).instantiateViewController(withIdentifier: "songList") as! OnAirSongViewController
            vc.set(onAirSongs: $0, feedApi: FeedApi(urlManager: urlManager))
            views.append(vc)
        }
        
        // これちゃんとする (この画面はTimeTableじゃない)
        if views.isEmpty {
            let vc = UIStoryboard(name: "TimeTable", bundle: nil).instantiateViewController(withIdentifier: "timetable") as! TimeTableViewController
            views.append(vc)
        }
        
        return views
    }
    
    private func bindViewModel() {
        viewModel = OnAirSongPagerViewModel(
            stationApi: StationApi(urlManager: urlManager),
            feedApi: FeedApi(urlManager: urlManager))
        
        viewModel.fetchedOnAirSongs
            .observeOn(MainScheduler.instance)
            .subscribe { event in
                self.onAirSongs = event.element!
                self.reloadPagerTabStripView()
            }
            .addDisposableTo(disposeBags)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setupTabBar() {
        settings.style.buttonBarBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        
        settings.style.buttonBarBackgroundColor = UIColor(red: 225/255, green: 245/255, blue: 254/255, alpha: 1.0)
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 0xE1, green: 0xF5, blue: 0xFE, alpha: 1.0)
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .red
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
        }
    }

}
