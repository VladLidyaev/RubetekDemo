//
//  ScrollPagesControl.swift
//  rubetekDemo
//
//  Created by Vlad on 10.08.2021.
//

import Foundation
import UIKit

@IBDesignable
class ScrollPagesControl : UIControl {
    
    private var bindingView : ScrollPagesView? = nil
    private var underlineView : UIView? = nil
    
    public private(set) var currentPage : Int = 0
    public private(set) var pageList : [String] = ["Title1","Title2"]
    public private(set) var animationTime : TimeInterval = 0.2
    private var sections : [UIButton] = []
    private var isUnderlineViewFree : Bool = true
    
    @IBInspectable var color: UIColor = .clear {
        didSet { self.layoutSubviews() }
    }
    
    @IBInspectable var selectorHeight: CGFloat = 3 {
        didSet { self.layoutSubviews() }
    }
    
    @IBInspectable var selectorColor: UIColor = .blue {
        didSet { self.layoutSubviews() }
    }
    
    @IBInspectable var textColor: UIColor = .black {
        didSet { self.layoutSubviews() }
    }
    
    @IBInspectable var pageTitleFont: UIFont = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.light) {
        didSet { self.layoutSubviews() }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard !self.pageList.isEmpty else { return }
        self.preparingUI()
        self.initSections()
        self.preparingUnderlineView()
        self.preparingStackView()
    }
    
    public func bindWith(_ pages : [String], view : ScrollPagesView) {
        self.pageList = pages
        self.bindingView = view
        self.layoutSubviews()
    }
    
    public func moveUnderlineToPage(_ index : Int) {
        self.goToPage(index, scrollingPages: false)
    }
    
    private func preparingUI() {
        self.backgroundColor = self.color
    }
    
    private func preparingStackView() {
        
        let stack = UIStackView(arrangedSubviews: sections)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.frame = CGRect(x: .zero, y: .zero, width: self.frame.width, height: self.frame.height)
        self.addSubview(stack)
    }
    
    private func preparingUnderlineView() {
        
        let backgroundSectionLayer = CAGradientLayer()
        backgroundSectionLayer.frame = CGRect(x: .zero, y: self.frame.height - self.selectorHeight, width: self.frame.width, height: self.selectorHeight)
        backgroundSectionLayer.colors = [UIColor.black.withAlphaComponent(0.05).cgColor, UIColor.clear.cgColor]
        self.layer.addSublayer(backgroundSectionLayer)
        
        
        let sectionWidth = self.frame.width / CGFloat(self.pageList.count)
        self.underlineView = UIView(frame: CGRect(x: CGFloat(self.currentPage)*sectionWidth, y: self.frame.height - self.selectorHeight, width: sectionWidth, height: self.selectorHeight))
        self.underlineView!.layer.cornerRadius = self.selectorHeight/2
        self.underlineView!.backgroundColor = self.selectorColor
        self.addSubview(self.underlineView!)
    }
    
    private func initSections() {
        
        self.sections = [UIButton]()
        self.sections.removeAll()
        self.subviews.forEach { $0.removeFromSuperview() }
        self.pageList.forEach { (pageName) in
            let btn = self.preparingSection(title: pageName)
            self.sections.append(btn)
        }
    }
    
    private func preparingSection(title : String) -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(sectionTapped), for: .touchUpInside)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = self.pageTitleFont
        button.setTitleColor(self.textColor, for: .normal)
        button.backgroundColor = .clear
        
        return button
    }
    
    private func goToPage(_ index : Int, scrollingPages : Bool) {
        
        guard   (index != self.currentPage) &&
                    (self.pageList.startIndex...self.pageList.endIndex).contains(index) &&
                    (self.underlineView != nil) &&
                    (!self.pageList.isEmpty) &&
                    (self.isUnderlineViewFree)   else { return }
        
        self.isUnderlineViewFree = false
        
        let undelinePosition = self.frame.width / CGFloat(self.pageList.count) * CGFloat(index)
        
        if scrollingPages && self.bindingView != nil {
            self.bindingView!.scrollToPage(index)
        }
        
        UIView.animate(withDuration: self.animationTime) {
            self.underlineView!.frame.origin.x = undelinePosition
        } completion: { _ in
            self.isUnderlineViewFree = true
            self.currentPage = index
        }
    }
    
    @objc private func sectionTapped(_ sender: UIButton) {
        
        for (sectionIndex, section) in self.sections.enumerated() {
            if sender == section {
                self.goToPage(sectionIndex, scrollingPages: true)
            }
        }
    }
}
