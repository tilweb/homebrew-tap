class WorkplaceCli < Formula
  desc "Adacor Workplace CLI — Coding Agent powered by Adacor AI"
  homepage "https://github.com/tilweb/workplace-cli"
  url "https://github.com/tilweb/workplace-cli/releases/download/v1.0.0/workplace_cli-1.0.0-py3-none-any.whl"
  sha256 "b0c5ec4754333247e23be58f0bb941078d698597104bdfe8f47cafa2a6726bd1"
  license "Apache-2.0"
  version "1.0.0"

  depends_on "python@3.12"

  # NOTE: pragmatischer Install ohne `Language::Python::Virtualenv`-Mixin.
  # Vanilla python -m venv + pip install resolved alle ~150 Deps selbst.
  # Vorteil: kompakte Formula, kein Homebrew-Helper-API-Drift. Nachteil:
  # keine explizite Resources-Liste fuer brew audit — kommt in Phase 2 wenn
  # das Tap fuer breitere Verteilung audit-clean sein muss.
  def install
    python = Formula["python@3.12"].opt_libexec/"bin/python"
    system python, "-m", "venv", libexec
    pip = libexec/"bin/pip"
    system pip, "install", "--upgrade", "pip", "wheel"

    # Brew's cached_download hat keinen .whl-Suffix, pip akzeptiert das nicht.
    # Copy mit korrekter Extension in den Build-Path, dann pip install.
    wheel_path = buildpath/"workplace_cli-#{version}-py3-none-any.whl"
    cp cached_download, wheel_path
    system pip, "install", wheel_path
    # Hinweis: Brew's post-install dylib-Relocation kann bei einzelnen Rust-
    # Wheels (rpds-py, watchfiles, …) scheitern, weil der Mach-O-Header zu
    # schmal fuer absolute @rpath-ReWrites ist. Der Install selbst ist
    # trotzdem komplett — alle .so-Files liegen im venv mit @rpath/-Refs,
    # die self-konsistent sind. CI behandelt den Linkage-Warning weich
    # (siehe .github/workflows/test-formula.yml).

    # Symlinks ins Brew-bin/. Console-Scripts aus pyproject:
    #   workplace (primary), vibe (legacy migration alias), vibe-acp
    %w[workplace vibe vibe-acp].each do |script|
      target = libexec/"bin/#{script}"
      bin.install_symlink target if target.exist?
    end
  end

  test do
    output = shell_output("#{bin}/workplace --version")
    assert_match(/1\.0\.0/, output)
  end

end
