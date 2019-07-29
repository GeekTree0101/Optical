//
//  HistoryShowController.swift
//  Optical_Example
//
//  Created by Hyeon su Ha on 28/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Optical

class HistoryShowController: UIViewController {
  
  @IBOutlet weak var dismissButton: UIButton!
  @IBOutlet weak var titleEditTextView: UITextField! {
    didSet {
      titleEditTextView.delegate = self
    }
  }
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var messageLabel: UILabel! {
    didSet {
      messageLabel.isHidden = true
    }
  }
  
  public var opticle: HistoryShowOpticle = .init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    opticle.watch().render({ [weak self] state in
      
      switch state.status {
      case .edited:
        self?.dismiss(animated: true, completion: nil)
        return
      default:
        break
      }
      
      self?.titleEditTextView.text = state.title
      
      if let errorMessage = state.message {
        self?.messageLabel.isHidden = false
        self?.messageLabel.text = errorMessage
      } else {
        self?.messageLabel.isHidden = true
      }
    })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    opticle.dispatch(.reload)
  }
  
  @IBAction func didTapDismiss(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didTapSubmit(_ sender: Any) {
    guard let text = titleEditTextView.text else { return }
    opticle.dispatch(.submit(text))
  }
}

extension HistoryShowController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    guard self.messageLabel.isHidden == false else { return true }
    self.messageLabel.isHidden = true
    return true
  }
}
