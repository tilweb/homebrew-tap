# tilweb Homebrew Tap

Homebrew-Tap für interne Adacor-/tilweb-Tools.

## Installation

```sh
brew tap tilweb/tap
brew install workplace-cli
```

Alternativ ohne expliziten `tap`:
```sh
brew install tilweb/tap/workplace-cli
```

## Verfügbare Formulas

| Formula | Beschreibung | Repo |
|---|---|---|
| `workplace-cli` | Adacor Workplace CLI (Coding-Agent powered by Adacor AI, fork of Mistral Vibe) | [tilweb/workplace-cli](https://github.com/tilweb/workplace-cli) |

## Updates

```sh
brew update
brew upgrade workplace-cli
```

## Konfiguration `workplace-cli`

Nach Install:
```sh
# API-Key setzen (in ~/.zshrc oder ~/.bashrc)
export ADACOR_AI_API_KEY="dein-key-hier"

# Erster Start (TUI)
workplace

# One-Shot
workplace -p "Erkläre mir was test/foo.py macht"
```

Telemetrie ist standardmäßig deaktiviert. Opt-in:
```sh
# Lokal (JSONL in ~/.config/workplace/usage.jsonl)
export WORKPLACE_TELEMETRY=local
```

## Maintenance

Formula-Updates werden manuell gepusht nach jedem Workplace-CLI-Release:
1. Neuer Workplace-CLI-Tag `v<x.y.z>` → GitHub-Release mit Wheel
2. `url` und `sha256` in `Formula/workplace-cli.rb` aktualisieren
3. `brew install --build-from-source ./Formula/workplace-cli.rb` lokal testen
4. Commit + Push

Automatisierung via GitHub-Action ist Phase 3 (siehe `tilweb/workplace-cli` Roadmap).
