import Prism

extension Localized {
    enum BrazillianPortugueseDictionary {
        static let strings:[String:String] = [
            "open_file_dialog_prompt": Prism {
                "Aperte"
                Bold {
                    ForegroundColor(.yellow, "Enter")
                }
                "para selecionar o executável (ACFC.exe) a receber o patch:"
            }.description,
            "file_dialog_title": "Selecione o Executável do Assassin’s Creed Freedom Cry",
            "wrong_executable": Prism {
                Bold {
                    ForegroundColor(
                        .red, "O arquivo selecionado não é o executável do jogo (ACFC.exe).")
                }
            }.description,
            "exit_prompt": Prism {
                "Aperte"
                Bold {
                    ForegroundColor(.yellow, "Enter")
                }
                "para sair."
            }.description,
            "patching": "Aplicando patch a %s...",
            "error_patching": "Erro ao aplicar patch ao jogo: %s",
            "finished_patching": Prism {
                Bold {
                    ForegroundColor(.green, "\nPatch aplicado a %s!")
                }
            }.description,
            "backing_up": Prism {
                "Fazendo backup do executável original como arquivo"
                Underline("%s...")
            }.description,
            "seeking_address": "Buscando endereço %s...",
            "overwriting_bytes": "Substituindo bytes no offset %s...",
        ]
    }
}