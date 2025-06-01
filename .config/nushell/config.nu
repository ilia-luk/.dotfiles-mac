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
$env.PATH = ($env.PATH | split row (char esep) | prepend /home/myuser/.apps | append /usr/bin/env)
{ ||
  if (which direnv | is-empty) {
    return
  }
  direnv export json | from json | default {} | load-env
}

$env.config = ($env.config? | default {})
$env.config.hooks = ($env.config.hooks? | default {})
$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt?
    | default []
    | append {||
        let direnv = (/nix/store/1zwcd1mi3jysyfpvivnbi1fmjvfkgnwk-direnv-2.34.0/bin/direnv export json
        | from json
        | default {})
        if ($direnv | is-empty) {
            return
        }
        $direnv
        | items {|key, value|
            {
                key: $key
                value: (do (
                    $env.ENV_CONVERSIONS?
                    | default {}
                    | get -i $key
                    | get -i from_string
                    | default {|x| $x}
                ) $value)
            }
        }
        | transpose -ird
        | load-env
    }
)

alias cat = bat
alias diff = batdiff
alias fd = fd -Lu
alias fetch = disfetch
alias gitfetch = onefetch
alias grep = batgrep
alias ll = eza --icons --group-directories-first --total-size -l -a -@ -T -L=1
alias man = batman
alias neofetch = disfetch
alias top = btm
alias watch = batwatch

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
