//
//  StopWatchViewController.swift
//  BondswiftSample-StopWatch
//
//  Created by 田　甜 on 2017/01/19.
//  Copyright © 2017年 田　甜. All rights reserved.
//

import UIKit

import ReactiveKit
import Bond

class StopWatchViewController: UIViewController {

    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var mainButton: UIButton!
    @IBOutlet weak private var clearButton: UIButton!
    
    private let stopWatchViewModel = StopWatchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainButton.bnd_tap.observe { _ in
            self.stopWatchViewModel.mainAction.value.do()
            }.disposeIn(bnd_bag)
        
        clearButton.bnd_tap.observe { _ in
            self.stopWatchViewModel.clearAction.value.do()
            }.disposeIn(bnd_bag)
        
        stopWatchViewModel.mainAction.observeNext { (action: StopWatchViewModel.Action) -> Void in
            self.mainButton.setTitle(action.description, for: .normal)
            }.disposeIn(bnd_bag)
        
        stopWatchViewModel.clearAction.observeNext { (action: StopWatchViewModel.Action) -> Void in
            self.clearButton.setTitle(action.description, for: .normal)
            self.clearButton.isEnabled = action.enabled
            }.disposeIn(bnd_bag)
        
        stopWatchViewModel.time.bind(to: label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var olabel: UILabel!
    
    func otherSampler(){
        // UI Sample 1
        input
            .bnd_text
            .map { (str: String?) -> String? in
                return "Your input is '\(str!)'!"
            }
            .bind(to: label.bnd_text)
        
        
        // Observable sample 2
        let intObservable = Observable<Int>(0)
        
        let _ = intObservable.observeNext(with: { (i: Int) -> Void in
            if i == 3{
                print("san!")
            }else {
                print(intObservable.value)
            }
        })
        
        let _ =  intObservable.observeCompleted { _ -> Void in
            print("Last value emitted.")
        }
        
        intObservable.next(1)
        intObservable.next(2)
        intObservable.next(3)
        
        intObservable.completed()
    }
}
