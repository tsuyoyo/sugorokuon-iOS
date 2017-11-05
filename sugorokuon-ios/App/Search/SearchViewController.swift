//
//  SearchViewController.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/29.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import RxSwift
import Firebase

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchResultTable: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    fileprivate var searchResult = Array<SearchResult>()
    fileprivate var region: Region!
    
    private let urlManager = UrlManager()
    private var searchApi: SearchApi!
    private var stationApi: StationApi!
    
    fileprivate var viewModel: SearchViewModel!

    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchApi = SearchApi(urlManager: urlManager)
        stationApi = StationApi(urlManager: urlManager)
        viewModel = SearchViewModel(searchApi: searchApi, stationApi: stationApi)
        
        RegionRepository.get()
            .observeRegion()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { region in
                self.region = region
            })
            .addDisposableTo(disposeBag)
        
        viewModel.observeResults()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { results in
                self.searchResult = results
                self.searchResultTable.reloadData()
            })
            .addDisposableTo(disposeBag)
        
        viewModel.observeIsSearching()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { isSearching in
                self.loading.isHidden = !isSearching
            })
            .addDisposableTo(disposeBag)
        
        searchResultTable.register(
            UINib(nibName: "SearchTableViewCell", bundle: nil),
            forCellReuseIdentifier: "searchTableCell"
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchViewController : UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Analytics.logEvent(
            TrackingEvent.SEARCH_RESULT_TAPPED.rawValue,
            parameters: [:])
        
        if let word = searchBar.text {
            viewModel.search(word: word, region: self.region)
        }
        searchBar.endEditing(true)
    }
}

extension SearchViewController : UITableViewDelegate {
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        Analytics.logEvent(
            TrackingEvent.PROGRAM_SEARCHED.rawValue,
            parameters: [:])
        
        let bottomSheet = UIStoryboard(name: "TimeTable", bundle: nil)
            .instantiateViewController(withIdentifier: "programDescription")
            as! ProgramDescriptionViewController
        
        bottomSheet.modalPresentationStyle = .overCurrentContext
        bottomSheet.set(program: searchResult[indexPath.row].program)
        present(bottomSheet, animated: true, completion: nil)
        
        table.deselectRow(at: indexPath, animated: false)
    }
}

extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "searchTableCell",
            for: indexPath) as! SearchTableViewCell
        
        cell.set(searchResult: searchResult[indexPath.row])
        
        return cell
    }
}

