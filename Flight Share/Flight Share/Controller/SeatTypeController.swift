//
//  SeatTypeController.swift
//  Flight Share
//
//  Created by macOS Mojave on 5/7/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import UIKit

class SeatTypeController: UIViewController {
    @IBOutlet weak var adultsLabel: UILabel!
    @IBOutlet weak var childrenLabel: UILabel!
    @IBOutlet weak var infantsLabel: UILabel!
    
    
    var seatType = ""
    var Children = 0
    var Adults = 0
    var infants = 0
    var travellers = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Seat Type & Travellers"
        
        // select multiple option
        // outlet.isMultipleSelectionEnabled = true
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    @IBAction func radioBtn(_ sender: DLRadioButton) {
        //print("work")
        if sender.tag == 1{
            seatType = "Economy"
            //print(seatType)
        }
        else if sender.tag == 2{
            seatType = "Business"
            //print(seatType)
        }
        else{
            seatType = "First"
            //print(seatType)
        }
    }

    @IBAction func TravellersBtnAction(_ sender: UIButton) {
        if sender.tag == 1{
            if Adults == 0{
                return
            }
            else{
                Adults -= 1
                adultsLabel.text =  String(Adults)
            }
        }
        else if sender.tag == 2{
            Adults += 1
            adultsLabel.text = String(Adults)
        }
        else if sender.tag == 3{
            if Children == 0{
                return
            }
            else{
                Children -= 1
                childrenLabel.text =  String(Children)
            }
        }
        else if sender.tag == 4{
            Children += 1
            childrenLabel.text = String(Children)
        }
        
        else if sender.tag == 5{
            if infants == 0{
                return
            }
            else{
                infants -= 1
                infantsLabel.text =  String(infants)
            }
        }
        else {
            infants += 1
            infantsLabel.text = String(infants)
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        print("Cancel Button Clicked")
        
    }
    
    @IBAction func DoneBtnAction(_ sender: UIButton) {
        print("There are \(Adults) Adults,\(Children) Childrens and \(infants) Infants.Total \(Adults+Children+infants) Travelers.")
        print("Preferred class: \(seatType)")
        travellers = "\(Adults+Children+infants) Passengers"
        //performSegue(withIdentifier: "seatTypeSegue", sender: self)
        let userDefault = UserDefaults()
        userDefault.set(seatType, forKey: "SeatType")
        userDefault.set(travellers, forKey: "Traveller")
        userDefault.set(Adults, forKey: "adult")
        userDefault.set(Children, forKey: "child")
        userDefault.set(infants, forKey: "Infant")
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let sendData = segue.destination as? ViewController
//        sendData!.adult = Adults
//        sendData!.child = Children
//        sendData!.infant = infants
//        sendData!.seatType = seatType
//        //sendData!.seatTypeLbl.text = seat
//        //sendData!.travellerLbl.text = String()
//    }
    
}
