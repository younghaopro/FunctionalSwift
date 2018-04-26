//
//  ViewController.swift
//  Map&Filter&Reduce
//
//  Created by yanghao on 2018/4/26.
//  Copyright © 2018年 yanghao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let a = genericCompute(array: [1, 2, 3]) { (x) -> String in
            return "\(x)"
        }
        print(a)
    }
}

func increment(array: [Int]) -> [Int] {
    var result: [Int] = []
    for x in array {
        result.append(x)
    }
    return result
}

func genericCompute<T>(array: [Int], transform:(Int) -> T) -> [T] {
    var result: [T] = []
    for x in array {
        result.append(transform(x))
    }
    return result
}

func map<Element, T>(_ array:[Element], tansform:(Element) -> T) -> [T] {
    var result: [T] = []
    for x in array {
        result.append(transform(x))
    }
    return result
}


