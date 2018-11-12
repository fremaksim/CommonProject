//
//  MohistSMSVerificationCodeView.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit
import SnapKit

// Inspired by 'MQVerCodeInputView'

typealias MoCallback = (String) -> ()

private  let kAnimationKeyPath = "kOpacityAnimation"

open class MohistSMSVerificationCodeView: UIView {
    
    open var keyboardType: UIKeyboardType = .decimalPad {
        didSet {
            textView.keyboardType = keyboardType
        }
    }
    open var codeCount: Int = 6
    open var normalCellColor: UIColor = UIColor(red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 1.0)
    open var highlightCellColor: UIColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 62.0/255.0, alpha: 1)
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.tintColor = .clear
        textView.backgroundColor = .clear
        textView.textColor = .clear
        textView.delegate = self
        textView.keyboardType = .default
        return textView
    }()
    
    private lazy var cells: [UIView] = []
    
    private lazy var labels: [UILabel] = []
    
    private lazy var lines: [CAShapeLayer] = []
    
    private var containerView: UIView?
    
    var callback: MoCallback?
    
    
    //MARK: --- Life Cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        beginEdit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        verificationCodeViewWithCodeCount()
    }
    
    //MARK: --- Private Methods
    private func beginEdit(){
        textView.becomeFirstResponder()
    }
    
    private func endEdit(){
        textView.resignFirstResponder()
    }
    
    private func verificationCodeViewWithCodeCount(){
        
        guard codeCount > 0 else {return}
        
        if let container = containerView {
            container.removeFromSuperview()
        }
        if cells.count > 0  { cells.removeAll()  }
        if labels.count > 0 { labels.removeAll() }
        if lines.count > 0  { lines.removeAll()  }
        
        containerView = UIView()
        guard let containerView = containerView else { return }
        addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        containerView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let padding = (frame.width - CGFloat(codeCount) * frame.height) / CGFloat(codeCount - 1)
        
        let stackView = UIStackView()
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        var subStacks: [UIStackView] = []
        for i in 0..<codeCount {
            let subView = UIView()
            subView.backgroundColor = .white
            subView.cornerRadius = 4
            subView.borderWidth = 0.5
            subView.clipsToBounds = true
            subView.isUserInteractionEnabled = false
            
            let subStack = UIStackView(arrangedSubviews: [subView])
            subView.snp.makeConstraints { (make) in
                make.width.height.equalToSuperview()
                make.center.equalToSuperview()
            }
            subStacks.append(subStack)
            
            let subLabel = UILabel()
            subLabel.textAlignment = .center
            subLabel.font = UIFont.systemFont(ofSize: 38)
            subView.addSubview(subLabel)
            subLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            let path = UIBezierPath(rect: CGRect(x: (frame.height - 2) / 2, y: 5, width: 2, height: frame.height - 10))
            let line = CAShapeLayer()
            line.path = path.cgPath
            line.fillColor = highlightCellColor.cgColor
            subView.layer.addSublayer(line)
            if i == 0 {
                line.add(opacityAnimation(), forKey: kAnimationKeyPath)
                line.isHidden = false
                subView.borderColor = highlightCellColor
            }else {
                line.isHidden = true
                subView.borderColor = normalCellColor
            }
            cells.append(subView)
            labels.append(subLabel)
            lines.append(line)
            
        }
        stackView.addArrangedSubviews(subStacks)
        
    }
    
    private func opacityAnimation() -> CABasicAnimation {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue   = 0.0
        opacityAnimation.duration = 0.9
        opacityAnimation.repeatCount = Float.greatestFiniteMagnitude
        opacityAnimation.isRemovedOnCompletion = true
        opacityAnimation.fillMode = CAMediaTimingFillMode.forwards
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        return opacityAnimation
    }
    
    private func changeCellLayer(index: Int, isHiddenLine: Bool) {
        
        let cell = cells[index]
        cell.borderColor = isHiddenLine ? normalCellColor : highlightCellColor
        let line = lines[index]
        
        if isHiddenLine {
            line.removeAnimation(forKey: kAnimationKeyPath)
        }else {
            line.add(opacityAnimation(), forKey: kAnimationKeyPath)
        }
        line.isHidden = isHiddenLine
    }
    
}

extension MohistSMSVerificationCodeView: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        guard var text = textView.text else { return }
        text = text.replacingOccurrences(of: " ", with: "")
        if text.count > codeCount {
            // clip
            let startIndex = text.startIndex
            let endIndex   = text.index(text.startIndex, offsetBy: codeCount - 1)
            text = String(text[startIndex...endIndex])
            endEdit()
        }
        
        callback?(text)
        
        for i in 0..<cells.count {
            let label = labels[i]
            if i < text.count {
                changeCellLayer(index: i, isHiddenLine: true)
                label.text = String(text.charactersArray[i])
            }else {
                changeCellLayer(index: i, isHiddenLine: (i == text.count) ? false : true)
                if text.isEmpty || text.count == 0 { //textView text 为 nil
                    changeCellLayer(index: 0, isHiddenLine: false)
                }
                label.text = ""
            }
        }
    }
}
