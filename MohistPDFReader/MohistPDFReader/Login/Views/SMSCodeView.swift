//
//  SMSCodeView.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit


class SMSCodeView: UIView {
    
    // Propeties
    var cellCount: Int = 6
    
    private let BaseTag = 2018
    
    private(set) var cells: [SMSCodeCell] = []
    
    private(set) var stackView: UIStackView!
    
    //MARK: --- Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for i in 0..<cellCount {
            let cell = SMSCodeCell()
            cell.tag = BaseTag + i
            cell.textField.tag = CodeTextField.baseTag + i
            cell.textField.delegate = self
//            cell.textField.addObserver(self, forKeyPath: "text", options: [.new,.old,.initial], context: nil)
            cells.append(cell)
        }
        stackView = UIStackView(arrangedSubviews: cells, axis: .horizontal, spacing: 0, alignment: .center, distribution: .fillEqually)
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches)
//        let index =  indexOfCell(touches: touches)
        
    }
    
    deinit {
        
//        for cell in cells {
//            self.removeObserver(cell.textField, forKeyPath: "text")
//        }
        
    }
    
    //MARK: --- Help Methos
    private func indexOfCell(touches: Set<UITouch>) -> Int {
        let point = touches.first?.location(in: nil)
        if let po = point {
            let newPoint = self.convert(po, to: self)
            
            for cell in cells {
                if cell.frame.contains(newPoint) {
                    print(newPoint)
                }
            }
        }
        
        return 0
    }
    
    
    
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if object is CodeTextField {
//            
//        }else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//        }
//    }
    
    
    //MARK: --- Private Methods
    //    private func isFirstCell() -> Bool{
    //        let views = cells.filter{ $0.tag == CodeTextField.baseTag }
    //    }
    
    
}

extension SMSCodeView: UITextFieldDelegate {
    
    
    
}


class SMSCodeCell: UIView {
    
    var space: CGFloat = 2
    
    var canBeFirstResponder: Bool = false
    
    private lazy var spacePrefix: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var textField: CodeTextField = CodeTextField()
    
    private  lazy var spaceSubfix: UIView = {
        let view = UIView()
        return view
    }()
    
    private  lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [spacePrefix,textField,spaceSubfix])
        stack.axis = .horizontal
        return stack
    }()
    
    // 控制 textfield 能否成为第一响应者
    private(set) lazy var control: UIControl = {
        let ctr = UIControl()
        ctr.alpha = 0.0
        return ctr
    }()
    
    //MARK: --- Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        spacePrefix.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(space)
        }
        spaceSubfix.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(space)
        }
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(spacePrefix.snp.right)
            make.right.equalTo(spaceSubfix.snp.left)
            make.top.equalTo(0)
            make.bottom.equalTo(spaceSubfix.snp.top).offset(-2)
        }
        
        addSubview(control)
        control.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: --- Public
    
    func indexOfCell() -> Int {
        return textField.tag - CodeTextField.baseTag
    }
    
    func isBeginCell() -> Bool {
        return indexOfCell() == 0
    }
    
    func isEndCell(of capacity: Int) -> Bool {
        return indexOfCell() == (capacity - 1)
    }
    //后一个
    func nextCell(of capacity: Int) -> SMSCodeCell? {
        if indexOfCell() < (capacity - 1) {
            return  viewWithTag(textField.tag + 1)?.superview as? SMSCodeCell
        }
        return nil
    }
    
    // 前一个
    func lastCell() -> SMSCodeCell? {
        if isBeginCell() { return nil }
        return viewWithTag(textField.tag - 1)?.superview as? SMSCodeCell
    }
    
}

class CodeTextField: UITextField {
    
    static let baseTag: Int = 10086
    
    var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor  = UIColor.gray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tag = CodeTextField.baseTag
        
        tintColor = UIColor.green.withAlphaComponent(0.6)
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 18)
        keyboardType = .decimalPad
        
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(0.5)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touches ==== tag: (\(self.tag))")
        super.touchesBegan(touches, with: event)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
