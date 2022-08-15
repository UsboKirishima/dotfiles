
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# Prompts
autoload -U colors && colors
PS1="%{%B${fg[yellow]}%}%1~ %{${fg[red]}%}%(?..[%?])%{${fg[default]}%}%B>%b "
PS2='%_> '

#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
setopt autocd nomatch appendhistory incappendhistory sharehistory histignoredups histreduceblanks nohistbeep completealiases nobeep noextendedglob nonotify nomultios correct

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

source ~/.aliases

# Customize to your needs...

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=/opt/devkitpro/devkitARM

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
#source /home/usbo/Downloads/zsh-syntax-highlighting/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
