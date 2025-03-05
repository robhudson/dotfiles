### **Dotfiles Management with a Bare Git Repository**
This repository contains my **dotfiles** and uses a **bare Git repository** to track them without interfering with normal Git operations.

---

## **Creating the Dotfiles Repository (For First-Time Setup)**
If you're setting this up **for the first time**:

```sh
git init --bare $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles remote add origin git@github.com:yourusername/dotfiles.git
```

Then, start adding files:

```sh
dotfiles add ~/.gitconfig
dotfiles add ~/.config/fish/config.fish
dotfiles commit -m "Initial dotfiles commit"
dotfiles push origin main
```

---

## **Setup on a New Machine**
To install and sync your dotfiles on a new machine:

```sh
git clone --bare git@github.com:yourusername/dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```

**⚠️ If you see errors about existing dotfiles, back them up first:**
```sh
mkdir -p ~/.dotfiles-backup
dotfiles checkout 2>&1 | grep -o '\S*$' | xargs -I{} mv {} ~/.dotfiles-backup/{}
dotfiles checkout
```

Now, your dotfiles are in place!

---

## **Tracking New Dotfiles**
To add and commit new dotfiles:

```sh
dotfiles add ~/.config/fish/config.fish
dotfiles commit -m "Added Fish shell config"
dotfiles push origin main
```

---

## **Updating Dotfiles**
When you make changes, simply:

```sh
dotfiles status  # Check for changes
dotfiles diff    # View differences
dotfiles add ~/.config/fish/config.fish
dotfiles commit -m "Updated Fish config"
dotfiles push origin main
```

---

## **Pulling Updates on Another Machine**
To get the latest changes on another computer:

```sh
dotfiles pull origin main
```

---

## **Prevent Accidental Git Conflicts**
Since we are using a **bare repo**, running `git status` in `$HOME` **will not work properly**. To prevent Git from tracking untracked files, run:

```sh
dotfiles config --local status.showUntrackedFiles no
```

---

## **Removing a Tracked File**
To remove a dotfile **from version control but keep it locally**:

```sh
dotfiles rm --cached ~/.zshrc
```

If you also want to **delete the file**:

```sh
dotfiles rm ~/.zshrc
```

---

## **Aliasing `dotfiles` for Convenience**
To avoid typing the full Git command each time, **add this alias to your shell config**:

- **For Fish (`config.fish`):**
  ```fish
  function dotfiles
    /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME $argv
  end
  ```
- **For Bash/Zsh (`.bashrc` or `.zshrc`):**
  ```sh
  alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
  ```

Now, you can simply use:
```sh
dotfiles status
dotfiles add ~/.vimrc
dotfiles commit -m "Updated vim config"
dotfiles push
```

---

## **Uninstalling or Stopping Dotfile Tracking**
If you want to **stop tracking dotfiles on a machine** without deleting the local files:

```sh
rm -rf $HOME/.dotfiles
```

If you **want to delete the dotfiles too**, manually remove them before running the above command.

---

## **🛠 How This Works**
This method tracks your **dotfiles using Git** while keeping your home directory (`~`) clean. Instead of initializing a normal Git repository (which would create a `.git/` folder inside `~`), we store the repository separately as a **bare repository** in `~/.dotfiles/`.

### **How Git Works Here**
Normally, a Git repository consists of:
- A **working directory**: The actual files you edit (`~/myrepo/`).
- A `.git/` directory: Where Git **stores history, commits, and metadata**.

With dotfiles, we **don’t want a `.git/` folder in `~`**, so we:

1. **Create a bare repository** in `~/.dotfiles/`:
   ```sh
   git init --bare $HOME/.dotfiles
   ```
   This means `~/.dotfiles/` **only contains Git data** but no working files.

2. **Tell Git to use `~` as the working directory** by defining:
   ```sh
   alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
   ```
   - `--git-dir=$HOME/.dotfiles` → Tells Git to **store all commits and metadata** in `~/.dotfiles/` instead of `~/.git/`.
   - `--work-tree=$HOME` → Tells Git that **files in `~` are the "working directory"** (where changes happen).

3. **Ignore untracked files in `$HOME`**
   By default, `git status` (or `dotfiles status`) would show **every file in your home directory** as untracked. To prevent this:
   ```sh
   dotfiles config --local status.showUntrackedFiles no
   ```
   This ensures `dotfiles status` only shows **tracked dotfiles**, making Git management easier.
