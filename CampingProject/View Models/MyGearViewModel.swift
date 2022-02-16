//
//  MyGearViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/06.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

public protocol MyGearInput{
    func didSelectCell(cell:Observable<ViewGear>)
    func loadGears()
    func loadGearTypes()
}
public protocol MyGearOutput{
    var gears: Observable<[CellData]> { get }
    var gearTypes: Observable<[GearType]> { get }
    var didSelectViewGear: Observable<ViewGear> { get }
}

public protocol MyGearViewModelType {
    var inputs: MyGearInput { get }
    var outputs: MyGearOutput { get }
    
}

public class MyGearViewModel: MyGearInput,MyGearOutput, MyGearViewModelType {
    private let store = Store.shared
    private let apiManager = APIManager.shared
    private let disposeBag = DisposeBag()
    
    private let _gears = BehaviorRelay<[CellData]>(value: [])
    private let _gearTypes = BehaviorRelay<[GearType]>(value: [])
    private let _viewGear = PublishSubject<ViewGear>()
    
    
    public var didSelectViewGear: Observable<ViewGear> {
        return _viewGear.asObservable()
    }
    
    public var gears: Observable<[CellData]> {
        return _gears.asObservable()
    }
    
    public var gearTypes: Observable<[GearType]> {
        return _gearTypes.asObservable()
    }
    
    public func loadGears(){
        store.loadUserGearRx().map{ $0 }.subscribe(onNext:{
            self._gears.accept($0)
        }).disposed(by: disposeBag)
    }
    
    public func loadGearTypes(){
        apiManager.loadGearType().map{ $0 }.subscribe(onNext:{
            self._gearTypes.accept($0)
        }).disposed(by: disposeBag)
    }

    public func didSelectCell(cell: Observable<ViewGear>) {
        cell.subscribe(onNext: {
            self._viewGear.onNext($0)
        }).disposed(by: disposeBag)
    }
    
    public var inputs: MyGearInput { return self }
    public var outputs: MyGearOutput { return self }
}
