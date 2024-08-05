//
//  ViewController.swift
//  iOS Assignment
//
//  Created by Mohan Soni on 03/08/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var reelsData: ReelsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let reelsData = self.loadJson(filename: "Reels") {
            self.reelsData = reelsData
            self.tableView.reloadData()
        }
    }
    
    private func loadJson(filename fileName: String) -> ReelsData? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ReelsData.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }

}

// MARK: - UITableviewDelegate and UITableviewDataSource Methods.

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let dataCount = reelsData?.reels.count ?? 0
        if dataCount == 0 {
            self.tableView.setEmptyMessage("No Data Available")
        } else {
            self.tableView.restore()
        }
        return dataCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyCell = tableView.dequeueReusableCell(for: indexPath)
        cell.tag = indexPath.row
        cell.dataArray = reelsData?.reels[indexPath.row].arr ?? []
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = (cell as? MyCell) else { return }
        let visibleCells = tableView.visibleCells
        let minIndex = visibleCells.startIndex
        if tableView.visibleCells.firstIndex(of: cell) == minIndex {
            videoCell.currentPlayerIndex = 0
            videoCell.playfirstVideo = true
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = cell as? MyCell else { return }

        [videoCell.playerAV1, videoCell.playerAV2, videoCell.playerAV3, videoCell.playerAV4].forEach { player in
            player.pause()
        }
      
    }
}

// MARK: - Download Image from URL Method.
extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL?) {
        if let url {
            getData(from: url) { data, response, error in
                var statusCode = 0
                if let httpResponse = response as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }
                
                guard let data = data, error == nil, statusCode == 200 else {
                    DispatchQueue.main.async() {
                        self.image = UIImage(named: "noPreview")
                    }
                    return
                }
                DispatchQueue.main.async() {
                    self.image = UIImage(data: data)
                }
            }
        }else {
            self.image = UIImage(named: "noPreview")
        }
    }
}
