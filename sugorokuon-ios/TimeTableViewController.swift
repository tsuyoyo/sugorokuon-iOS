//
//  TImeTableViewController.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/21.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import RxSwift
import XLPagerTabStrip
import SDWebImage

import MaterialComponents.MaterialBottomSheet

class TimeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider {
    
    private let disposeBag = DisposeBag()
    
    private var viewModel : TimeTableViewModel?
    private var station : Station?
    private var day : Week?
    
    private var programs : Array<Program> = []
    
    @IBOutlet weak var table: UITableView!

    func setup(station: Station,
               day: Week,
               repository: TimeTableRepository,
               urlManager: UrlManager) -> Void {
        self.viewModel = TimeTableViewModel(repository: repository, urlManager: urlManager)
        self.station = station
        self.day = day
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let stationId = station?.id, let day = day {
            viewModel?.setTimeTable(station: stationId, day: day)
        }
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func bindViewModel() {
        viewModel?.fetchedPrograms
            .observeOn(MainScheduler.instance)
            .subscribe { event in
                if let programs = event.element {
                    self.programs = programs
                } else {
                    self.programs = []
                }
                self.table.reloadData()
            }
            .addDisposableTo(disposeBag)
    }

    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programs.count
    }
    
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "programCell", for: indexPath)

        let title = table.viewWithTag(1) as! UILabel?
        let personalities = table.viewWithTag(2) as! UILabel?
        let image = table.viewWithTag(3) as! UIImageView?
        
        let p = programs[indexPath.row]
        title?.text = p.title
        personalities?.text = p.personality
        
        if let imageUrl = station?.logoUrl {
            image?.sd_setImage(with: URL(string: imageUrl))
        }
        
        return cell
    }
    
    // Cell が選択された場合
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        print("on program is selected : title = \(self.programs[indexPath.row].title)")
        
        let bottomSheetViewController = UIStoryboard(name: "TimeTable", bundle: nil).instantiateViewController(withIdentifier: "programDescription")
            as! ProgramDescriptionViewController
//        vc.setup(station: $0, day: .Monday, repository: repository, urlManager: urlManager)
//        views.append(vc)
        
        // View controller the bottom sheet will hold
//        let bottomSheetViewController = ProgramDescriptionViewController()
        
        bottomSheetViewController.modalPresentationStyle = .overCurrentContext
        
        let program = self.programs[indexPath.row]        
        bottomSheetViewController.set(program: program)

        // Present the bottom sheet
        present(bottomSheetViewController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        if let stationName = station?.name {
            return IndicatorInfo(title: stationName)
        } else {
            return IndicatorInfo(title: "No station name")
        }

    }
}