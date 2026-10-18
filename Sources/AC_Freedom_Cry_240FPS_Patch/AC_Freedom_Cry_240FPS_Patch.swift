import Foundation
import TinyFileDialogs
import Prism

@main
struct AC_Freedom_Cry_240FPS_Patch {
    static func main() {
        print(Localized["open_file_dialog_prompt"])
        _ = readLine()

        guard let filePath = FilePicker.openFile(
            title: Localized["file_dialog_title"],
            filters: ["*.exe"],
            allowMultiple: false
        ) else {
            return
        }

        if !filePath.hasSuffix("ACFC.exe") {
            print(Localized["wrong_executable"])
            print(Localized["exit_prompt"])
            _ = readLine()
            exit(1)
        } 

        let fileURL = URL(fileURLWithPath: filePath)

        do {
            try backupOriginalExecutable(
                originUrl: fileURL, destinationUrl: URL(fileURLWithPath: filePath + ".bak")
            )

            let gameFileHandle = try FileHandle(forUpdating: fileURL)
            defer {
                try? gameFileHandle.close()
            }

            print(Localized["patching"].replacingOccurrences(of: "%s", with: filePath))
            try patchFrameTimer(gameFileHandle: gameFileHandle)
            try patchDeltaTimeCalc(gameFileHandle: gameFileHandle)
        } catch {
            print(Localized["error_patching"].replacingOccurrences(of: "%s", with: filePath))
            _ = readLine()
            exit(1)
        }
        
        print(Localized["finished_patching"].replacingOccurrences(of: "%s", with: filePath))
        print(Localized["exit_prompt"])
        _ = readLine()
    }

    static func backupOriginalExecutable(originUrl: URL, destinationUrl: URL) throws {
        print(Localized["backing_up"].replacingOccurrences(of: "%s", with: destinationUrl.path))
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destinationUrl.path) {
            try fileManager.removeItem(at: destinationUrl)
        }

        try fileManager.copyItem(at: originUrl, to: destinationUrl)
    }

    /// - Parameters:
    ///   - addressOffset: Address at which we start replacing bytes.
    ///   - newBytes: The bytes that will be written to the file at the given address.
    ///   - gameFileHandle: The file handle of the game executable.
    static func overwriteBytes(addressOffset: UInt64, newBytes: [UInt8], gameFileHandle: FileHandle) throws
    {
        print(Localized["seeking_address"].replacingOccurrences(of: "%s", with: String(addressOffset, radix: 16)))
        try gameFileHandle.seek(toOffset: addressOffset)
        print(Localized["overwriting_bytes"].replacingOccurrences(of: "%s", with: String(addressOffset, radix: 16)))
        try gameFileHandle.write(contentsOf: Data(newBytes))
    }

    /// Changes bytes that were part of the exe instructions that delayed execution
    /// until the number of ticks corresponding to the frame time for the original cap had elapsed.
    ///
    /// After the changes the code no longer reads variable data related to this number of ticks, instead
    /// reading the hardcoded value 0x9C4, which corresponds to 2500 ticks/frame, which is 240 frames / second.
    /// (for little endian, 0x9C4 is stored as 0xC4, 0x09, 0x00, 0x00). This efectivvely changes the frame cap from 60 FPS to 240 FPS.
    ///
    /// The code now will sleep to run a frame at maximum every 0.0041666667 seconds (1/240) instead of the
    /// original 0.016666667 seconds (1/60).
    static func patchFrameTimer(gameFileHandle: FileHandle) throws {
        let addressOffset: UInt64 = 0x622A90

        /// ## Operations Performed:
        /// 1. Clears the high 32-bit register (`MOV EAX, 0x0`) to prevent 64-bit integer overflow.
        /// 2. Hardcodes the low 32-bit target to `0x9C4` (2,500 ticks in Little-Endian: `0xC4, 0x09, 0x00, 0x00`).
        /// 3. Pads instructions with `NOP` (`0x90`) to preserve byte alignment
        let replacementBytes: [UInt8] = [
            0x59, 0x8B, 0x46, 0x78, 0x2B, 0x45, 0xF4, 0x8B,
            0x4E, 0x7C, 0x1B, 0x4D, 0xF8, 0x03, 0xF8, 0xB8,
            0x00, 0x00, 0x00, 0x00, 0x13, 0xD9, 0xB9, 0xC4,
            0x09, 0x00, 0x00, 0x90,
        ]

        try overwriteBytes(
            addressOffset: addressOffset, 
            newBytes: replacementBytes, 
            gameFileHandle: gameFileHandle
        )
    }

    /// Changes [delta time](https://en.wikipedia.org/wiki/Delta_timing) calculation to evaluate against the CPU Invariant TSC
    /// instead of a tick rate stored in a variable that had it's value set by the game settings.
    ///
    /// Since the game is a 32-bit binary, this is done by shifting two pointers that read the lower and higher 32 bits (Low DWORD and High DWORD) of the 64-bit frequency variable,
    /// so that it points to the address in global memory that stores the CPU Invariant TSC.
    ///
    /// If this wasn't done, the game logic would run faster than usual.
    ///
    /// ## See also:
    ///  - [CPU Invariant TSC](https://aakinshin.net/vignettes/tsc/)
    ///  - [ high or low -order DWORD...](https://forums.codeguru.com/showthread.php?465171-high-or-low-order-DWORD#2)
    static func patchDeltaTimeCalc(gameFileHandle: FileHandle) throws {
        let lowAddressOffset: UInt64 = 0x622AEA
        let lowReplacementBytes: [UInt8] = [
            0x8B, 0x15, 0xF0, 0x7E, 0xDF, 0x04,
        ]

        try overwriteBytes(
            addressOffset: lowAddressOffset, newBytes: lowReplacementBytes,
            gameFileHandle: gameFileHandle
        )

        let highAddressOffset: UInt64 = 0x622B09
        let highReplacementBytes: [UInt8] = [
            0xA1, 0xF4, 0x7E, 0xDF, 0x04,
        ]

        try overwriteBytes(
            addressOffset: highAddressOffset, newBytes: highReplacementBytes,
            gameFileHandle: gameFileHandle
        )
    }
}