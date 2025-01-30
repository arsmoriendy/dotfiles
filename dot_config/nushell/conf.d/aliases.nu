alias sctl = sudo systemctl
alias la = ls -al
alias lam = do {la | sort-by modified}
alias che = chezmoi
alias ches = do {chezmoi --path-style=absolute status . | parse "{status} {name}"}
alias chema = chezmoi merge-all .
# fzf modified file in current directory and merge it
alias chemf = do {chezmoi merge (ches | get name | str join "\n" | fzf)}
alias cherf = do {chezmoi re-add (ches | get name | str join "\n" | fzf)}
alias ip = ip -c=always
alias snaproot = sudo btrfs subvolume snapshot -r / $"/.btrfs-snapshots/@_$(^date -Iseconds)"
alias subdel = sudo btrfs subvolume delete
alias less = less -RIS
