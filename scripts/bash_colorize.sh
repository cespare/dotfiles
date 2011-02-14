#!/bin/bash

git_ps1_colored () {
  local g="$(__gitdir)"
  if [ -n "$g" ]; then
    local r
    local b
    if [ -f "$g/rebase-merge/interactive" ]; then
      r="|REBASE-i"
      b="$(cat "$g/rebase-merge/head-name")"
    elif [ -d "$g/rebase-merge" ]; then
      r="|REBASE-m"
      b="$(cat "$g/rebase-merge/head-name")"
    else
      if [ -d "$g/rebase-apply" ]; then
        if [ -f "$g/rebase-apply/rebasing" ]; then
          r="|REBASE"
        elif [ -f "$g/rebase-apply/applying" ]; then
          r="|AM"
        else
          r="|AM/REBASE"
        fi
      elif [ -f "$g/MERGE_HEAD" ]; then
        r="|MERGING"
      elif [ -f "$g/BISECT_LOG" ]; then
        r="|BISECTING"
      fi

      b="$(git symbolic-ref HEAD 2>/dev/null)" || {

        b="$(
        case "${GIT_PS1_DESCRIBE_STYLE-}" in
        (contains)
          git describe --contains HEAD ;;
        (branch)
          git describe --contains --all HEAD ;;
        (describe)
          git describe HEAD ;;
        (* | default)
          git describe --exact-match HEAD ;;
        esac 2>/dev/null)" ||

        b="$(cut -c1-7 "$g/HEAD" 2>/dev/null)..." ||
        b="unknown"
        b="($b)"
      }
    fi

    local i
    local s
    local u
    local c
    local GREEN="\033[01;32m"
    local YELLOW="\033[0;33m"
    local w=$GREEN

    if [ "true" = "$(git rev-parse --is-inside-git-dir 2>/dev/null)" ]; then
      if [ "true" = "$(git rev-parse --is-bare-repository 2>/dev/null)" ]; then
        c="BARE:"
      else
        b="GIT_DIR!"
      fi
    elif [ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
      if [ -n "${GIT_PS1_SHOWDIRTYSTATE-}" ]; then
        if [ "$(git config --bool bash.showDirtyState)" != "false" ]; then
          git diff --no-ext-diff --quiet --exit-code || w=$YELLOW
          if git rev-parse --quiet --verify HEAD >/dev/null; then
            git diff-index --cached --quiet HEAD -- || i="+"
          else
            i="#"
          fi
        fi
      fi
    fi

    #printf "$w${1:- (%s)}" "$c${b##refs/heads/}${i:+ $i}$r"
    git_ps1_color=$w
    git_ps1_string=" ($c${b##refs/heads/}${i:+ $i}$r)"
  else
    git_ps1_string=""
  fi

}
