# ZSH Instalation
info? installing...
sudo apt install -y zsh 2>>$logfile 1>&2 &
wait_job

# https://ohmyz.sh/
info? installing oh-my-zsh...
[[ -d "$HOME/.oh-my-zsh" ]] && rm -rf "$HOME/.oh-my-zsh"
yes | sh -c \
    "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    '' 2>>$logfile 1>&2 &
wait_job

# https://github.com/zsh-users/zsh-autosuggestions
info? installing autosuggestions...
git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" \
    2>>$logfile 1>&2 &
wait_job

# https://github.com/zsh-users/zsh-completions
info? installing autocompletions...
git clone https://github.com/zsh-users/zsh-completions \
    ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions \
    2>>$logfile 1>&2 &
wait_job

# https://github.com/zdharma-continuum/fast-syntax-highlighting
info? installing syntax-highlighting...
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" \
    2>>$logfile 1>&2 &
wait_job

# pre-configured zshrc
info? linking .zshrc...
rm ~/.zshrc
ln -s $(realpath config/.zshrc) ~/.zshrc

# chsh
info? setting zsh as the default shell...
sudo chsh -s $(which zsh)
sudo -u $USER chsh -s $(which zsh)
