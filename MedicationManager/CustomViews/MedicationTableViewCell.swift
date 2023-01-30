//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by Dominique Strachan on 1/3/23.
//

import UIKit

protocol MedicationTableViewCellDelegate: AnyObject {
    func medicationWasTakenButtonTapped(medication: Medication, wasTaken: Bool)
}

class MedicationTableViewCell: UITableViewCell {
    
    //delegate property for protocol MedicationTableViewCellDelegate
    weak var delegate: MedicationTableViewCellDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var wasTakenButton: UIButton!
    
    private var medication: Medication?
    private var wasTakenToday: Bool = false
    
    @IBAction func wasTakenButtonTapped(_ sender: UIButton) {
        guard let medication = medication
        else { return }
        
        wasTakenToday.toggle()
        delegate?.medicationWasTakenButtonTapped(medication: medication, wasTaken: wasTakenToday)
    }
    
    //configure gets called when a cell is being configured to show in table view
    //parameter is medication being shown in cell
    func configure(with medication: Medication) {
        self.medication = medication
        //checks if medication was taken
        wasTakenToday = medication.wasTakenToday()
        
        nameLabel.text = medication.name
        timeLabel.text = DateFormatter.medicationTime.string(from: medication.timeOfDay ?? Date())
        let image = wasTakenToday ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        wasTakenButton.setImage(image, for: .normal)
    }

}
