//
//  ViewController.swift
//  Project10
//
//  Created by 野中淳 on 2022/12/05.
//

import UIKit

class ViewController: UIViewController {

    var collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        style()
        layout()
    }
    
    func setup(){
        //flowLayoutのインスタンス化
        let flowLayout = UICollectionViewFlowLayout()
        //cellのサイズ決定
        flowLayout.itemSize = CGSize(width: 140, height: 180)
        //cell毎のpadding
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //cell毎の縦の最小スペース
        flowLayout.minimumLineSpacing = 10
        //cell毎の横の最小スペース
        flowLayout.minimumInteritemSpacing = 0
        //CollectionViewのインスタンス化
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        //セルの登録
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "Person")
        //datasouceに設定
        collectionView.dataSource = self
    }
    
    func style(){
        //自分で制約を追加するのでオフにする
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout(){
        //collectionViewをViewに追加
        view.addSubview(collectionView)
        //画面一杯に追加
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
extension ViewController:UICollectionViewDataSource{
    //itemの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    //追加するセルの情報
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? CustomCell else{ fatalError() }
        cell.backgroundColor = .blue
        cell.name.text = "test"
        return cell
        
    }
    
    
    
    
}

#if canImport(SwiftUI) && DEBUG
//SwiftUIのViewでViewControllerをラップしている
import SwiftUI
struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    
    let viewController: ViewController
    
    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }
    
    // MARK: - UIViewControllerRepresentable
    //初期化メソッド
    func makeUIViewController(context: Context) -> ViewController {
        //ViewControllerを返す
        viewController
    }
    // SwiftUI側から更新がかかったときに呼ばれるメソッド
    func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {
        return
    }
}
#endif

#if canImport(SwiftUI) && DEBUG
import SwiftUI
//Previewで使うデバイスを複数出す時に便利
//これを使わなくても.previewDeviceを外せばSimulaterで選んだデバイスで実行される
//let deviceNames: [String] = [
//    "iPhone SE",
//    "iPhone 11 Pro Max",
//    "iPad Pro (11-inch)"
//]

@available(iOS 13.0, *)
//Previewを表示するためのプロトコル
//Previewで指定したViewをCanvasでプレビュー表示する
//XCodeが勝手に検知してくれる
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        //ForEach(deviceNames, id: \.self) { deviceName in
        UIViewControllerPreview {
            ViewController()
        }
        //.previewDevice(PreviewDevice(rawValue: deviceName))
        //        .previewDisplayName(deviceName)
        //    }
    }
}
#endif
