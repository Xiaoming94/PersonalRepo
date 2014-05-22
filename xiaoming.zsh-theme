local ret_status="%(?:%{$fg_bold[green]%}%n :%{$fg_bold[red]%}%n %s)"
PROMPT='${ret_status}%{$fg_bold[green]%}%p%{$fg[magenta]%}@ %{$fg[white]%}%M %{$fg[cyan]%}[ %c ] %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$fg[blue]%}: -> %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="< git:(%{$fg[red]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX=" %{$fg[blue]%}>%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}dirty%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) %{$fg[green]%}clean%{$reset_color%}"
