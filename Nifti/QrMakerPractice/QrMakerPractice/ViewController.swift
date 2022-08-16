//
//  ViewController.swift
//  QrMakerPractice
//
//  Created by BoMin on 2022/08/14.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let qrReaderView: QrReaderView = {
        let readerView = QrReaderView(frame: CGRect(x: 0, y: 0, width: 314, height: 314))
        
//        readerView.backgroundColor = .white
        readerView.layer.masksToBounds = true
        readerView.layer.cornerRadius = 15
        
        return readerView
    }()
    
    let readButton: UIButton = {
        let read = UIButton()
        
        read.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        read.backgroundColor = UIColor.blue
        read.setTitle("Scan", for: .normal)
        read.setTitle(("Stop"), for: .selected)
        read.addTarget(self, action: #selector(scanButtonAction(_:)), for: .touchUpInside)
        read.layer.masksToBounds = true
        read.layer.cornerRadius = 15
        
        return read
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.121, green: 0.121, blue: 0.121, alpha: 1)
        
        self.view.addSubview(qrReaderView)
        
        self.qrReaderView.delegate = self
        
        self.view.addSubview(readButton)
        
        setAutoLayouts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !self.qrReaderView.isRunning {
            self.qrReaderView.stop(isButtonTap: false)
        }
    }
    
    @objc func scanButtonAction(_ sender: UIButton) {
        if self.qrReaderView.isRunning {
            self.qrReaderView.stop(isButtonTap: true)
        } else {
            self.qrReaderView.start()
        }

        sender.isSelected = self.qrReaderView.isRunning
    }
    
    func setAutoLayouts() {
        qrReaderViewAutoLayout()
        readButtonAutoLayout()
    }
}

extension ViewController: QrReaderViewDelegate {
    func qrReaderComplete(status: QrReaderStatus) {

        var title = ""
        var message = ""
        switch status {
        case let .success(code):
            guard let code = code else {
                title = "에러"
                message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
                break
            }

            title = "알림"
            message = "인식성공\n\(code)"
        case .fail:
            title = "에러"
            message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
        case let .stop(isButtonTap):
            if isButtonTap {
                title = "알림"
                message = "바코드 읽기를 멈추었습니다."
                self.readButton.isSelected = qrReaderView.isRunning
            } else {
                self.readButton.isSelected = qrReaderView.isRunning
                return
            }
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)

        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController {
    func qrReaderViewAutoLayout() {
        qrReaderView.translatesAutoresizingMaskIntoConstraints = false
        qrReaderView.heightAnchor.constraint(equalToConstant: 314).isActive = true
        qrReaderView.widthAnchor.constraint(equalToConstant: 314).isActive = true
        qrReaderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        qrReaderView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -10).isActive = true
    }
    func readButtonAutoLayout() {
        readButton.translatesAutoresizingMaskIntoConstraints = false
        readButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        readButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        readButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        readButton.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 20).isActive = true
    }
}
