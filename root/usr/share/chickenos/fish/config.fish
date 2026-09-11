if status is-interactive
  set -g fish_greeting
  
  starship init fish | source
  fzf --fish | source

  bind ctrl-backspace backward-kill-path-component
  bind ctrl-home beginning-of-line
  bind ctrl-end end-of-line
  bind ctrl-delete kill-word
  bind ctrl-down ''
  bind ctrl-up ''
end