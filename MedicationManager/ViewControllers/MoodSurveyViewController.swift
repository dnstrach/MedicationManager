//
//  MoodSurveyViewController.swift
//  MedicationManager
//
//  Created by Dominique Strachan on 1/5/23.
//

import UIKit

protocol MoodSurveyViewControllerDelegate: AnyObject {
    func moodButtonTapped(with emoji: String)
}

class MoodSurveyViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reminderFired),
                                               name: NSNotification.Name(Strings.medicationReminderReceived),
                                               object: nil)
    }
    
    weak var delegate: MoodSurveyViewControllerDelegate?

    @IBAction func xButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emojiTapped(_ sender: UIButton) {
        guard let emoji = sender.titleLabel?.text
        else { return }
        
        delegate?.moodButtonTapped(with: emoji)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func reminderFired() {
        //print("\(#file) received the MEMO!")
        view.backgroundColor = .systemPurple
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = .systemBackground
        }
    }
}
