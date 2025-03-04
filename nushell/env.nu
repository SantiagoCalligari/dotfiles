
# Nushell Environment Config File
#
# version = "0.92.2"

def create_left_prompt [] {
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
# use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)
# path add /usr/lib/libnvme-mi.so.1
# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')
oh-my-posh init nu
zoxide init nushell | save -f ~/.zoxide.nu
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

$env.EDITOR = "nvim"
$env.TERM = "xterm"
$env.PRINTER = "Impresora"
$env.LS_COLORS = "di=01;34:ln=01;36:so=01;35:pi=01;33:ex=01;32:bd=01;33;01:cd=01;33;01:su=01;31:sg=01;31:tw=01;34;01:ow=01;34;01:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.m4a=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.oga=01;36:*.opus=01;36:*.spx=01;36:*.xspf=01;36:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.docx=00;32:*.rtf=00;32:*.odt=00;32:*.ods=00;32:*.odp=00;32:*.odg=00;32:*.odf=00;32:*.sxw=00;32:*.sxi=00;32:*.sxc=00;32:*.sxd=00;32:*.sxm=00;32:*.ppt=00;32:*.pptx=00;32:*.xls=00;32:*.xlsx=00;32:*.csv=00;32:*.conf=00;32:*.cfg=00;32:*.ini=00;32:*.yml=00;32:*.yaml=00;32:*.json=00;32:*.xml=00;32:*.css=00;32:*.js=00;32:*.php=00;32:*.html=00;32:*.htm=00;32:*.sh=00;32:*.bash=00;32:*.zsh=00;32:*.csh=00;32:*.pl=00;32:*.py=00;32:*.rb=00;32:*.java=00;32:*.h=00;32:*.c=00;32:*.cpp=00;32:*.hpp=00;32:*.cs=00;32:*.go=00;32:*.swift=00;32:*.kt=00;32:*.kts=00;32:*.rs=00;32:*.md=00;32:*.markdown=00;32:*.tex=00;32:*.bib=00;32:*.db=00;32:*.sql=00;32:*.bak=00;31:*.tmp=00;31:*.part=00;31:*.swp=00;31:*.swo=00;31:*.swn=00;31:*.pid=00;31:*.lock=00;31:*.err=00;31:*.error=00;31:*.stderr=00;31:*.stdout=00;31:*.log=00;31:*.stackdump=00;31:*.core=00;31:*.dump=00;31:*.stack=00;31:*.zcompdump=00;31:*.zwc=00;31:*.pcm=00;31:*.wav=00;31:*.mp3=00;31:*.ogg=00;31:*.flac=00;31:*.aac=00;31:*.m4a=00;31:*.mid=00;31:*.midi=00;31:*.mka=00;31:*.mpc=00;31:*.ra=00;31:*.wma=00;31:*.ape=00;31:*.tta=00;31:*.spx=00;31:*.xspf=00;31:*.cue=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:*.qcow2=00;31:*.raw=00;31:*.dmg=00;31:*.sparseimage=00;31:*.sparsebundle=00;31:*.udf=00;31:*.iso=00;31:*.img=00;31:*.bin=00;31:*.nrg=00;31:*.mdf=00;31:*.toast=00;31:*.vcd=00;31:*.vmdk=00;31:*.vdi=00;31:*.vhd=00;31:*.vhdx=00;31:*.qcow=00;31:"

