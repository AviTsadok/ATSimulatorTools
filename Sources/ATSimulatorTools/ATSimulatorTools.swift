import Foundation
import SQLite
import os

public enum ATDevicePermission : String {
    case reminders      = "kTCCServiceReminders"
    case addressBook    = "kTCCServiceAddressBook"
    case photos         = "kTCCServicePhotos"
    case calendar       = "kTCCServiceCalendar"
    case homekit        = "kTCCServiceWillow"
    case contacts       = "kTCCServiceContacts"
    case camera         = "kTCCServiceCamera"
    case microphone     = "kTCCServiceMicrophone"
    case twitter        = "kTCCServiceTwitter"
    case motion         = "kTCCServiceMotion"
    case mediaLibrary   = "kTCCServiceMediaLibrary"
    case siri           = "kTCCServiceSiri"
}

public enum GrantAccessError: Error {
    case simulatorOnly
    case cantLocateDBFile
    case cantFindBundleIdentifier
    case cantModifyDBFile

}

public class ATSimulatorTools {
    
    public init() { }
    
    private var libraryPath : String? {
        let dir = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        return dir.first
    }
    
    private var dbPath : URL? {
        guard let libraryPath = libraryPath else {
            return nil
        }
        
        var url = URL(fileURLWithPath: libraryPath)
        url.deleteLastPathComponent()
        url.deleteLastPathComponent()
        url.deleteLastPathComponent()
        url.deleteLastPathComponent()
        url.deleteLastPathComponent()

        url.appendPathComponent("Library")
        url.appendPathComponent("TCC")
        url.appendPathComponent("TCC.db")
        
        return url
    }
    
    private var bundleIdentifier : String? {
        let mainBundle = Bundle(for: Self.self)
        return mainBundle.bundleIdentifier
    }
    
    public func grantAccess(toPermission permission : ATDevicePermission, allowd : Bool) throws {
        guard (TARGET_IPHONE_SIMULATOR != 0) else {
            throw GrantAccessError.simulatorOnly
        }
        
        guard let dbPath = self.dbPath else {
            throw GrantAccessError.cantLocateDBFile
        }
        
        guard let bundleIdentifier = self.bundleIdentifier else {
            throw GrantAccessError.cantFindBundleIdentifier
        }
        
        do {
            let db = try Connection(dbPath.absoluteString)

            let service = permission.rawValue
            let client = bundleIdentifier
            let allowdInt : Int = allowd ? 2 : 0
            let timeStamp =  Int(Date().timeIntervalSince1970)
            try db.run("REPLACE INTO access VALUES('\(service)','\(client)',0,\(allowdInt),5,1,NULL,NULL,NULL,'UNUSED',NULL,0,\(timeStamp))")
            if allowd {
                os_log("Authorization granted for %@", service)
            } else {
                os_log("Authorization removed for %@", service)
            }

        } catch {
            throw GrantAccessError.cantModifyDBFile
        }
        
        
    }
    

}
