//
//  ViewController.swift
//  Flo
//
//  Created by 신의연 on 2020/09/29.
//

import UIKit

class SplashViewController: UIViewController {
    
    var timer = Timer()
    var imageData: Data?
    var mp3Data: Data?
    
    override func viewDidLoad() {
        startTime()
        getMusicJsonInfo()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /* 애니메이션 구현 할지 말지 결정
     info.plist에서 진입 구간 설정
     */
    
    private func startTime() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(exitSplash), userInfo: nil, repeats: false)
        
    }
    private func getMusicJsonInfo() {
        guard let url = URL(string: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json") else {
            fatalError("Invalid URL")
        }
        DispatchQueue.global().async {
            let session = URLSession.shared
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    fatalError("Invalid Data")
                }
                
                let decoder = JSONDecoder()
                do {
                    let p = try decoder.decode(MusicInfo.self, from: data)
                    playList.append(p)
                    
                    guard let imageURL = URL(string: playList[0].image) else { fatalError("Invalid imageURL") }
                    guard let mp3URL = URL(string: playList[0].file) else { fatalError("Invalid mp3File") }
                    self.imageData = try Data(contentsOf: imageURL)
                    self.mp3Data = try Data(contentsOf: mp3URL)
                    
                } catch {
                    print("decoding error")
                }
            }
            task.resume()
        }
        
    }
    @objc func exitSplash() {
        let MainVC = UIStoryboard(name: "MusicPlayerSB", bundle: nil).instantiateViewController(withIdentifier: "MusicPlayerSB") as! MusicPlayerViewController
        MainVC.modalPresentationStyle = .fullScreen
        if let image = imageData, let mp3File = mp3Data {
            MainVC.albumCover.image = UIImage(data: image)
            MainVC.mp3Data = mp3File
        }
        self.present(MainVC, animated: false, completion: nil)
    }
}

