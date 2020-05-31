### Installing nvim from source

```
git clone https://github.com/neovim/neovim.git

cd neovim

make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/opt/nvim
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/opt/nvim install
```

Add `/opt/nvim/bin` to PATH in .bashrc
```
PATH=$PATH:~/opt/nvim/bin
```


### Install dependencies for nvim and plugins

#### Fzf
#### ripgrep

