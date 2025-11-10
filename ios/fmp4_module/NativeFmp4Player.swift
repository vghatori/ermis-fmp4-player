//
//  File.swift
//  fmp4_player
//
//  Created by Giáp Phan Văn on 24/10/25.
//

import Foundation
import MobileVLCKit
import AVFoundation

@objcMembers
class NativeFmp4Player: NSObject {
  private var url : URL = URL(string: "wss://streaming.ermis.network/stream-gate/software/Ermis-streaming/c6bb6751-8595-495a-ae9c-7d21b79ef834")!
  private var socketSession : URLSession?
  private var socketTask : URLSessionWebSocketTask?
  private static var player : AVPlayer?
  private var fmp4Delegate : Fmp4DataSource?
  private let pipe = Pipe()
  private var outputStream : FileHandle!
  private var inputStream : FileHandle!
  private var firstInit : Bool = false
  
  override init() {
    self.socketSession = nil
    self.socketTask = nil
    inputStream = pipe.fileHandleForReading
    outputStream = pipe.fileHandleForWriting
    super.init()
  }
  
  private func setupPlayer() {
    
  }
  
  
  
  func startStreaming() {
    var request = URLRequest(url: url)
    request.addValue("fmp4", forHTTPHeaderField: "Sec-WebSocket-Protocol")
    self.socketSession = URLSession(configuration: .default)
    self.socketTask = socketSession?.webSocketTask(with: request)
    readMessage()
   // let Url = URL("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
    let asset = AVURLAsset(url: URL("fmp4://localhost/stream")!)
    fmp4Delegate = Fmp4DataSource(inputStream: inputStream)
    let loadqueue = DispatchQueue(label: "delegate")
    asset.resourceLoader.setDelegate(fmp4Delegate, queue: loadqueue)
    let playerItem = AVPlayerItem(asset: asset)
    //checkAssetMetadata(playerItem: playerItem)
    
    NativeFmp4Player.player = AVPlayer(playerItem: playerItem)
    Fmp4AVPlayerView.AttachPlayerToLayer(avplayer: NativeFmp4Player.player!)
    NativeFmp4Player.player?.play()
    
    
   
  }

  private func checkAssetMetadata(playerItem: AVPlayerItem) {
      print("\n=== 🔍 CHECK FTYP/MOOV PARSING ===")
      
      let tracks = playerItem.tracks

      
      if tracks.isEmpty {
          print("❌ Không có tracks → FTYP/MOOV CHƯA ĐƯỢC PARSE!")
          
          // Thử check lại sau 0.5s
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
              self?.checkAssetMetadata(playerItem: playerItem)
          }
          return
      }
      
      print("✅ Có \(tracks.count) track(s) → FTYP và MOOV đã parse thành công!")
      
      for (index, track) in tracks.enumerated() {
          if let assetTrack = track.assetTrack {
            
              print("\nTrack \(index):")
              print("  Type: \(assetTrack.mediaType.rawValue)")
              print("  ID: \(assetTrack.trackID)")
              
              if assetTrack.mediaType == .video {
                  print("  Resolution: \(Int(assetTrack.naturalSize.width))x\(Int(assetTrack.naturalSize.height))")
                  print("  ✅ FTYP và MOOV đã được parse!")
              }
          }
      }
  }
  
  func stopStreaming() {
    socketTask?.cancel(with: .goingAway, reason: nil)
  }
  
  
  private func readMessage() {
    
    socketTask?.resume();
    socketTask?.receive { result in
      switch result {
        case .failure(let error): print("fail : \(error)")
        case .success(let message):
            switch message {
              case .data(let data):
                guard !data.isEmpty else {
                  return
                }
              //self.sendFrameToAVPlayer(data.dropFirst())
              
              self.sendFrameToAVPlayer(data.dropFirst())
            case .string(let config):
                guard !config.isEmpty else {
                  return
                }
              @unknown default:
                break
            }
        self.readMessage()
      }
    }
  }
  private func sendFrameToAVPlayer(_ data : Data) {
    try? outputStream.write(contentsOf: data)
  }

}

