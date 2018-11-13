//
//  ScanQRCodeLoginViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

import QRCodeReader //https://github.com/yannickl/QRCodeReader.swift 可自定义显示模式
import AVFoundation

import EFQRCode

class ScanQRCodeLoginViewController: UIViewController {
    
    private lazy var scanButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.scan_qrcode_icon(), for: .normal)
        button.addTarget(self, action: #selector(scanQrCode), for: .touchUpInside)
        return button
    }()
    
    private lazy var generateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.generate(), for: .normal)
        button.addTarget(self, action: #selector(generateQrCode), for: .touchUpInside)
        return button
    }()
    
    private lazy var qrCodeImageView: UIImageView = {
        let qrCodeImageView = UIImageView()
        return qrCodeImageView
    }()
    
    private lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    //MARK: --- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "扫码登录"
        
        view.addSubview(scanButton)
        scanButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 64, height: 64))
            make.centerX.equalToSuperview()
            make.top.equalTo(80)
        }
        
        view.addSubview(generateButton)
        generateButton.snp.makeConstraints { (make) in
            make.size.equalTo(scanButton)
            make.centerX.equalToSuperview()
            make.top.equalTo(scanButton.snp.bottom).offset(20)
        }
        
        view.addSubview(qrCodeImageView)
        qrCodeImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.centerX.equalToSuperview()
            make.top.equalTo(generateButton.snp.bottom).offset(20)
        }
        
    }
    
    //MARK: --- Event Response
    @objc private func scanQrCode(){
        
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            guard let result = result else { return }
            print(result)
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    @objc private func generateQrCode(){
        let alert = UIAlertController(title: "二维码生成", message: nil, defaultActionButtonTitle: "取消", tintColor: UIColor.red)
        alert.addTextField { (text) in
            text.placeholder = "输入字符串生成二维码"
        }
        let action = UIAlertAction(title: "确定", style: .default) {[weak self] (_) in
            if let textfield =  alert.textFields?.first, let text = textfield.text {
                self?.produceQRCode(str: text)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    private func produceQRCode(str: String) {
        if let image = EFQRCode.generate(content: str) {
            qrCodeImageView.image = UIImage(cgImage: image)
        }
        
    }
    
}


// MARK: - QRCodeReaderViewController Delegate Methods

extension ScanQRCodeLoginViewController: QRCodeReaderViewControllerDelegate{
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        let cameraName = newCaptureDevice.device.localizedName
        print("Switching capturing to: \(cameraName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}
