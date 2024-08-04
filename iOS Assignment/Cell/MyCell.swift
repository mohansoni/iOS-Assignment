//
//  MyCell.swift
//  iOS Assignment
//
//  Created by Mohan Soni on 03/08/24.
//

import UIKit
import AVFoundation

class MyCell: UITableViewCell, ReusableView, NibLoadableView {
    
    @IBOutlet weak var thumbnailImage1: UIImageView!
    @IBOutlet weak var player1: PlayerView!
    
    @IBOutlet weak var thumbnailImage2: UIImageView!
    @IBOutlet weak var player2: PlayerView!
    
    @IBOutlet weak var thumbnailImage3: UIImageView!
    @IBOutlet weak var player3: PlayerView!
    
    @IBOutlet weak var thumbnailImage4: UIImageView!
    @IBOutlet weak var player4: PlayerView!
    
    var currentPlayerIndex = 0 {
        didSet {
            [self.player2, self.player3, self.player4].forEach { (player) in
                player?.player?.pause()
            }
            NotificationCenter.default.removeObserver(self)
            
            self.thumbnailImage1.isHidden = true
            self.player1.player?.seek(to: .zero)
            self.player1.player?.play()
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player1.player?.currentItem)
        }
    }
    
    var dataArray: [Arr]? {
        didSet {
            let image1 = dataArray?[0].thumbnail ?? ""
            let video1 = dataArray?[0].video ?? ""
            let id1 = 0
            
            let image2 = dataArray?[1].thumbnail ?? ""
            let video2 = dataArray?[1].video ?? ""
            let id2 = 1
            
            let image3 = dataArray?[2].thumbnail ?? ""
            let video3 = dataArray?[2].video ?? ""
            let id3 = 2
            
            let image4 = dataArray?[3].thumbnail ?? ""
            let video4 = dataArray?[3].video ?? ""
            let id4 = 3
            
            self.loadData(imageURLStr: image1, videoURLStr: video1, imageView: thumbnailImage1, player: player1, id: id1)
            self.loadData(imageURLStr: image2, videoURLStr: video2, imageView: thumbnailImage2, player: player2, id: id2)
            self.loadData(imageURLStr: image3, videoURLStr: video3, imageView: thumbnailImage3, player: player3, id: id3)
            self.loadData(imageURLStr: image4, videoURLStr: video4, imageView: thumbnailImage4, player: player4, id: id4)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension MyCell {
    
    private func loadData(imageURLStr: String, videoURLStr: String, imageView: UIImageView, player: PlayerView, id: Int) {
        let imageURL = URL(string: imageURLStr)
        
        imageView.downloadImage(from: imageURL ?? URL(string: ""))
        
        let url = URL(string: videoURLStr)
        if let url {
            
            let avPlayer = AVPlayer(url: url)
            let endTime = CMTimeMakeWithSeconds(6, preferredTimescale: 600)
            avPlayer.currentItem?.forwardPlaybackEndTime = endTime
          
            player.player = avPlayer
            if (id == 0) {
              //  player.player?.play()
                NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.player?.currentItem)
                
//                let previewTime = CMTime(seconds: 6, preferredTimescale: CMTimeScale(60))
//                let timeValue = NSValue(time: previewTime)
//                let boundaryTime = avPlayer.addBoundaryTimeObserverForTimes([ timeValue ], queue: <#dispatch_queue_t?#>, usingBlock: {[weak self] () -> Void in
//                  myPlayer.rate = 0
//                  myPlayer.pause()
//                  self?.playerDidFinishPlaying()
//                })
            }
            player.player?.rate = 2.0
            
            
            imageView.isHidden = false
            
             self.setObserverToPlayer(player: player.player, imageView: imageView)
        }
    }
    
    private func setObserverToPlayer(player: AVPlayer?, imageView: UIImageView) {
        if (imageView.isHidden == false) {
            let interval = CMTime(seconds: 0.3, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            let _ = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsed in
                print("TESTTTT")
                imageView.isHidden = true
            })
        }
    }
    
    @objc private func videoDidEnded() {
        print("CURRNET:", currentPlayerIndex)
        print("VIDEOENDED")
        
        NotificationCenter.default.removeObserver(self)
        
        switch currentPlayerIndex {
        case 0:
            self.player1.player?.pause()
            self.player1.player?.seek(to: .zero)
            self.thumbnailImage1.isHidden = false
            
            self.player2.player?.play()
            
            currentPlayerIndex += 1
            
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player2.player?.currentItem)
            break
        case 1:
            self.player2.player?.pause()
            self.player2.player?.seek(to: .zero)
            self.thumbnailImage2.isHidden = false
            
            self.player3.player?.play()
            currentPlayerIndex += 1
            
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player3.player?.currentItem)
            break
        case 2:
            self.player3.player?.pause()
            self.player3.player?.seek(to: .zero)
            self.thumbnailImage3.isHidden = false
            
            self.player4.player?.play()
            currentPlayerIndex += 1
            
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player4.player?.currentItem)
            break
        case 3:
            self.player4.player?.play()
            break
        default:
            self.thumbnailImage4.isHidden = false
            self.player4.player?.seek(to: .zero)
            self.player4.player?.pause()
            
            break
        }
        //  playerController.dismiss(animated: true, completion: nil)
        //
    }
}
