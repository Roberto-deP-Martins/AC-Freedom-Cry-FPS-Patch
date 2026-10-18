import Prism

extension Localized {
    enum EnglishDictionary {
        static let strings: [String:String] = [
            "open_file_dialog_prompt": Prism {
                "Press"
                Bold {
                    ForegroundColor(.yellow, "Enter")
                }
                "to select the game executable (ACFC.exe) to patch:"
            }.description,
            "file_dialog_title": "Select Assassin’s Creed Freedom Cry Executable",
            "wrong_executable": Prism {
                Bold {
                    ForegroundColor(.red, "Selected file is not the game executable (ACFC.exe).")
                }
            }.description,
            "exit_prompt": Prism {
                "Press"
                Bold {
                    ForegroundColor(.yellow, "Enter")
                }
                "to exit."
            }.description,
            "patching": "Patching %s...",
            "error_patching": "Error patching the game: %s",
            "finished_patching": Prism {
                Bold {
                    ForegroundColor(.green, "\nFinished patching %s!")
                }
            }.description,
            "backing_up": Prism {
                "Backing up the original executable as file"
                Underline("%s...")
            }.description,
            "seeking_address": "Seeking address %s...",
            "overwriting_bytes": "Overwriting bytes at offset %s...",
        ]
    }
}