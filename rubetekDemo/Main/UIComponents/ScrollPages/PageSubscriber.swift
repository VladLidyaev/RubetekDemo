//
//  PageSubscriber.swift
//  rubetekDemo
//
//  Created by Vlad on 10.08.2021.
//

import Foundation

protocol PageSubscriber : AnyObject {
    func pagesViewUpdateCurrentPage(currentPage : Int)
}

struct WeakPageSubscriber {
    weak var value : PageSubscriber?
}
