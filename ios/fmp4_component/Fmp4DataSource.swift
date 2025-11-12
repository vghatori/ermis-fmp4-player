//
//  Fmp4DataSource.swift
//  fmp4_player
//
//  Created by Giáp Phan Văn on 4/11/25.
//

import AVFoundation

class Fmp4DataSource: NSObject, AVAssetResourceLoaderDelegate {
  private var dataBuffer = Data()
  private var totalBytesLoaded: Int = 0
  private var inputStream : FileHandle?
  private var InitContent : Bool = false
  private var count = 0
  init(inputStream : FileHandle) {
    self.inputStream = inputStream
  }
    
    
  func resourceLoader(_ resourceLoader: AVAssetResourceLoader,
                     shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
    count += 1
    print(count)
    if let _ = loadingRequest.contentInformationRequest {
        return handleContentInfoRequest(loadingRequest)
    } else if let _ = loadingRequest.dataRequest {
      return handleDataRequest(loadingRequest)
    } else {
      loadingRequest.finishLoading()
        return false
    }
  }
    
  func resourceLoader(_ resourceLoader: AVAssetResourceLoader,
                     didCancel loadingRequest: AVAssetResourceLoadingRequest) {
      print("load cancel")
  }
    
  // MARK: - Private Methods

    
  private func handleContentInfoRequest(_ loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
    guard let infoRequest = loadingRequest.contentInformationRequest, let dataRequest = loadingRequest.dataRequest else { return true }
 
      InitContent = true
      infoRequest.contentType = AVFileType.mp4.rawValue
      infoRequest.isByteRangeAccessSupported = true
    //infoRequest.contentLength = Int64.max
    print(loadingRequest.contentInformationRequest!)
    loadingRequest.finishLoading()
    return true
  }
    
  private func handleDataRequest(_ loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
      print("processing...")
      let dataRequest = loadingRequest.dataRequest!
      let requestOffset = dataRequest.requestedOffset
      let requestedLength = Int64(dataRequest.requestedLength)
      let currentOffset = dataRequest.currentOffset
    let data = inputStream?.availableData
      print("requestedOffset: \(requestOffset), requestedLength: \(requestedLength), currentOffset: \(currentOffset)")
      print(data!)
   // let responseData = data!.subdata(in: Data.Index(requestOffset)..<Data.Index((requestOffset + requestedLength)))
      dataRequest.respond(with: data!)
    loadingRequest.finishLoading()
      return true
  }
}
