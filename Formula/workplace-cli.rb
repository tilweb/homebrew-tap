class WorkplaceCli < Formula
  include Language::Python::Virtualenv

  desc "Adacor Workplace CLI — Coding Agent powered by Adacor AI"
  homepage "https://github.com/tilweb/workplace-cli"
  url "https://github.com/tilweb/workplace-cli/releases/download/v1.0.0/workplace_cli-1.0.0-py3-none-any.whl"
  sha256 "b0c5ec4754333247e23be58f0bb941078d698597104bdfe8f47cafa2a6726bd1"
  license "Apache-2.0"
  version "1.0.0"

  depends_on "python@3.12"

  # NOTE: pragmatischer Install: das pre-built Wheel wird direkt mit pip in
  # eine venv installiert, pip resolved alle ~150 Deps selbst. Vorteil: kompakte
  # Formula. Nachteil: keine explizite Audit-fähige Resources-Liste — kommt
  # spaeter (Phase 2) wenn das Tap public wird oder Audit-Mode gebraucht ist.
  def install
    venv = virtualenv_create(libexec, "python3.12")
    system venv.pip_install, cached_download
    bin.install_symlink Dir["#{libexec}/bin/workplace"]
    # Legacy-Binary fuer Migration von User-Setups die noch `vibe` nutzen
    bin.install_symlink Dir["#{libexec}/bin/vibe"] if File.exist?("#{libexec}/bin/vibe")
  end

  test do
    output = shell_output("#{bin}/workplace --version")
    assert_match(/(?i)Workplace.*1\.0\.0|^workplace\s+1\.0\.0/, output)
  end
end
