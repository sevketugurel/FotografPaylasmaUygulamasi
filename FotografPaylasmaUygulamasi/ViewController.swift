//
//  ViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Şevket Uğurel on 2.06.2023.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sifreTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func GirisYapTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != ""{
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextField.text!) { authDataResult, error in
                if error != nil{
                    self.hataMesaji(titleInput: "HATA!", messageInput: error?.localizedDescription ?? "hata Aldınız, Tekrar Deneyiniz!")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
        
        }else{
            self.hataMesaji(titleInput: "HATA!", messageInput: "Email ve Parola giriniz!")
        }
        
    }
    
    @IBAction func KaydolTiklandi(_ sender: Any) {
        if emailTextField.text != "" && sifreTextField.text != ""{
            //kayıt olma işlmeleri
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult, error in
                if error != nil{
                    self.hataMesaji(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata aldınız, Tekrar deneyiniz!" )
                    // Buradaki ?? -> eğer error?.LocalizedError kısmı çalışmazsa bunu göster manasına geliyor emin olmadığımızda kullanabiliriz
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else{
            hataMesaji(titleInput: "Hata!", messageInput: "Kullanıcı Adı ve Paralo Giriniz!")
        }
        
    }
    func hataMesaji(titleInput:String,messageInput:String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert) // alert içeriğini hazırladık
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)// Cevap aksiyonu oluşturduk
        alert.addAction(okButton) // alertin içine aksiyonu verdik("OK")
        self.present(alert, animated: true) // present burada geçici ekran görevi görüyor yani pencere çıkıyor ve alaram veriyor gibi
    }

}

