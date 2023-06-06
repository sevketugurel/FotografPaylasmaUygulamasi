//
//  UploadViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Şevket Uğurel on 2.06.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var yorumTextField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true // kullanıcının hareketini açtık
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func gorselSec() {
        let pickerController = UIImagePickerController()
        pickerController.delegate=self
        pickerController.sourceType = .photoLibrary //pickerı nereden aldığımı seçtik
        present(pickerController, animated: true)
        
    }
    
    // seçildikten sonra yapılacak şeyler.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
        
    }
    
    @IBAction func uploadTiklandi(_ sender: Any) {
       
        let storage = Storage.storage()
        let strogeReferance = storage.reference()
        
        let mediFolder = strogeReferance.child("media") // burada fireBase altına bir dosya yerleştiriyoruz bunu child ile devam ettirebiliyoruz.
        
        let uuid = UUID().uuidString // üst üste yazmasını engellemek için id tanımladık
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let imageReferance = mediFolder.child("\(uuid).jpg")
            
            imageReferance.putData(data,metadata: nil) {( storagemetadata, error) in
                if  error != nil{
                    hataMesajıGoster(title: "HATA!", message: error?.localizedDescription ?? "Hata Aldınız tekrar deneyiniz!")
                }else{ // burada url alabiliyor muyuz ?
                    imageReferance.downloadURL { [self] (url, error) in
                        if error == nil{
                            let imageurl = url?.absoluteString
                            
                            //opsiyonellikten kurtardık, direkt olarak String oldu
                            if let imageurl = imageurl{
                                
                                let firestoreDatabase = Firestore.firestore()
                                // firebasede collactiona eklemek için field-value oluşturuyoruz
                                let firestorePost = ["gorselurl" : imageurl,"yorum" : self.yorumTextField.text!,"email" : Auth.auth().currentUser!.email ,"tarih" : FieldValue.serverTimestamp()] as [String : Any]
                                
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) { error in
                                    if error != nil{
                                        hataMesajıGoster(title: "HATA!", message: error?.localizedDescription ?? "Hata Aldınız,Tekrar Deneyiniz...")
                                    }else{ //hata almadığımızda yapılacaklar
                                        self.imageView.image = UIImage(named: "gorselSec") // burada görsel seçme ekranını eski haline getiriyoruz.
                                        self.yorumTextField.text = ""
                                        self.tabBarController?.selectedIndex = 0 // Burada upload da olan arayüzü feede geçiriyoruz otomatik olarak.
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }
            }
            
        }
        func hataMesajıGoster(title:String,message:String){
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
        
        
        
    }
    
    

}
