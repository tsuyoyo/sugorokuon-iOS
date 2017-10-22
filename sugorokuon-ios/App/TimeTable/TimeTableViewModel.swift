//
//  TimeTableViewModel.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/21.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift

protocol TimeTableViewModelOutput {
    var fetchedPrograms : Observable<Array<Program>> { get }
    var onAirProgramIndex : Observable<Int> { get }
}

class TimeTableViewModel {
    fileprivate let programs = BehaviorSubject<Array<Program>>(value: [])
    fileprivate let onAirIndex = BehaviorSubject<Int>(value: 0)
    fileprivate let timeTable : TimeTable
    
    private let radikoDateUtil : RadikoDateUtil
    
    init(timeTable : TimeTable, radikoDateUtil : RadikoDateUtil) {
        self.timeTable = timeTable
        self.radikoDateUtil = radikoDateUtil
        
        programs.onNext(timeTable.programs)
        
        for (index, program) in timeTable.programs.enumerated() {
            if radikoDateUtil.isNowOnAir(program: program) {
                onAirIndex.onNext(index)
            }
        }
    }
}

extension TimeTableViewModel : TimeTableViewModelOutput {
    var onAirProgramIndex: Observable<Int> {
        return onAirIndex.asObserver()
    }
    
    var fetchedPrograms: Observable<Array<Program>> {
        return programs.asObservable()
    }
}
