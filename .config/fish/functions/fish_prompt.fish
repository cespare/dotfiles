function fish_prompt
    set -l last_status $status
    set -l normal (set_color normal)
    set -l cwd_color (set_color $fish_color_cwd)
    set -l vcs_color (set_color brpurple)
    set -l prompt_status ''

    # Since we display the prompt on a new line allow the directory names to be longer.
    set -lx fish_prompt_pwd_dir_length 0

    # Color the prompt differently when we're root.
    set -l suffix '❯'
    if fish_is_root_user
        if set -q fish_color_cwd_root
            set cwd_color (set_color $fish_color_cwd_root)
        end
        set suffix '#'
    end

    if test $last_status -ne 0
        set prompt_status (set_color $fish_color_error) '[' $last_status ']' $normal
    end

    # Set options for VCS prompts.
    # TODO: This is a whole mess. I still like my old zsh git prompt better.
    # Editing a giant pile of fish scripts isn't the way. Write a Go tool to
    # print out my VCS prompt (or maybe my entire prompt) and call that instead.
    set -lx __fish_git_prompt_use_informative_chars 1
    set -lx __fish_git_prompt_showdirtystate 1
    set -lx __fish_git_prompt_showuntrackedfiles 1
    set -lx __fish_git_prompt_showstashstate 1
    set -lx __fish_git_prompt_showupstream verbose name
    set -lx __fish_git_prompt_color blue
    set -lx __fish_git_prompt_char_stateseparator ' '
    set -lx __fish_git_prompt_char_dirtystate 'U'
    set -lx __fish_git_prompt_char_invalidstate ''
    set -lx __fish_git_prompt_char_stagedstate 'S'
    set -lx __fish_git_prompt_char_untrackedfiles 'T'
    set -lx __fish_git_prompt_char_stashstate '$'
    set -lx __fish_git_prompt_char_upstream_ahead '+'
    set -lx __fish_git_prompt_char_upstream_behind '-'
    set -lx __fish_git_prompt_char_upstream_diverged '±'
    set -lx __fish_git_prompt_showcolorhints 1

    echo -s (prompt_login) ' ' $cwd_color (prompt_pwd) $vcs_color (fish_vcs_prompt) $normal ' ' $prompt_status
    echo -n -s (set_color brgreen) $suffix ' ' $normal
end
