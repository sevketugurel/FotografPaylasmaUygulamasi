//
//  FeedViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Şevket Uğurel on 2.06.2023.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var postDizisi = [Post]() // aşağıdakileri bu sınıf içine aldık
    
    /*
    var userEmail = [String]()
    var yorumDizisi = [String]()
    var gorselDizisi = [String]()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseVeriAl()
    }
    
    func firebaseVeriAl(){
        let firestoreDataBase = Firestore.firestore()
        
        firestoreDataBase.collection("Post").order(by: "tarih", descending: true)//burada en yeni gönderi en üstte çıkması için
            .addSnapshotListener { snapshot, error in
            
            if error != nil{
                print(error?.localizedDescription ?? "Bir hata var, Tekrar Deneyiniz...")
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    // her görsel eklediğimizde eski görselleri tekrar getirmemesi için
                    //self.userEmail.removeAll(keepingCapacity: false)
                    //self.yorumDizisi.removeAll(keepingCapacity: false)
                    //self.gorselDizisi.removeAll(keepingCapacity: false)
                    self.postDizisi.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{ // firebasedeki post içimndeki bütün dökümanları alıyoruz
                        
                        // let documentID = document.documentID // documentin İD'sini alabiliriz
                        
                        //burada eğer String dizisine döndürebiliyorsak değerleri diziye atayacağız
                        if let gorselUrl = document.get("gorselurl") as? String{
                            
                            if let yorum = document.get("yorum") as? String{
                                
                                if let email = document.get("email") as? String{
                                    
                                    let post = Post(email: email, yorum: yorum, gorselUrl: gorselUrl)
                                    self.postDizisi.append(post)
                                }
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //burada "Cell" kısmı FeedCell identifere koyduğumuz isim olmak zorunda yoksa çalışmaz.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! FeedCell
        cell.emailText.text = "Kullanıcı: "+postDizisi[indexPath.row].email
        cell.yorumText.text = postDizisi[indexPath.row].yorum
        cell.postImageView.sd_setImage(with: URL(string: self.postDizisi[indexPath.row].gorselUrl))
        return cell
    }

}
