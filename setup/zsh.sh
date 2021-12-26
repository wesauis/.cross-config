info? installing
sudo apt install -y zsh 2>>$logfile 1>&2 &
wait_job

info? installing oh-my-zsh $(dim 'https://ohmyz.sh/')
[[ -d "$HOME/.oh-my-zsh" ]] && rm -rf "$HOME/.oh-my-zsh"
yes | sh -c \
    "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    '' 2>>$logfile 1>&2 &
wait_job

info? installing autosuggestions $(dim 'https://github.com/zsh-users/zsh-autosuggestions')
git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" \
    2>>$logfile 1>&2 &
wait_job

info? installing autocompletions $(dim 'https://github.com/zsh-users/zsh-completions')
git clone https://github.com/zsh-users/zsh-completions \
    ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions \
    2>>$logfile 1>&2 &
wait_job

info? installing syntax-highlighting $(dim 'https://github.com/zdharma-continuum/fast-syntax-highlighting')
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" \
    2>>$logfile 1>&2 &
wait_job

info? installing spaceship theme $(dim 'https://github.com/spaceship-prompt/spaceship-prompt')
git clone https://github.com/spaceship-prompt/spaceship-prompt.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1 \
    2>>$logfile 1>&2 &
wait_job
ln -s "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"


info? linking .zshrc
rm ~/.zshrc
ln -s $(realpath config/.zshrc) ~/.zshrc


info? setting zsh as the default shell for the user $USER
chsh -s $(which zsh)

