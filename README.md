# dotfiles-public

## About

This is mine and mine alone...

## Examples

- `~/.bashrc`

```shell
# ~/.bashrc

if [ -s "${HOME:?}"/.dotfiles-public/bashrc ]; then
  . "${HOME:?}"/.dotfiles-public/bashrc
fi

#########
# alias #
#########

##############
# completion #
##############

#################
# configuration #
#################
```

- `~/.brewfile`

```text
# ~/.brewfile

dotfiles_public_brewfile = File.join(ENV['HOME'], "/.dotfiles-public/brewfile")

if File.exist?(dotfiles_public_brewfile)
  instance_eval(File.read(dotfiles_public_brewfile))
end

brew "tree"
```

- `~/.gitconfig`

```text
# ~/.gitconfig

[commit]
  gpgsign = true

[credential]
  helper = osxkeychain

[filter "lfs"]
  clean = git-lfs clean -- %f
  process = git-lfs filter-process
  required = true
  smudge = git-lfs smudge -- %f

[include]
  path = ~/.dotfiles-public/gitconfig
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/auto.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/auto-staged-only.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/feature-abort.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/feature-begin.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/feature-clean.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/feature-continue.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/feature-list.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/feature-to-master.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/feature-to-next.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/feature-where-is.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/publish-feature.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/publish-master.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/publish-next.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/release.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/release-clean.inc
  path = ~/.simple-git-feature-branch-workflow/gitconfig.d/release-status.inc
```

- `~/.gnupg/gpg.conf`

```text
# ~/.gnupg/gpg.conf

keyserver hkps://keys.openpgp.org
use-agent
```

- `~/.gnupg/gpg-agent.conf`

```text
# ~/.gnupg/gpg-agent.conf

default-cache-ttl 3600
max-cache-ttl 86400
pinentry-program /opt/homebrew/bin/pinentry-mac
```

- `~/.ssh/config`

```text
# ~/.ssh/config

Host *
  IdentitiesOnly no
  IdentityAgent ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
  IdentityFile none
  LogLevel error
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
```

- `~/.tmux.conf`

```text
# ~/.tmux.conf

source-file ~/.dotfiles-public/tmux.conf
```

- `~/.vimrc`

```text
" ~/.vimrc

source ~/.dotfiles-public/vimrc
```

- `~/.wgetrc`

```text
# ~/.wgetrc

check-certificate = off
```

- `~/.zprofile`

```shell
# ~/.zprofile

if [ -s "${HOME:?}"/.dotfiles-public/zprofile ]; then
  . "${HOME:?}"/.dotfiles-public/zprofile
fi

#########
# paths #
#########

if [ -d "${HOME:?}"/.custom/bin ]; then
  path=("${HOME:?}"/.custom/bin ${path})
fi

#############
# variables #
#############

CUSTOM=1

export CUSTOM
```

- `~/.zshrc`

```shell
# ~/.zshrc

if [ -s "${HOME:?}"/.dotfiles-public/zshrc ]; then
  . "${HOME:?}"/.dotfiles-public/zshrc
fi

#########
# alias #
#########

##############
# completion #
##############

if [ -d "${HOME:?}"/.custom/share/zsh/site-functions ]; then
  fpath=("${HOME:?}"/.custom/share/zsh/site-functions ${fpath})
fi

if type compinit 1> /dev/null; then
  compinit
else
  autoload -U +X compinit && \
  compinit
fi

if type bashcompinit 1> /dev/null; then
  bashcompinit
else
  autoload -U +X bashcompinit && \
  bashcompinit
fi

#################
# configuration #
#################
```

## License

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
