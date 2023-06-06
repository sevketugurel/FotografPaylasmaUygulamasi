//
//  SettingsViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Şevket Uğurel on 2.06.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func cikisYapTiklandi(_ sender: Any) {
        do{
            try Auth.auth().signOut() // denemeyi burada yapıyor. try'ı nereyi deniyorsak oraya koymamız gerekiyor.
            performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("HATA!")
        }
    }

}
