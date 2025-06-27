if status is-interactive
    set fish_greeting
    
    bind \e\[1\;5A ""
    bind \e\[1\;5B ""
    bind \e\[3\;5~ kill-word
    bind \e\[1\;5F end-of-line
    bind \e\[1\;5H beginning-of-line
    bind \b backward-kill-path-component

    thefuck --alias | source
    starship init fish | source
end