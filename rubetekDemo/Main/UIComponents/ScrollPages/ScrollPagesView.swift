//
//  ScrollPagesView.swift
//  rubetekDemo
//
//  Created by Vlad on 10.08.2021.
//

import Foundation
import UIKit

@IBDesignable
class ScrollPagesView : UIScrollView, UIScrollViewDelegate {
    
    private weak var bindingControl : ScrollPagesControl? = nil
    private var startPage : Int = 0
    private var pageList : [String] = []
    public private(set) var tableViewList : [RubetekTableView] = []
    private var animationTime : TimeInterval = 0.2
    private var isScrollViewFree : Bool = true
    
    private let backgroundView = UIView()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard !self.pageList.isEmpty else { return }
        self.preparingUI()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = self.getCurrentPageIndex()
        guard   !self.pageList.isEmpty
                    && index != self.currentPage
                    && self.bindingControl != nil
                    && self.isScrollViewFree else { return }
        self.bindingControl!.moveUnderlineToPage(index)
        self.updateCurrentPage(newCurrentPage: index)
    }
    
    public func bindWith(_ control : ScrollPagesControl) {
        self.pageList = control.pageList
        self.startPage = control.currentPage
        self.bindingControl = control
        self.animationTime = control.animationTime
        
        self.pageList.enumerated().forEach { (index,_) in
            switch index {
            case 0:
                self.tableViewList.append(RubetekCameraTableView())
            case 1:
                self.tableViewList.append(RubetekDoorTableView())
            default:
                self.tableViewList.append(RubetekTableView())
            }
        }
        self.layoutSubviews()
    }
    
    public func scrollToPage(_ index : Int ) {
        guard   (index != self.getCurrentPageIndex())
                    && (self.pageList.startIndex...self.pageList.endIndex).contains(index)
                    && (!self.pageList.isEmpty)
                    && self.isScrollViewFree else { return }
        self.isScrollViewFree = false
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.animationTime) {
                self.contentOffset.x = CGFloat(CGFloat(index)*self.frame.width)
            } completion: { _ in
                self.updateCurrentPage(newCurrentPage: index)
                self.isScrollViewFree = true
            }
        }
    }
    
    private func getCurrentPageIndex() -> Int {
        return Int(round(self.contentOffset.x/self.frame.width))
    }
    
    private func preparingUI() {
        
        self.delegate = self
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        
        let viewWidth = self.frame.width
        let viewHeight = self.frame.height
        
        self.contentSize = CGSize(width: viewWidth * CGFloat(self.pageList.count), height: viewHeight)
        
        for (index,tableView) in self.tableViewList.enumerated() {
            
            tableView.frame = CGRect(x: CGFloat(index) * viewWidth, y: .zero, width: viewWidth, height: viewHeight)
            self.addSubview(tableView)
            self.tableViewList.append(tableView)
        }
        self.scrollToPage(self.startPage)
    }

    //  OBSERVER
    public var currentPage : Int = 0
    private lazy var subscribers : [WeakPageSubscriber] = []

    public func subscribeOnCurrentPage(_ subscriber: PageSubscriber) {
        self.subscribers.append(WeakPageSubscriber(value: subscriber))
    }

    public func unsubscribeOnCurrentPage(_ subscriber: PageSubscriber) {
        self.subscribers.removeAll(where: { $0.value === subscriber })
    }

    private func notify() {
        self.subscribers.forEach { $0.value?.pagesViewUpdateCurrentPage(currentPage: self.currentPage)}
    }

    private func updateCurrentPage(newCurrentPage : Int) {
        self.currentPage = newCurrentPage
        notify()
    }
}
