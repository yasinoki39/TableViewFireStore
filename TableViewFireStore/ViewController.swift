//
//  ViewController.swift
//  TableViewFireStore
//
//  Created by SHINGO YANAGIDA on 2022/04/20.
//

import UIKit
import Firebase

class ViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var setNameTextField: UITextField!
    @IBOutlet weak var setAgeTextField: UITextField!
    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var addAgeTextField: UITextField!
    
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var getButton: UIButton!
    
        
    let db = Firestore.firestore()
    var queriedDataArray = [String()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        addButton.layer.cornerRadius = 15
        setButton.layer.cornerRadius = 15
        getButton.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
        
        setNameTextField.text = "a"
        setAgeTextField.text = "21"
        
        addNameTextField.text = "b"
        addAgeTextField.text = "40"
    }
    
    @IBAction func set(_ sender: Any) {
        guard let name = setNameTextField.text, let age = setAgeTextField.text else { return }
        db.collection("users").document("test4").setData([
            "name": name,
            "age": age,
        ]) { error in
            if let error = error {
                print("ドキュメントの書き込みに失敗しました:", error)
            } else {
                print("ドキュメントの書き込みに成功しました")
            }
        }
    }
    
    @IBAction func add(_ sender: Any) {
        guard let name = addNameTextField.text, let age = addAgeTextField.text else { return }
        
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data:[
            "name": name,
            "age": age,
        ]) { error in
            if let error = error {
                print("ドキュメントの追加に失敗しました:", error)
            } else {
                print("ドキュメントの追加に成功しました:", ref?.documentID as Any)
            }
        }
    }
    
    @IBAction func get(_ sender: Any) {
        queriedDataArray = []
        db.collection("users").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("ドキュメントの取得に失敗しました:", error)
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let name = data["name"] as? String, let age = data["age"] as? String else {
                        return
                    }
                    let nameAndAge = name + "　" + age + "歳"
                    self.queriedDataArray.append(nameAndAge)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queriedDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = queriedDataArray[indexPath.row]
        return cell
    }
}

