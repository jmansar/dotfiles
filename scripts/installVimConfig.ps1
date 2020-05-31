$repoRoot = "$PSScriptRoot/.."

Copy-Item -Path "$repoRoot/.vimrc" -Destination "~/"
Copy-Item -Path "$repoRoot/.config/nvim" -Destination "~/AppData/Local" -Recurse -Force
