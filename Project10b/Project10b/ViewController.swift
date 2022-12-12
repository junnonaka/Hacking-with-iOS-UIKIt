//
//  ViewController.swift
//  Project10b
//
//  Created by 野中淳 on 2022/12/08.
//

import UIKit

class ViewController: UICollectionViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        // Do any additional setup after loading the view.
    }

    @objc func addNewPerson(){
        
        //if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
        //    picker.sourceType = .camera
            present(picker, animated: true)

        //}
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else{
            fatalError()
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathExtension(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.contentMode = .scaleToFill
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename person or Delete", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "OK", style: .default,handler: { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {return}
            person.name = newName
            self?.collectionView.reloadData()
        }))
        
        ac.addAction(UIAlertAction(title: "Delete", style: .default,handler: { ac in
            person.name = ""
            collectionView.reloadData()
        }))
        
        Thread.sleep(forTimeInterval: 0.5)
        present(ac, animated: true)
    }
}
extension ViewController{
    //Pickerで画像を選択したら返ってくる。infoで辞書型で返ってくる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //編集可能な画像として取得
        guard let image = info[.editedImage] as? UIImage else {return}
        
        //ファイルに保存するための一意の名前を取得
        let imageName = UUID().uuidString
        //Documentsディレクトリに保存するデータのファイル名を加えたパスを取得
        let imagePath = getDocumentsDirectory().appendingPathExtension(imageName)
        //jpegDataとして保存
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    //アプリの個人情報を保存できるDocumentsディレクトリのパスを取得する
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
