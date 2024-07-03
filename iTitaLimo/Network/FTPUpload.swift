//
//  FTPUpload.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 11/11/2020.
//

import Foundation
import CFNetwork
import Alamofire

public class FTPUpload {

    // DEV
    fileprivate let ftpBaseUrl: String = "118.200.137.124"
    fileprivate let directoryPath: String = ""
    fileprivate let username: String = "info121ftp"
    fileprivate let password: String = "6b604358f1a34a88a8506205f2d0e501"
    public static let CONST_PHOTO_URL: String = "http://info121.sytes.net/iops/images/limopics/";
   
    
    
    // LIVE
//    fileprivate let ftpBaseUrl: String = "97.74.89.233"
//    fileprivate let directoryPath: String = ""
//    fileprivate let username: String = "ipos"
//    fileprivate let password: String = "$$1posftp%%"
//    public static let CONST_PHOTO_URL: String =  "http://97.74.89.233/iops/images/limopics/";
   
   
//   public init(baseUrl: String, userName: String, password: String, directoryPath: String) {
//      self.ftpBaseUrl = baseUrl
//      self.username = userName
//      self.password = password
//      self.directoryPath = directoryPath
//   }
    
//    public init() {
//       self.ftpBaseUrl = baseUrl
//       self.username = userName
//       self.password = password
//       self.directoryPath = directoryPath
//    }
    
}


// MARK: - Steam Setup
extension FTPUpload {
    
    public static func getPhotoURL() -> String{
        return CONST_PHOTO_URL
    }
    
   private func setFtpUserName(for ftpWriteStream: CFWriteStream, userName: CFString) {
      let propertyKey = CFStreamPropertyKey(rawValue: kCFStreamPropertyFTPUserName)
      CFWriteStreamSetProperty(ftpWriteStream, propertyKey, userName)
   }
   
   private func setFtpPassword(for ftpWriteStream: CFWriteStream, password: CFString) {
      let propertyKey = CFStreamPropertyKey(rawValue: kCFStreamPropertyFTPPassword)
      CFWriteStreamSetProperty(ftpWriteStream, propertyKey, password)
   }
   
   fileprivate func ftpWriteStream(forFileName fileName: String) -> CFWriteStream? {
      let fullyQualifiedPath = "ftp://\(ftpBaseUrl)/\(directoryPath)/\(fileName)"
 //   let fullyQualifiedPath = "ftp://\(ftpBaseUrl)/\(fileName)"
      
      guard let ftpUrl = CFURLCreateWithString(kCFAllocatorDefault, fullyQualifiedPath as CFString, nil) else { return nil }
      let ftpStream = CFWriteStreamCreateWithFTPURL(kCFAllocatorDefault, ftpUrl)
      let ftpWriteStream = ftpStream.takeRetainedValue()
      setFtpUserName(for: ftpWriteStream, userName: username as CFString)
      setFtpPassword(for: ftpWriteStream, password: password as CFString)
      return ftpWriteStream
   }
    
    
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}





//extension FTPUpload {
//    public func send(data: Data, with fileName: String, success: @escaping ((Bool)->Void)) {
//
//
//
//
//
//        guard let ftpWriteStream = ftpWriteStream(forFileName: fileName) else {
//            success(false)
//            return
//        }
//
//        print(CFWriteStreamGetStatus(ftpWriteStream))
//
//        if CFWriteStreamOpen(ftpWriteStream) == false {
//            print("Could not open stream")
//            success(false)
//            return
//        }
//
//        let fileSize = data.count
//        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: fileSize)
//        data.copyBytes(to: buffer, count: fileSize)
//
//        defer {
//            CFWriteStreamClose(ftpWriteStream)
//            //buffer.deallocate(capacity: fileSize)
//        }
//
//        var offset: Int = 0
//        var dataToSendSize: Int = fileSize
//        var  result  : Bool = false
//
//        print(CFWriteStreamCanAcceptBytes(ftpWriteStream))
//
//
//
//        repeat {
//            let bytesWritten = CFWriteStreamWrite(ftpWriteStream, &buffer[offset], dataToSendSize)
//            if bytesWritten > 0 {
//                offset += bytesWritten.littleEndian
//                dataToSendSize -= bytesWritten
//                continue
//            } else if bytesWritten < 0 {
//                // ERROR
//                print("FTPUpload - ERROR")
//                result = false
//                break
//            } else if bytesWritten == 0 {
//                // SUCCESS
//                print("FTPUpload - Completed!!")
//                result = true
//                break
//            }
//        } while CFWriteStreamCanAcceptBytes(ftpWriteStream)
//
//        success(true)
//    }
//}


// MARK: - FTP Write
extension FTPUpload {
   public func send(data: Data, with fileName: String, success: @escaping ((Bool)->Void)) {

      guard let ftpWriteStream = ftpWriteStream(forFileName: fileName) else {
         success(false)
         return
      }

    //  print("CFWriteStreamOpen : " + String( CFWriteStreamOpen(ftpWriteStream)) )

      if (!CFWriteStreamOpen(ftpWriteStream)){
         print("Could not open stream")
         success(false)
         return
      }

      let fileSize = data.count
      let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: fileSize)
      data.copyBytes(to: buffer, count: fileSize)

      defer {
         CFWriteStreamClose(ftpWriteStream)
         //buffer.deallocate(capacity: fileSize)
      }

      var offset: Int = 0
      var dataToSendSize: Int = fileSize

      var shouldContinue = true

      var i = 0

    //   print()
       
      repeat {
         if (CFWriteStreamCanAcceptBytes(ftpWriteStream)) {
            let bytesWritten = CFWriteStreamWrite(ftpWriteStream, &buffer[offset], dataToSendSize)
            print("ftp bytes written: \(bytesWritten)")
            print("bytesWritten : \(bytesWritten)")
            print("dataToSendSize : \(dataToSendSize)")

            if bytesWritten > 0 {
               offset += bytesWritten.littleEndian
               dataToSendSize -= bytesWritten
               continue
            } else if bytesWritten < 0 {
               // ERROR
               print("FTPUpload - ERROR")
               shouldContinue = false
               break
            } else if bytesWritten == 0 {
               // SUCCESS
               print("FTPUpload - Completed!!")
               shouldContinue = false
               break
            }
         } else {
             usleep(100000)
             // print(".", separator: "", terminator: "")
            
             if(i>60){
                 shouldContinue = false
                 success(false)
                 
                 defer {
                   CFWriteStreamClose(ftpWriteStream)
                 }
                 return
             }else{
                 i+=1
            }

            print(i)
         }
      } while shouldContinue

      success(true)
   }
}

