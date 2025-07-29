source ./catppuccin-mocha.nu

$env.PATH = ( $env.PATH | split row (char esep)
    | prepend '/opt/homebrew/bin'
    | prepend '/opt/homebrew/sbin'
    | prepend '/Applications/Docker.app/Contents/Resources/bin/' 
    )

$env.config = ($env.config? | default {})
$env.config.hooks = ($env.config.hooks? | default {})

def zea [...x] { zellij attach ...$x }
def zec [...x] { zellij -s ...$x }
def zel [...x] { zellij list-sessions }
def zek [...x] { zellij kill-session ...$x }
def zed [...x] { zellij delete-session ...$x }

alias cat = bat
alias diff = batdiff
alias fd = fd -Lu
alias fetch = fastfetch
alias gitfetch = onefetch
alias grep = batgrep
alias ll = ls -a 
alias man = batman
alias top = btm
alias watch = batwatch

# Init Direnv
{ ||
  if (which direnv | is-empty) {
    return
  }
  direnv export json | from json | default {} | load-env
}

# Init asdf
$env.ASDF_DATA_DIR = $"($env.HOME)/.asdf"
$env.ASDF_PYTHON_PATCH_URL = "https://github.com/python/cpython/commit/8ea6353.patch?full_index=1"
if not ($env.ASDF_DATA_DIR | path exists) {
  mkdir $"($env.ASDF_DATA_DIR)/completions"
}
asdf completion nushell | save -f $"($env.ASDF_DATA_DIR)/completions/nushell.nu"

# Init Atuin
$env.ATUIN_DATA_DIR = "~/.local/share/atuin"
if not ($env.ATUIN_DATA_DIR | path exists) {
  mkdir $env.ATUIN_DATA_DIR
}
atuin init nu | save -f $"($env.ATUIN_DATA_DIR)/init.nu"
source ~/.local/share/atuin/init.nu

# Init Starship
$env.STARSHIP_DATA_DIR = ($nu.data-dir | path join "vendor/autoload")
if not ($env.STARSHIP_DATA_DIR | path exists) {
  mkdir $env.STARSHIP_DATA_DIR
}
starship init nu | save -f $"($env.STARSHIP_DATA_DIR)/starship.nu"
def transient_prompt_right [] {
  {|| $"(^starship module cmd_duration)(^starship module time)"}
}
$env.TRANSIENT_PROMPT_COMMAND = ^starship module shell
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = transient_prompt_right

# Init Zoxide
zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu

# SHIMS:

let shims_dir = (
  if ( $env | get --ignore-errors ASDF_DATA_DIR | is-empty ) {
    $env.HOME | path join '.asdf'
  } else {
    $env.ASDF_DATA_DIR
  } | path join 'shims'
)

$env.PATH = ( $env.PATH | split row (char esep)
    | where { |p| $p != $shims_dir }
    | prepend $shims_dir
    | prepend $'($env.HOME)/.cargo/bin'
    | append ~/bin
    | append $'($env.HOME)/.local/bin'
)

let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {
        if ($in | path exists) {$'"($in | str replace "\"" "\\\"" )"'} else {$in}
    }
}

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

# This completer will use carapace by default
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace completions are incorrect for nu
        nu => $fish_completer
        # fish completes commits and branch names in a nicer way
        git => $fish_completer
        # carapace doesn't have completions for asdf
        asdf => $fish_completer
        # use zoxide completions for zoxide commands
        __zoxide_z | __zoxide_zi => $zoxide_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config = {
  show_banner: false,
  completions: {
    case_sensitive: false # case-sensitive completions
    quick: true    # set to false to prevent auto-selecting completions
    partial: true    # set to false to prevent partial filling of the prompt
    algorithm: "fuzzy"    # prefix or fuzzy
    external: {
      # set to false to prevent nushell looking into $env.PATH to find more suggestions
      enable: true 
      # set to lower can improve completion performance at the cost of omitting some options
      max_results: 100 
      completer: $external_completer 
    }
  }
}






