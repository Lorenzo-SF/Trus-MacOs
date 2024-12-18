#!/bin/bash

# =================================================================================================
# ======
# ====== TrUs (Truedat Utils) Mac Version
# ====== V9.0
# ====== 18/12/2024
# ====== Herramientas y utilidades para la instalaion del entorno de Truedat y para el día a día en equipos Apple
# ======
# =================================================================================================

# =================================================================================================
# ====== Variables
# =================================================================================================

# =================================================================================================
# ====== Generales

DATE_NOW=$(date +"%Y-%m-%d_%H-%M-%S")
HEADER_MESSAGE="Truedat Utils (TrUs)"
DESCRIPTION_MESSAGE=""
USER_HOME=$(eval echo ~"$SUDO_USER")
TRUS_PACKAGES=("git" "curl" "ca-certificates" "curl" "gnupg" "lsb-release" "unzip" "zip" "wget" "vim" "zsh" "fzf" "sl" "neofetch" "jq" "screen" "tmux" "build-essential" "wmctrl" "libssl-dev" "automake" "autoconf" "gedit" "redis-tools" "libncurses6" "libncurses-dev" "postgresql-client" "xclip" "xdotool" "gdebi-core" "fonts-powerline" "xsltproc" "fop" "libxml2-utils" "bc")
DOCKER_PACKAGES=("docker-ce" "docker-ce-cli" "containerd.io" "docker-compose" "docker-compose-plugin")
                    
# =================================================================================================
# ====== Rutas y enlaces simbolicos

LINK_BASE_PATH=~/.local/bin/

TRUS_BASE_PATH=$USER_HOME/trus
TRUS_CONFIG=$TRUS_BASE_PATH/trus.sh
TRUS_PATH=$TRUS_BASE_PATH/trus.sh
TRUS_LINK_PATH=$LINK_BASE_PATH/trus

ASDF_ROOT_PATH=~/.asdf
ASDF_PATH=$ASDF_ROOT_PATH/asdf.sh

# =================================================================================================
# ====== Rutas Truedat

WORKSPACE_PATH=$USER_HOME/workspace
TRUEDAT_ROOT_PATH=$WORKSPACE_PATH/truedat
BACK_PATH=$TRUEDAT_ROOT_PATH/back
KONG_PATH=$BACK_PATH/kong-setup/data
FRONT_PATH=$TRUEDAT_ROOT_PATH/front
TD_WEB_DEV_CONFIG=$FRONT_PATH/td-web/dev.config.js
DEV_PATH=$TRUEDAT_ROOT_PATH/true-dev
DDBB_BASE_BACKUP_PATH=$TRUEDAT_ROOT_PATH"/ddbb_truedat"
DDBB_BACKUP_PATH=$DDBB_BASE_BACKUP_PATH/$DATE_NOW
DDBB_LOCAL_BACKUP_PATH=$DDBB_BASE_BACKUP_PATH"/local_backups"

# =================================================================================================
# ====== SSH, ASDF, AWS, KUBE y otros

SSH_NAME="truedat"
SSH_PATH=$USER_HOME/.ssh
SSH_PUBLIC_FILE=$SSH_PATH/$SSH_NAME.pub
SSH_PRIVATE_FILE=$SSH_PATH/$SSH_NAME

AWS_PATH=$USER_HOME/.aws
AWS_CREDENTIALS_PATH="$HOME/.aws/credentials"
AWSCONFIG_PATH=$AWS_PATH/config

KUBE_PATH=$USER_HOME/.kube
KUBECONFIG_PATH=$KUBE_PATH/config

BASH_PATH_CONFIG=$USER_HOME/.bashrc
TMUX_PATH_CONFIG=$USER_HOME/.tmux.conf
TLP_PATH_CONFIG=/etc/tlp.conf

# =================================================================================================
# ====== Sesiones, contextos y configuraciones

AWS_TEST_CONTEXT="test-truedat-eks"
TMUX_SESSION="truedat"
TMUX_ROWS_PER_COLUMN=4
TMUX_ACTUAL_COLUMNS=0
PIDI_PATH=$XDG_DESKTOP_DIR/pidi
PIDI_FILE=$PIDI_PATH/informe_pidi_${GIT_USER_NAME}_${DATE_NOW}.csv
USE_KONG=false

# =================================================================================================
# ====== Rutas de usuario actual (para poder navegar a las carpetas del usuario, independientemente del ididoma)

XDG_DESKTOP_DIR=""

if [ -e "~/.config/user-dirs.dirs" ]; then
    source ~/.config/user-dirs.dirs
else
    XDG_DESKTOP_DIR="$USER_HOME/Escritorio"
fi

# =================================================================================================
# ====== Listados de elementos de infraestructura a procesar

DATABASES=("td_ai" "td_audit" "td_bg" "td_dd" "td_df" "td_i18n" "td_ie" "td_lm" "td_qx")
INDEXES=("dd" "bg" "ie" "qx")
CONTAINERS=("elasticsearch" "redis" "redis_test" "vault")
CONTAINERS_SETUP=("kong_create" "kong_migrate" "kong_setup" "kong")
FRONT_PACKAGES=("audit" "auth" "bg" "core" "cx" "dd" "df" "dq" "qx" "ie" "lm" "profile" "se" "test")
SERVICES=("td-ai" "td-audit" "td-auth" "td-bg" "td-dd" "td-df" "td-i18n" "td-ie" "td-lm" "td-qx" "td-se")
LIBRARIES=("td-cache" "td-cluster" "td-core" "td-df-lib")
NON_ELIXIR_LIBRARIES=("k8s")
LEGACY_REPOS=("td-helm")
DOCKER_LOCALHOST="172.17.0.1"
KONG_ADMIN_URL="localhost:8001"
KONG_ROUTES_SERVICES=("health" "td_audit" "td_auth" "td_bg" "td_dd" "td_qx" "td_dq" "td_lm" "td_qe" "td_se" "td_df" "td_ie" "td_cx" "td_i18n" "td_ai")

# =================================================================================================
# ====== Configuración de Trus

HEADER_LOGO=("  _________   ______     __  __    ______       "
    " /________/\ /_____/\   /_/\/_/\  /_____/\      "
    " \__.::.__\/ \:::_ \ \  \:\ \:\ \ \::::_\/_     "
    "     \::\ \   \:(_) ) )  \:\ \:\ \ \:\/___/\    "
    "      \::\ \   \: __ ´\ \ \:\ \:\ \ \_::._\:\   "
    "       \::\ \   \ \ ´\ \ \ \:\_\:\ \  /____\:\  "
    "        \__\/    \_\/ \_\/  \_____\/  \_____\/  "
)

MAIN_MENU_OPTIONS=("0 - Salir" "1 - Configurar" "2 - Acciones principales" "3 - Actiones secundarias" "4 - Ayuda")
CONFIGURE_MENU_OPTIONS=("0 - Volver" "1 - Instalación de paquetes y configuración de Truedat" "2 - (Re)instalar ZSH y Oh My ZSH" "3 - Archivos de configuración" "4 - Actualizar splash loader" "5 - Actualizar la memoria SWAP (a $SWAP_SIZE GB)" "6 - Configurar animación de los mensajes" "7 - Configurar colores")
CONFIGURATION_FILES_MENU_OPTIONS=("0 - Volver" "1 - ZSH" "2 - BASH" "3 - Fix login Google (solo BASH)" "4 - TMUX" "5 - TLP" "6 - Añadir al archivo de hosts info de Truedat" "7 - Todos")
ANIMATION_MENU_OPTIONS=("0 - Volver" "1 - Pintar test animaciones" ${ANIMATIONS[@]})
PRINCIPAL_ACTIONS_MENU_OPTIONS=("0 - Volver" "1 - Arrancar Truedat" "2 - Matar Truedat" "3 - Operaciones de bdd" "4 - Operaciones de repositorios" "5 - Sesiones (Tmux y Screen)")
START_MENU_OPTIONS=("0 - Volver" "1 - Todo" "2 - Solo contenedores" "3 - Solo servicios" "4 - Solo el frontal")
SECONDARY_ACTIONS_MENU_OPTIONS=("0 - Volver" "1 - Indices de ElasticSearch" "2 - Claves SSH" "3 - Kong" "4 - Linkado de modulos del frontal" "5 - Llamada REST que necesita token de login" "6 - Carga de estructuras" "7 - Carga de linajes" "8 - Informe PiDi")
SESSIONS_MENU_OPTIONS=("0 - Volver" "1 - Entrar en la sesión de Tmux" "2 - Salir en la sesión de Tmux" "3 - Entrar en una sesión de Screen" "4 - Salir de la sesión de Screen")
DDBB_MENU_OPTIONS=("0 - Volver" "1 - Descargar SOLO backup de TEST" "2 - Descargar y aplicar backup de TEST" "3 - Aplicar backup de ruta LOCAL" "4 - Crear backup de las bdd actuales" "5 - Limpieza de backups LOCALES" "6 - (Re)crear bdd locales VACÍAS")
REPO_MENU_OPTIONS=("0 - Volver" "1 - Actualizar TODO" "2 - Actualizar solo back" "3 - Actualizar solo front" "4 - Actualizar solo libs")
KONG_MENU_OPTIONS=("0 - Volver" "1 - (Re)generar rutas de Kong" "2 - Configurar Kong")

# =================================================================================================
# ====== Animaciones

ANIMATIONS=("ARROW" "BOUNCE" "BOUNCING_BALL" "BOX" "BRAILLE" "BREATHE" "BUBBLE" "OTHER_BUBBLE" "CLASSIC_UTF8" "CLASSIC" "DOT" "FILLING_BAR" "FIREWORK" "GROWING_DOTS" "HORIZONTAL_BLOCK" "KITT" "METRO" "PASSING_DOTS" "PONG" "QUARTER" "ROTATING_EYES" "SEMI_CIRCLE" "SIMPLE_BRAILLE" "SNAKE" "TRIANGLE" "TRIGRAM" "VERTICAL_BLOCK")

# =================================================================================================
# ====== Personalizacion de TrUs (se sobreescribe en trus.config)

# Copia del gradiente 2, para que el degradado de print_title se visualice bien
GRADIENT_2_AUX=$GRADIENT_2

# =================================================================================================
# ====== Personalizacion
# =================================================================================================

declare propiedadesConfigurables=("COLOR_PRIMARY" "COLOR_SECONDARY" "COLOR_TERNARY" "COLOR_QUATERNARY" "COLOR_SUCCESS" "COLOR_WARNING" "COLOR_ERROR" "COLOR_BACKGROUND" "GRADIENT_1" "GRADIENT_2" "GRADIENT_3" "GRADIENT_4" "GRADIENT_5" "GRADIENT_6")

typeset -a textosPropiedadesConfigurables=(
    [COLOR_PRIMARY]="Primario"
    [COLOR_SECONDARY]="Secundario"
    [COLOR_TERNARY]="Terciario"
    [COLOR_QUATERNARY]="Cuaternario"
    [COLOR_SUCCESS]="Success"
    [COLOR_WARNING]="Warning"
    [COLOR_ERROR]="Error"
    [COLOR_BACKGROUND]="Background"
    # [GRADIENT_1]="Gradiente posicion 1"
    # [GRADIENT_2]="Gradiente posicion 2"
    # [GRADIENT_3]="Gradiente posicion 3"
    # [GRADIENT_4]="Gradiente posicion 4"
    # [GRADIENT_5]="Gradiente posicion 5"
    # [GRADIENT_6]="Gradiente posicion 6"
)

typeset -a relacionPropiedadesConfigurables=(
    ['Primario']="COLOR_PRIMARY"
    ['Secundario']="COLOR_SECONDARY"
    ['Terciario']="COLOR_TERNARY"
    ['Cuaternario']="COLOR_QUATERNARY"
    ['Success']="COLOR_SUCCESS"
    ['Warning']="COLOR_WARNING"
    ['Error']="COLOR_ERROR"
    ['Background']="COLOR_BACKGROUND"
    # ['Gradiente posicion 1']="GRADIENT_1"
    # ['Gradiente posicion 2']="GRADIENT_2"
    # ['Gradiente posicion 3']="GRADIENT_3"
    # ['Gradiente posicion 4']="GRADIENT_4"
    # ['Gradiente posicion 5']="GRADIENT_5"
    # ['Gradiente posicion 6']="GRADIENT_6"
)

config_colours_menu() {
    local opciones_menu=("0 - Volver" "1 - Visualizar ejemplo de configuracion actual")
    for campo in "${propiedadesConfigurables[@]}"; do
        opciones_menu+=("${textosPropiedadesConfigurables[$campo]}")
    done

    local texto_seleccionado=$(print_menu "get_example_color" "${opciones_menu[@]}")

    option=$(extract_menu_option "$texto_seleccionado")
    case "$option" in
    0)
        configure_menu
        ;;

    1)
        print_test_messages

        if [[ "$(print_question '¿Quieres volver al menu de configuración de colores?')" = "Y" ]]; then
            print_title
            config_colours_menu
        fi
        ;;

    *)
        local campo_seleccionado=${relacionPropiedadesConfigurables[$texto_seleccionado]}

        if [ -z "$campo_seleccionado" ]; then
            print_message "Error: No se encontró el campo correspondiente." "$COLOR_ERROR"
            return 1
        fi

        print_semiheader "Actualizando color: $texto_seleccionado"
        print_message "- Valor actual: ${!campo_seleccionado}" "$COLOR_PRIMARY" "after"

        show_color_format

        print_message "  Introduce el nuevo valor (vacío, deja el valor anterior):" "$COLOR_PRIMARY" "before"
        read nuevo_valor

        if [[ $nuevo_valor =~ ^#?[0-9A-Fa-f]{6}$ ]]; then
            update_config "$campo_seleccionado" "$nuevo_valor" "$TRUS_CONFIG"
        fi
        ;;
    esac
}

# =================================================================================================
# ======  Mensajes
# =================================================================================================

print_title() {
    clear
    source shell-tools
    sleep 0.11
    update_config 'GRADIENT_2' '' "$TRUS_CONFIG"

    local EQUIPO="Equipo: $(hostname)"

    local empty_space="                               "
    local logo=(""
    " ⢤⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣶⣶⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⢀ "
    " ⠀⢻⣶⣄⠀⣀⣴⣿⠿⠛⠉⠀⠀⠀⠀⠉⠛⣿⣷⣤⠀⢀⣤⣾⠋ "
    " ⠀⠀⠙⢿⣿⣿⣿⣷⣶⣤⠀⠀⠀⠀⠀⢀⣤⣶⣿⣿⣿⣿⠿⠁  "
    " ⠀⠀⠀⢰⣿⠍⡋⠻⢿⣿⣿⣷⡀⣠⣾⣿⣿⠿⢛⠫⢿⣿    $(print_separator "$empty_space" "⣿" "full" "right" "gradient" | xargs)"
    " ⠀⠀⠀⣿⣿⠐⠢⢌⢌⢌⢻⣿⣿⣿⣿⡫⢅⠨⢐⢡⠘⣿⣇   "
    " ⠀⠀⢰⣿⡏⠀⠈⠕⡑⡑⡑⠈⣿⡿⠑⡊⡐⠢⠪⠁⠀⣿⣿   ⣠⣤⣤⣤⣤⣤⣤       ⢠⡄    ⢠⣄       "
    " ⠀⠀⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡇  ⠈⠉⠉⣿⡏⠉⠉       ⢸⡇    ⢸⣿         $HEADER_MESSAGE"
    " ⠀⢀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿     ⣿⡇   ⢸⣧⣾⠟⠛ ⢸⡇    ⢸⣿ ⢀⣾⠛⠛⠿⠃ "
    " ⠀⣸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⠈⣿⣿⡀    ⣿⡇   ⢸⣿    ⢸⡇    ⢸⣿ ⠘⣿⣄     $GIT_USER_NAME ($GIT_USER_EMAIL)"
    " ⠀⣿⣿⣯⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣿⣿⡿⠀⠀⣿⣿⡇    ⣿⡇   ⢸⣿    ⢸⣇    ⢸⡟   ⠉⠛⣿⡄  $EQUIPO"
    " ⠀⣿⣿⣿⠀⠀⠀⠀⠀⣀⣤⣶⣿⣿⣿⣿⣿⠟⠁⠀⠀⢠⣿⣿⡇    ⣿⡇   ⢸⣿    ⠈⣿⣤⣀⣀⣠⣿⠁ ⢠⣀ ⣀⣼⠇  $DESCRIPTION_MESSAGE"
    " ⠀⠸⣿⣿⣷⠀⣠⣾⣿⣿⣿⣿⣿⠟⠋⠁⠀⠀⠀⠀⢠⣿⣿⣿     ⠉⠁   ⠈⠉      ⠉⠉⠉⠉    ⠉⠉⠉⠁ "
    " ⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⠿⠁⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⠁  "
    " ⠀⠀⠀⠘⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⣤⣿⣿⣿⠟    $(print_separator "$empty_space" "⣿" "full" "right" "gradient" | xargs)"
    " ⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣤⡀⠀⠀⣀⣶⣿⣿⣿⡿⠁     "
    " ⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁       "
    " ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⡿⠋          ")

    local centered_logo=()
    local min_length=${#logo[0]}

    for line in "${logo[@]}"; do
        local line_length=${#line}
        if [ "$line_length" -lt "$min_length" ]; then
            min_length=$line_length
        fi
    done

    for line in "${logo[@]}"; do
        centered_logo+=("$(pad_message "$line" "left" " " "$min_length")")
    done

    print_message_with_gradient "$(printf "%s\n" "${centered_logo[@]}")"
}

print_logo() {
    clear

    update_config 'GRADIENT_2' "$GRADIENT_2_AUX" "$TRUS_CONFIG"

    local logo=("" "" ""
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣤⣴⣴⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠙⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣿⠁"
        "⠀⠙⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⣿⣿⠿⠛⠛⠉⠉⠈⠈⠉⠉⠙⠛⠿⢿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣶⣿⣿⠃⠀"
        "⠀⠀⠘⣿⣿⣿⣿⣤⣀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢿⣿⣿⣿⣿⣿⣦⣀⠀⠀⠀⠀⣀⣴⣿⣿⣿⡿⠁⠀⠀"
        "⠀⠀⠀⠀⠿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⠿⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠉⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⢛⡛⠟⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠻⢛⢿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⠜⡑⠢⠢⢌⠔⠩⢝⢿⣿⣿⣿⣿⣿⣿⣿⣶⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⡿⡛⠣⠢⢑⡑⡊⠌⠩⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⡇⢘⡑⡨⢌⠕⡑⡪⢕⡑⢪⡻⣿⣿⣿⣿⣿⣿⣿⣤⣿⣿⣿⣿⣿⣿⣿⡛⠢⠢⠢⠪⢌⢌⢅⠢⢊⡀⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⠁⠈⢔⡢⠢⠢⠢⠢⠪⠕⡑⡢⠢⢛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠫⢑⡑⡑⡨⢌⢌⢌⡑⡑⡑⡘⠀⢻⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⠀⠀⠡⢐⢨⢌⢌⢌⢌⢌⢔⡢⡅⡂⠕⡻⣿⣿⣿⣿⣿⣿⣿⢟⡢⠢⢌⢅⠢⠢⠢⢑⡑⡪⡕⠢⠂⠀⠸⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⡿⠀⠀⠀⠐⡨⢑⡑⡑⡑⡑⡑⡑⡢⠢⠢⠢⠙⣿⣿⣿⣿⣿⠋⢌⢕⢎⡃⠕⢑⡊⢌⢌⢅⢢⡢⠁⠀⠀⠀⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠑⠪⢕⡢⠢⠢⠢⠢⠪⠈⠀⠀⠘⣿⣿⣿⠁⠀⠈⠑⡑⡑⡑⡘⡑⡑⡑⡑⠑⠀⠀⠀⠀⠨⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⠂⠀⠀⠀⠀⠀⠀⠀⠀⠁⠈⠈⠀⠀⠀⠀⠀⠀⠀⠘⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀"
        "⠀⠀⠀⠀⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀"
        "⠀⠀⠀⣸⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⢹⣿⣿⣿⣿⣿⡄⠀⠀⠀"
        "⠀⠀⠀⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⠃⠈⣿⣿⣿⣿⣿⣧⠀⠀⠀"
        "⠀⠀⢠⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣾⣿⣿⣿⣿⠏⠀⠀⣿⣿⣿⣿⣿⣿⠀⠀⠀"
        "⠀⠀⣼⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣾⣿⣿⣿⣿⣿⠏⠀⠀⠀⣿⣿⣿⣿⣿⣿⡄⠀⠀"
        "⠀⠀⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⣺⣿⣿⣿⣿⣿⣧⠀⠀"
        "⠀⠀⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⠀⠀"
        "⠀⠀⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⡿⠀⠀"
        "⠀⠀⢿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀"
        "⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀"
        "⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⢀⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀"
        "⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⣀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠿⠿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "                                                                                             "
        "        ⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀                                    ⢸⣿                       "
        "        ⠘⠛⠛⠛⣿⣿⠛⠛⠛⠛                                    ⢸⣿             ⢠⣶        "
        "            ⣿⣿      ⣤ ⢀⣤⣤  ⣤⡄    ⢠⣤    ⢀⣠⣤⣤⣀     ⢀⣤⣤⣤ ⢸⣿    ⣀⣤⣤⣤⣀   ⣀⣿⣿⣤⣤      "
        "            ⣿⣿      ⣿⣴⠟⠉⠉  ⣿⡇    ⢸⣿   ⣴⣿⠋⠉⠉⢿⣷   ⣼⣿⠋⠉⠉⠻⣾⣿   ⠘⠛⠉⠉⠉⣿⣷  ⠉⣿⣿⠉⠉⠁     "
        "            ⣿⣿      ⣿⠏     ⣿⡇    ⢸⣿  ⢠⣿⠁    ⣿⡇ ⢰⣿⠁    ⣿⣿        ⢸⣿   ⣿⣿        "
        "            ⣿⣿      ⣿      ⣿⡇    ⢸⣿  ⢸⣿⠿⠿⠿⠿⠿⠿⠇ ⢸⣿     ⢸⣿   ⣴⣿⠿⠛⠛⢻⣿   ⣿⣿        "
        "            ⣿⣿      ⣿      ⣿⡇    ⣾⣿  ⠘⣿⡄       ⠘⣿⡄    ⣿⣿  ⣼⣿    ⣸⣿   ⣿⣿        "
        "            ⣿⣿      ⣿      ⢻⣿⣤⣀⣤⣾⢿⣿   ⠹⣿⣦⣤⣠⣤⣴   ⠻⣿⣤⣀⣤⣾⢻⣿  ⠸⣿⣦⣀⣠⣶⠿⣿   ⢻⣿⣤⣀⡄     "     
        "            ⠉⠉      ⠉       ⠈⠉⠋⠉  ⠉     ⠉⠉⠋⠉⠁     ⠉⠋⠉ ⠈⠉    ⠉⠋⠉  ⠉    ⠈⠉⠉⠁     "

    )

    local centered_logo=()
    local max_length=$(printf "%s" "${logo_lines[@]}" | awk '{print length($0)}' | sort -nr | head -n1)

    for line in "${logo[@]}"; do
        centered_logo+=("$(pad_message "$line" "center" " " "$max_length")")
    done

    print_message_with_gradient "$(printf "%s\n" "${centered_logo[@]}")"

    sleep 0.5
}

# =================================================================
# ====== Git
# =================================================================

clone_truedat_project() {
    mkdir -p $TRUEDAT_ROOT_PATH
    mkdir -p $BACK_PATH
    mkdir -p $BACK_PATH/logs
    mkdir -p $FRONT_PATH

    if [[ "$(print_question '¿Descargar los repos condespondiente de Truedat?')" = "Y" ]]; then
        
        #Este eval está porque en una distro diferente a Ubuntu no se mantiene el agente levantado ni la clave registrada-        
        eval "$(ssh-agent -s)"
        ssh-add $SSH_PRIVATE_FILE

        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/back-end/td-ai.git $BACK_PATH/td-ai
        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/back-end/td-audit.git $BACK_PATH/td-audit
        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/back-end/td-auth.git $BACK_PATH/td-auth
        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/back-end/td-bg.git $BACK_PATH/td-bg
        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/back-end/td-dd.git $BACK_PATH/td-dd
        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/back-end/td-df.git $BACK_PATH/td-df
        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/back-end/td-ie.git $BACK_PATH/td-ie
        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/back-end/td-qx.git $BACK_PATH/td-qx
        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/back-end/td-i18n.git $BACK_PATH/td-i18n
        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/back-end/td-lm.git $BACK_PATH/td-lm
        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/back-end/td-se.git $BACK_PATH/td-se

        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/td-helm.git $BACK_PATH/td-helm
        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/clients/demo/k8s.git $BACK_PATH/k8s

        clone_if_not_exists git@github.com:Bluetab/td-df-lib.git $BACK_PATH/td-df-lib
        clone_if_not_exists git@github.com:Bluetab/td-cache.git $BACK_PATH/td-cache
        clone_if_not_exists git@github.com:Bluetab/td-core.git $BACK_PATH/td-core
        clone_if_not_exists git@github.com:Bluetab/td-cluster.git $BACK_PATH/td-cluster

        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/front-end/td-web-modules.git $FRONT_PATH/td-web-modules
        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/front-end/td-web $FRONT_PATH/td-web

        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/true-dev.git $DEV_PATH

        set_elixir_versions
    fi
}

# =================================================================
# ====== Actualizaciones de repos y compilaciones
# =================================================================

update_services() {
    local create_dbb=${1:-""}

    print_semiheader "Actualizando servicios"

    for SERVICE in "${SERVICES[@]}"; do
        cd "$BACK_PATH/$SERVICE"

        print_message "Actualizando $SERVICE" "$COLOR_PRIMARY" "before"

        update_git "develop"

        compile_elixir "$create_dbb"
    done

    if [ -n "$create_ddbb" ]; then
        trus -d -du
    fi
}

update_libraries() {
    print_semiheader "Actualizando librerias"

    for LIBRARY in "${LIBRARIES[@]}"; do
        print_message "Actualizando ${LIBRARY}" "$COLOR_PRIMARY" "before"

        cd "$BACK_PATH/$LIBRARY"

        update_git "main"
        compile_elixir

        cd ..
    done

    for REPO in "${LEGACY_REPOS[@]}"; do
        print_message "Actualizando ${REPO}" "$COLOR_PRIMARY" "before"

        cd "$BACK_PATH/$REPO"

        update_git "master"

        cd ..
    done

    for REPO in "${NON_ELIXIR_LIBRARIES[@]}"; do
        print_message "Actualizando ${REPO}" "$COLOR_PRIMARY" "before"

        cd "$BACK_PATH/$REPO"

        update_git "main"

        cd ..
    done
}

update_web() {
    local branch=${1:-""}

    cd "$FRONT_PATH/td-web"

    print_semiheader "Actualizando frontal"

    print_message "Actualizando td-web" "$COLOR_PRIMARY" "before"

    update_git "develop"

    compile_web

    cd ..

    cd "$FRONT_PATH/td-web-modules"
    print_message "Actualizando td-web-modules" "$COLOR_PRIMARY" "before"

    update_git "main"
    compile_web

    cd ..
}

update_repositories() {
    local create_dbb=${2:-""}
    local branch=1

    print_title

    print_message "Chequeando que existan todos los repos..." "$COLOR_SECONDARY" "both" "center"
    clone_truedat_project
    
    case "$updated_option" in
    "-b" | "--back")
        update_services "$create_dbb"
        updated_option="de back"
        ;;

    "-f" | "--front")
        update_web
        updated_option="de front"
        ;;

    "-l" | "--libs")
        update_libraries
        updated_option="de librerias"
        ;;

    "-a" | "--all" | "")
        update_services "$create_dbb"
        update_libraries
        update_web
        updated_option="de back, librerias y front"
        ;;
    esac

    print_message "REPOSITORIOS $updated_option ACTUALIZADOS" "$COLOR_SUCCESS" "both"
}

compile_web() {
    print_message_with_animation "Compilando React..." "$COLOR_TERNARY"
    exec_command "yarn"
    print_message "Compilando React (HECHO)" "$COLOR_SUCCESS"
}

compile_elixir() {
    local create_ddbb=${1:-""}

    exec_command "set -o errexit"
    exec_command "set -o nounset"
    exec_command "set -o pipefail"
    exec_command "set -o xtrace"
    exec_command "export HEX_HTTP_TIMEOUT=300000"

    print_message_with_animation "mix local.hex" "$COLOR_TERNARY"
    exec_command "mix local.hex --force"
    print_message "mix local.hex (HECHO)" "$COLOR_SUCCESS"

    print_message_with_animation "mix local.rebar" "$COLOR_TERNARY"
    exec_command "mix local.rebar --force"
    print_message "mix local.rebar (HECHO)" "$COLOR_SUCCESS"

    print_message_with_animation "mix deps.get" "$COLOR_TERNARY"
    exec_command "mix deps.get"
    print_message "mix deps.get (HECHO)" "$COLOR_SUCCESS"

    print_message_with_animation "mix compile" "$COLOR_TERNARY"
    exec_command "mix compile --force"
    print_message "mix compile (HECHO)" "$COLOR_SUCCESS"

    print_message "Actualizando dependencias Elixir (HECHO)" "$COLOR_SUCCESS"

    if [ ! "$create_ddbb" = "" ]; then
        print_message_with_animation "Creando bdd..." "$COLOR_TERNARY"
        exec_command "yes | mix ecto.create"
        print_message "Creacion de bdd (HECHO)" "$COLOR_SUCCESS"
    fi
}

link_web_modules() {
    print_title
    print_semiheader "Linkado de modulos"

    if [[ "$(print_question 'Se borrarán los links y se volveran a crear. ¿Continuar? ' "$COLOR_PRIMARY" 'Y' 'n')" = "Y" ]]; then
        for d in "${FRONT_PACKAGES[@]}"; do
            cd "$FRONT_PATH/td-web-modules/packages/$d"
            yarn unlink
            yarn link
            cd "$FRONT_PATH/td-web"
            yarn link "@truedat/$d"
        done
    fi
}

set_elixir_versions() {
    exec_command "cd $BACK_PATH/td-auth && asdf local elixir 1.14.5-otp-25"
    exec_command "cd $BACK_PATH/td-audit && asdf local elixir 1.14.5-otp-25"
    exec_command "cd $BACK_PATH/td-ai && asdf local elixir 1.15"
    exec_command "cd $BACK_PATH/td-bg && asdf local elixir 1.14.5-otp-25"
    exec_command "cd $BACK_PATH/td-cluster && asdf local elixir 1.14.5-otp-25"
    exec_command "cd $BACK_PATH/td-core && asdf local elixir 1.14.5-otp-25"
    exec_command "cd $BACK_PATH/td-dd && asdf local elixir 1.14.5-otp-25"
    exec_command "cd $BACK_PATH/td-df && asdf local elixir 1.14.5-otp-25"
    exec_command "cd $BACK_PATH/td-df-lib && asdf local elixir 1.14.5-otp-25"
    exec_command "cd $BACK_PATH/td-ie && asdf local elixir 1.14.5-otp-25"
    exec_command "cd $BACK_PATH/td-lm && asdf local elixir 1.14.5-otp-25"
    exec_command "cd $BACK_PATH/td-qx && asdf local elixir 1.14.5-otp-25"
    exec_command "cd $BACK_PATH/td-se && asdf local elixir 1.16"
    print_message "Versiones específicas de Elixir configuradas" "$COLOR_SUCCESS" "both"
}

# =================================================================
# ====== SQL
# =================================================================

ddbb() {
    local options=$1
    local backup_path=""

    if [ "$options" = "-d" ] || [ "$options" = "--download-test" ] || [ "$options" = "-du" ] || [ "$options" = "--download-update" ]; then
        download_test_backup
        backup_path=$DDBB_BACKUP_PATH
    fi

    if [ "$options" = "-lu" ] || [ "$options" = "--local-update" ]; then
        get_local_backup_path
    fi

    if [ "$options" = "-lb" ] || [ "$options" = "--local-backup" ]; then
        create_backup_local_ddbb
    fi

    if [ "$options" = "-rc" ] || [ "$options" = "--recreate" ]; then
        recreate_local_ddbb
    fi

    if [ -d "$backup_path" ] && [ -n "$backup_path" ]; then
        if [[ "$options" == "-du" || "$options" == "--download-update" || "$options" == "-lu" || "$options" == "--local-update" ]]; then
            update_ddbb_from_backup "$backup_path"
        fi
    fi
}

recreate_local_ddbb() {
    if [[ "$(print_question 'Esta acción BORRARÁ las bases de datos y las creará de nuevo VACÍAS. ¿Continuar? ')" = "Y" ]]; then
        start_containers
        for DATABASE in "${DATABASES[@]}"; do
            local SERVICE="${DATABASE//_/-}"

            cd $BACK_PATH/$SERVICE

            create_empty_ddbb "$DATABASE"
        done
    fi
}

download_test_backup() {
    print_semiheader "Creación y descarga de backup de test "

    local PSQL=$(kubectl get pods -l run=psql -o name | cut -d/ -f2)

    mkdir -p "$DDBB_BACKUP_PATH"

    print_message "Ruta de backup creada: $DDBB_BACKUP_PATH" "$COLOR_SECONDARY" "before"
    for DATABASE in "${DATABASES[@]}"; do
        print_message "-->  Descargando $DATABASE" "$COLOR_SECONDARY" "before"

        local SERVICE_NAME="${DATABASE//_/-}"
        local SERVICE_PODNAME="${DATABASE//-/_}"
        local SERVICE_DBNAME="${DATABASE}_dev"
        local SERVICE_PATH="$BACK_PATH/$SERVICE_NAME"
        local FILENAME=$SERVICE_DBNAME".sql"
        # local PASSWORD=$(kubectl --context ${AWS_TEST_CONTEXT} get secrets postgres -o json | jq -r '.data.PGPASSWORD' | base64 -d)
        # local USER=$(kubectl --context ${AWS_TEST_CONTEXT} get secrets postgres -o json | jq -r '.data.PGUSER' | base64 -d)

        # este codigo está asi (sin usar exec_command) porque al meter la contraseá en una variable e interpretala con eval, se jode y no la interpreta bien,
        # por lo que la funcionalidad que se desa con esa funcion (mostrar o no los mensajes de los comandos) hay que hacerla a lo borrico

        cd "$SERVICE_PATH"
        if [ -z "$HIDE_OUTPUT" ]; then
            print_message_with_animation "creación de backup" "$COLOR_TERNARY"
            # kubectl --context ${AWS_TEST_CONTEXT} exec ${PSQL} -- bash -c "PGPASSWORD='${PASSWORD}' pg_dump -d '${SERVICE_PODNAME}' -U '${USER}' -f '/${DATABASE}.sql' -x -O"
            kubectl --context ${AWS_TEST_CONTEXT} exec ${PSQL} -- bash -c "pg_dump -d '${SERVICE_PODNAME}' -f '/${DATABASE}.sql' -x -O"
            print_message "Creación de backup (HECHO)" "$COLOR_SUCCESS"

            print_message_with_animation "descarga backup" "$COLOR_TERNARY"
            kubectl --context ${AWS_TEST_CONTEXT} cp "${PSQL}:/${DATABASE}.sql" "./${FILENAME}" >/dev/null 2>&1
            print_message "Descarga backup (HECHO)" "$COLOR_SUCCESS"

            print_message " backup descargado en $service_path/$FILENAME" "$COLOR_WARNING"

            print_message_with_animation "borrando fichero generado en el pod" "$COLOR_TERNARY"
            kubectl --context "${AWS_TEST_CONTEXT}" exec "${PSQL}" -- rm "/${DATABASE}.sql" >/dev/null 2>&1
            print_message "Borrando fichero generado en el pod (HECHO)" "$COLOR_SUCCESS"

            print_message_with_animation "comentado de 'create publication'" "$COLOR_TERNARY"            
            sed -i "" 's/create publication/--create publication/g' "./${FILENAME}" >/dev/null 2>&1
            print_message "Comentado de 'create publication' (HECHO)" "$COLOR_SUCCESS"

            print_message_with_animation "moviendo fichero $FILENAME a backup" "$COLOR_TERNARY"
            mv "$FILENAME" "$DDBB_BACKUP_PATH" >/dev/null 2>&1
            print_message "Moviendo fichero $FILENAME a backup (HECHO)" "$COLOR_SUCCESS"
        else
            print_message "Creación de backup" "$COLOR_SECONDARY"
            # kubectl --context ${AWS_TEST_CONTEXT} exec ${PSQL} -- bash -c "PGPASSWORD='${PASSWORD}' pg_dump -d '${SERVICE_PODNAME}' -U '${USER}' -f '/${DATABASE}.sql' -x -O"
            kubectl --context ${AWS_TEST_CONTEXT} exec ${PSQL} -- bash -c "pg_dump -d '${SERVICE_PODNAME}' -f '/${DATABASE}.sql' -x -O"
            print_message "Creación de backup (HECHO)" "$COLOR_SUCCESS" "BOTH"

            print_message "Descarga backup" "$COLOR_SECONDARY"
            kubectl --context ${AWS_TEST_CONTEXT} cp "${PSQL}:/${DATABASE}.sql" "./${FILENAME}"
            print_message "Descarga backup (HECHO)" "$COLOR_SUCCESS"

            print_message " backup descargado en $service_path/$FILENAME" "$COLOR_WARNING"

            print_message "Borrando fichero generado en el pod" "$COLOR_SECONDARY"
            kubectl --context "${AWS_TEST_CONTEXT}" exec "${PSQL}" -- rm "/${DATABASE}.sql"
            print_message "Borrando fichero generado en el pod (HECHO)" "$COLOR_SUCCESS"

            print_message "Comentado de 'create publication'" "$COLOR_SECONDARY"
            sed -i "" 's/create publication/--create publication/g' "./${FILENAME}"
            print_message "Comentado de 'create publication' (HECHO)" "$COLOR_SUCCESS"

            print_message "Moviendo fichero $FILENAME a backup" "$COLOR_SECONDARY"
            mv "$FILENAME" "$DDBB_BACKUP_PATH"
            print_message "Moviendo fichero $FILENAME a backup (HECHO)" "$COLOR_SUCCESS"
        fi
    done

    print_message "Descarga de backup de test terminada" "$COLOR_SUCCESS" "both"
}

create_empty_ddbb() {
    local SERVICE_DBNAME=$1

    print_message "Creando db: $SERVICE_DBNAME" "$COLOR_PRIMARY"

    print_message_with_animation " Borrado de bdd" "$COLOR_TERNARY"
    exec_command "mix ecto.drop"
    print_message " Borrado de bdd (HECHO)" "$COLOR_SUCCESS"

    print_message_with_animation " Creacion de bdd" "$COLOR_TERNARY"
    exec_command "mix ecto.create"
    print_message " Creacion de bdd (HECHO)" "$COLOR_SUCCESS"
}

update_ddbb() {
    local FILENAME=("$@")

    for FILENAME in "${sql_files[@]}"; do
        SERVICE_DBNAME=$(basename "$FILENAME" ".sql")
        SERVICE_NAME=$(basename "$FILENAME" "_dev.sql" | sed 's/_dev//g; s/_/-/g')

        cd "$BACK_PATH"/"$SERVICE_NAME"
        print_message "-->  Actualizando $SERVICE_DBNAME" "$COLOR_SECONDARY" "before"
        create_empty_ddbb "$SERVICE_DBNAME"

        print_message_with_animation " Volcado de datos del backup de test" "$COLOR_TERNARY"
        exec_command "PGPASSWORD=postgres psql -d \"${SERVICE_DBNAME}\" -U postgres  -h localhost < \"${FILENAME}\""

        print_message " Volcado de datos del backup de test (HECHO)" "$COLOR_SUCCESS"

        print_message_with_animation " Aplicando migraciones" "$COLOR_TERNARY"
        exec_command "mix ecto.migrate"
        print_message " Aplicando migraciones (HECHO)" "$COLOR_SUCCESS" "after"
    done
}

update_ddbb_from_backup() {
    local path_backup="$1"

    if [ -d "$path_backup" ] && [ -e "$path_backup" ]; then
        sql_files=()

        print_semiheader "Se va a aplicar el backup alojado en: $path_backup"

        while IFS= read -r file; do
            sql_files+=("$file")
        done < <(find "$path_backup" -type f -name "*.sql")

        if [ ${#sql_files[@]} -eq 0 ]; then
            print_message "No se encontraron archivos .sql en el directorio." "$COLOR_ERROR"
        else
            start_containers

            remove_all_redis

            update_ddbb "${sql_files[@]}"

            reindex_all
        fi
    else
        print_message "El directorio especificado no existe." "$COLOR_ERROR"
        exit 1
    fi

    print_message "actualizacion de bdd local terminada" "$color_success"
}

get_local_backup_path() {
    print_semiheader "Aplicando un backup de bdd desde una ruta de local"

    print_message "Por favor, indica la carpeta donde está el backup que deseas aplicar (debe estar dentro de '$DDBB_BASE_BACKUP_PATH')" "$COLOR_SECONDARY" "both"
    read -r path_backup

    if [[ "$path_backup" == "$DDBB_BASE_BACKUP_PATH"* ]]; then
        backup_path=$path_backup
    else
        print_message "La ruta '$path_backup' no es una subruta de '$DDBB_BASE_BACKUP_PATH'." "$COLOR_ERROR" "both"
    fi
}

create_backup_local_ddbb() {
    start_containers

    print_semiheader "Creando backup de la bdd"

    mkdir -p "$DDBB_LOCAL_BACKUP_PATH/LB_$(date +%Y%m%d_%H%M%S)"

    cd "$DDBB_LOCAL_BACKUP_PATH/LB_$(date +%Y%m%d_%H%M%S)"

    for DATABASE in "${DATABASES[@]}"; do
        FILENAME=${DATABASE}"_dev.sql"
        print_message_with_animation " Creación de backup de $DATABASE" "$COLOR_TERNARY"
        PGPASSWORD=postgres pg_dump -U postgres -h localhost "${DATABASE}_dev" >"${FILENAME}"
        print_message " Creación de backup de $DATABASE (HECHO)" "$COLOR_SUCCESS"
    done
    print_message " Backup creado en $DDBB_LOCAL_BACKUP_PATH" "$COLOR_WARNING" "both"
}

# =================================================================
# ====== NoSQL
# =================================================================

reindex_all() {
    start_containers

    print_title
    print_semiheader "Reindexado de Elasticsearch"

    remove_all_index

    if [[ "$(print_question '¿Seguro que quieres reindexar los índices de ElasticSearch?')" = "Y" ]]; then
        for service in "${INDEXES[@]}"; do
            local normalized_service

            normalized_service=$(normalize_text "$service")

            reindex_one "$normalized_service"
        done
    fi
}

reindex_one() {
    local service=$1

    cd "$BACK_PATH/td-$service"
    print_message "Reindexando servicios de td-$service" "$COLOR_PRIMARY"

    case "$service" in
    "dd")
        print_message_with_animation " Reindexando :jobs" "$COLOR_TERNARY"
        exec_command "mix run -e \"TdCore.Search.Indexer.reindex(:jobs, :all)\""
        print_message " Reindexando :jobs (HECHO)" "$COLOR_SUCCESS"

        print_message_with_animation " Reindexando :structures" "$COLOR_TERNARY"
        exec_command "mix run -e \"TdCore.Search.Indexer.reindex(:structures, :all)\""
        print_message " Reindexando :structures (HECHO)" "$COLOR_SUCCESS"

        print_message_with_animation " Reindexando :grants" "$COLOR_TERNARY"
        exec_command "mix run -e \"TdCore.Search.Indexer.reindex(:grants, :all)\""
        print_message " Reindexando :grants (HECHO)" "$COLOR_SUCCESS"

        print_message_with_animation " Reindexando :grant_requests" "$COLOR_TERNARY"
        exec_command "mix run -e \"TdCore.Search.Indexer.reindex(:grant_requests, :all)\""
        print_message " Reindexando :grant_requests (HECHO)" "$COLOR_SUCCESS"

        print_message_with_animation " Reindexando :implementations" "$COLOR_TERNARY"
        exec_command "mix run -e \"TdCore.Search.Indexer.reindex(:implementations, :all)\""
        print_message " Reindexando :implementations (HECHO)" "$COLOR_SUCCESS"

        print_message_with_animation " Reindexando :rules" "$COLOR_TERNARY"
        exec_command "mix run -e \"TdCore.Search.Indexer.reindex(:rules, :all)\""
        print_message " Reindexando :rules (HECHO)" "$COLOR_SUCCESS" "after"
        ;;

    "bg")
        print_message_with_animation " Reindexando :concepts" "$COLOR_TERNARY"
        exec_command "mix run -e \"TdCore.Search.Indexer.reindex(:concepts, :all)\""
        print_message " Reindexando :concepts (HECHO)" "$COLOR_SUCCESS" "after"
        ;;

    "ie")
        print_message_with_animation " Reindexando :ingests" "$COLOR_TERNARY"
        exec_command "mix run -e \"TdCore.Search.Indexer.reindex(:ingests, :all)\""
        print_message " Reindexando :ingests (HECHO)" "$COLOR_SUCCESS" "after"
        ;;

    "qx")
        print_message_with_animation " Reindexando :quality_controls" "$COLOR_TERNARY"

        print_message "REINDEXADO DE QX DESACTIVADO" "$COLOR_ERROR" "" "centered"
        # exec_command "mix run -e \"TdCore.Search.Indexer.reindex(:quality_controls, :all)\""

        print_message " Reindexando :quality_controls (HECHO)" "$COLOR_SUCCESS" "both"
        ;;
    esac
}

remove_all_index() {
    if [[ "$(print_question '¿Quieres borrar todos los datos de ElasticSearch antes de reindexar?')" = "Y" ]]; then
        do_api_call "http://localhost:9200/_all" "DELETE" "--fail"
        print_message "✳ Borrado de ElasticSearch completado ✳" "$COLOR_SUCCESS" "both"
    fi
}

remove_all_redis() {
    if [[ "$(print_question '¿Quieres borrar todos los datos de Redis?')" = "Y" ]]; then
        exec_command "redis-cli flushall "
        print_message "✳ Borrado de Redis completado ✳" "$COLOR_SUCCESS" "both"
    fi
}

# =================================================================
# ====== Llamadas API
# =================================================================

load_structures() {
    local path=$1
    local system="$2"
    local token=$(get_token)

    cd "$path"
    do_api_call "http://localhost:4005/api/systems/${system}/metadata" "POST" "-F 'data_structures=@structures.csv' -F 'data_structure_relations=@relations.csv'" "" "" "$token"
}

load_linages() {
    local path=$
    local token

    path=$(eval echo "$1")
    token=$(get_token)

    cd "$path"

    do_api_call "http://localhost:4005/api/units/test" "PUT" "-F 'nodes=@nodes.csv' -F 'rels=@rels.csv'" "" "" "$token"
}

do_api_call() {
    local url="$1"
    local rest_method="${2:-"GET"}"
    local params="${3:-""}"
    local output_format="${4:-""}"
    local token_type="${5:-"Bearer"}"
    local token="${6:-""}"
    local content_type="${7:-"application/json"}"
    local extra_headers="${8:-""}"

    if [ -z "$url" ]; then
        print_message "Error: No se ha proporcionado una URL." "$COLOR_ERROR" >&2
        return 1
    fi

    local command="curl --silent --globoff --fail "

    if [ ! -z "$token" ]; then
        command+="--header 'Authorization: $token_type ${token}' "
    fi

    if [ ! -z "$extra_headers" ]; then
        command+=" $extra_headers "
    fi

    if [ ! -z "$rest_method" ]; then
        command+="--request $rest_method "
        if [[ "$rest_method" == "POST" || "$rest_method" == "PUT" || "$rest_method" == "PATCH" ]]; then
            command+="--header 'Content-Type: ${content_type}' "
        fi
    fi

    if [ ! -z "$params" ]; then
        if [[ "$rest_method" == "POST" || "$rest_method" == "PUT" || "$rest_method" == "PATCH" ]]; then
            command+="--data '$params' "
        else
            command+="$params "
        fi
    fi

    command+="--location \"$url\""

    start_time=$(date +%s)
    response=$(eval "$command" 2>&1)
    status=$?
    end_time=$(date +%s)
    execution_time=$((end_time - start_time))

    if [ $status -ne 0 ]; then
        print_message "Error en la llamada API: $response" "$COLOR_ERROR" >&2
        return $status
    fi

    print_message "Llamada API completada en $execution_time segundos" "$COLOR_SUCCESS"

    if [ "$output_format" == "json" ]; then
        echo "$response" | jq .
    else
        echo "$response"
    fi
}

get_token() {
    local token=$(do_api_call "localhost:8080/api/sessions/" "POST" "--data '{\"access_method\": \"alternative_login\",\"user\": {\"user_name\": \"admin\",\"password\": \"patata\"}}'" ".token")
    echo "$token"
}

do_api_call_with_login_token() {
    local url="$1"
    local rest_method="$2"
    local params="$3"
    local content_type="$4"
    local extra_headers="$5"
    local output_format="$6"

    local token_type="bearer"
    local token=${get_token}

    do_api_call $url $rest_method $params $output_format $token_type $token $content_type $extra_headers
}

# =================================================================
# ====== Archivos de configuración
# =================================================================

create_configurations() {
    bash_config "y"
    zsh_config
    tmux_config
    tlp_config
}

bash_config() {
    local google_fix=${1:-""}
    print_semiheader "Prompt de Bash"

    local fix=''
    local fix_message=""
    if [ ! -z "$google_fix" ]; then
        fix='export LD_PRELOAD=/lib/x86_64-linux-gnu/libnss_sss.so.2'
        fix_message="(fix login de Google incluido)"
    fi

    if ! grep -q '## Config añadida por TrUs' "$BASH_PATH_CONFIG"; then
        cat <<EOF >>$BASH_PATH_CONFIG
# =================================================================================================
## Config añadida por TrUs
# =================================================================================================

export COLORTERM=truecolor
. "\$HOME/.asdf/asdf.sh"
. "\$HOME/.asdf/completions/asdf.bash"

# Aliases
alias ai="cd ~/workspace/truedat/back/td-ai"
alias audit="cd ~/workspace/truedat/back/td-audit"
alias auth="cd ~/workspace/truedat/back/td-auth"
alias bg="cd ~/workspace/truedat/back/td-bg"
alias dd="cd ~/workspace/truedat/back/td-dd"
alias df="cd ~/workspace/truedat/back/td-df"
alias i18n="cd ~/workspace/truedat/back/td-i18n"
alias ie="cd ~/workspace/truedat/back/td-ie"
alias lm="cd ~/workspace/truedat/back/td-lm"
alias qx="cd ~/workspace/truedat/back/td-qx"
alias se="cd ~/workspace/truedat/back/td-se"
alias helm="cd ~/workspace/truedat/back/td-helm"
alias k8s="cd ~/workspace/truedat/back/k8s"
alias web="cd ~/workspace/truedat/front/td-web"
alias webmodules="cd ~/workspace/truedat/front/td-web-modules"
alias trudev="cd ~/workspace/truedat/true-dev"
alias format="mix format && mix credo --strict"

# Function to shorten path
shorten_path() {
    full_path=\$(pwd)

    IFS=/ read -r -a path_parts <<< "\$full_path"

    if (( \${#path_parts[@]} > 3 )); then
        echo ".../\${path_parts[-3]}/\${path_parts[-2]}/\${path_parts[-1]}"
    else
        echo "\$full_path"
    fi
}

# Function to get git branch status
git_branch_status() {
    branch=\$(git branch --show-current 2>/dev/null)
    if [[ -n "\$branch" ]]; then
        if git diff --quiet 2>/dev/null; then
            echo -e "\033[97;48;5;75m(\$branch)"  # Green branch name
        else
            echo -e "\033[30;48;5;214m(\$branch) "  # Yellow branch name
        fi
    else
        echo ""  
    fi
}

# Function to set prompt
set_prompt() {
    PS1="|\[\033[1;34m\]\t\[\033[m\]|\033[48;5;202m\$(git_branch_status)\033[m|\[\033[1;38;5;202m\]\$(shorten_path)\[\033[m\]> "
}

# Set the prompt when the directory changes
PROMPT_COMMAND=set_prompt
EOF

    fi

    print_message "Prompt de Bash actualizado $fix_message" "$COLOR_SUCCESS" "after"
    print_message "Cierra la terminal y vuelvela a abrir para que surgan efecto los cambios" "$COLOR_WARNING"
}

hosts_config() {
    if ! grep -q '# ====== Añadido por trus' "/etc/hosts"; then
        sudo sh -c 'cat <<EOF >> /etc/hosts
# ====================================
# ====== Añadido por trus
# ====================================
127.0.0.1 localhost
127.0.0.1 $(uname -n).bluetab.net $(uname -n)
127.0.0.1 redis
127.0.0.1 postgres
127.0.0.1 elastic
127.0.0.1 kong
127.0.0.1 neo
127.0.0.1 vault
0.0.0.0 truedatlocal
# ====================================
# ====== Añadido por trus
# ====================================
EOF'

    fi
}

tmux_config() {
    print_semiheader "TMUX"

    touch $TMUX_PATH_CONFIG

    cat <<EOF >$TMUX_PATH_CONFIG
set -g mouse on
setw -g mode-keys vi
unbind -T copy-mode-vi Enter
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -selection c"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
EOF

    print_message "Archivo de configuración creado con éxito" "$COLOR_SUCCESS" "after"
}

tlp_config() {
    print_semiheader "TLP"

    sudo sh -c " touch $TLP_PATH_CONFIG"

    sudo sh -c "
cat <<EOF > $TLP_PATH_CONFIG
TLP_ENABLE=1
TLP_DEFAULT_MODE=AC
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_ENERGY_PERF_POLICY_ON_AC=performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power-saver
CPU_MIN_PERF_ON_AC=0
CPU_MAX_PERF_ON_AC=100
CPU_MIN_PERF_ON_BAT=0
CPU_MAX_PERF_ON_BAT=70
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0
CPU_HWP_DYN_BOOST_ON_AC=1
CPU_HWP_DYN_BOOST_ON_BAT=0
SCHED_POWERSAVE_ON_AC=0
SCHED_POWERSAVE_ON_BAT=1
PLATFORM_PROFILE_ON_AC=performance
PLATFORM_PROFILE_ON_BAT=low-power
RUNTIME_PM_ON_AC=auto
RUNTIME_PM_ON_BAT=auto
EOF
"

    print_message "Archivo de configuración creado con éxito" "$COLOR_SUCCESS" "after"

    print_message_with_animation "Lanzando TLP para hacer efectiva la nueva configuración" "$COLOR_SUCCESS"
    exec_command "sudo tlp start"
    exec_command "sudo systemctl enable tlp.service"
    print_message "TLP lanzado con éxito" "$COLOR_SUCCESS" "after"
}

zsh_config() {
    print_semiheader "ZSH"

    cat <<EOF >"$HOME/.zshrc"
export PATH=\$HOME/bin:\$HOME/.local/bin:/usr/local/bin:\$PATH
export COLORTERM=truecolor
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git elixir asdf fzf zsh-autosuggestions zsh-syntax-highlighting zsh-completions)

zstyle :omz:update mode auto # update automatically without asking
zstyle :omz:update frequency 1

source $ZSH/oh-my-zsh.sh
source shell-tools

set_terminal_config

#git-prompt
alias tdai="cd ~/workspace/truedat/back/td-ai"
alias tdaudit="cd ~/workspace/truedat/back/td-audit"
alias tdauth="cd ~/workspace/truedat/back/td-auth"
alias tdbg="cd ~/workspace/truedat/back/td-bg"
alias tdcore="cd ~/workspace/truedat/back/td-core"
alias tdcache="cd ~/workspace/truedat/back/td-cache"
alias tddd="cd ~/workspace/truedat/back/td-dd"
alias tddf="cd ~/workspace/truedat/back/td-df"
alias tddflib="cd ~/workspace/truedat/back/td-df-lib"
alias tdi18n="cd ~/workspace/truedat/back/td-i18n"
alias tdie="cd ~/workspace/truedat/back/td-ie"
alias tdlm="cd ~/workspace/truedat/back/td-lm"
alias tdqx="cd ~/workspace/truedat/back/td-qx"
alias tdse="cd ~/workspace/truedat/back/td-se"
alias tdhelm="cd ~/workspace/truedat/back/td-helm"
alias k8s="cd ~/workspace/truedat/back/k8s"
alias tdweb="cd ~/workspace/truedat/front/td-web"
alias tdwebmodules="cd ~/workspace/truedat/front/td-web-modules"
alias trudev="cd ~/workspace/truedat/true-dev"
alias mixmix="mix format && mix credo --strict"

preexec() {
    if [[ "$1" == git* ]]; then
        ssh-agent -s > /dev/null 2>&1
        ssh-add ~/.ssh/truedat > /dev/null 2>&1
    fi
}

EOF

    print_message "ZSH config file created succesfully." "$COLOR_SUCCESS" "after"
    print_message "Close and open all terminals to apply changes" "$COLOR_PRIMARY" "after"
}

aws_configure() {
    if [ ! -e "$AWSCONFIG" ]; then
        if [ ! -f "$AWS_CREDENTIALS_PATH" ] || ! grep -q "\[default\]" "$AWS_CREDENTIALS_PATH"; then
            print_message "ATENCIÓN, SE VA A SOLICITAR LOS DATOS DE ACCESO A AWS" "$COLOR_WARNING" "before"
            print_message "perfil: 'default'"
            print_message "Estos datos te los debe dar tu responsable" "$COLOR_WARNING" "both"
            aws configure
        fi

        if [ ! -f "$AWS_CREDENTIALS_PATH" ] || ! grep -q "\[truedat\]" "$AWS_CREDENTIALS_PATH"; then
            print_message "ATENCIÓN, SE VA A SOLICITAR LOS DATOS DE ACCESO A AWS" "$COLOR_WARNING" "before"
            print_message "perfil: 'truedat'"
            print_message "Estos datos te los debe dar tu responsable" "$COLOR_WARNING" "both"
            aws configure --profile truedat
        fi
    fi
}

# =================================================================
# ====== Instalación
# =================================================================

install_trus() {
    if [ ! -e "$HOME/.shell-tools" ]; then
        ./shell-tools.sh
        export PATH=~/.local/bin/:$PATH
    fi

    source ~/.local/bin/shell-tools

    print_header "$COLOR_SECONDARY" "Bienvenido al instalador de TrUs (Truedat Utils)"

    mkdir -p "$TRUS_BASE_PATH"
    rm -f "$TRUS_BASE_PATH"/*
    cp -r $(pwd)/trus.sh "$TRUS_BASE_PATH"

    sudo rm -f $TRUS_LINK_PATH
    sudo ln -s $TRUS_PATH $TRUS_LINK_PATH

    print_semiheader "Truedat Utils (TrUs) instalado con éxito" "$COLOR_TERNARY" "" "center"

}

preinstallation() {
    print_header "" "Preparando el entorno de TrUs y Truedat"

    if [[ ! -e "/tmp/trus_install" ]]; then
        print_message "Se va a proceder a realizar las siguientes tareas:" "$COLOR_PRIMARY"
        print_message " - Actualizar el sistema" "$COLOR_SECONDARY"
        print_message " - Instalación de paquetes:" "$COLOR_SECONDARY"
        for package in "${TRUS_PACKAGES[@]}"; do
            print_message " > $package" "$COLOR_TERNARY"
        done
        for package in "${DOCKER_PACKAGES[@]}"; do
            print_message " > $package" "$COLOR_TERNARY"
        done
        print_message " - Instalación de FZF" "$COLOR_SECONDARY" "before"
        print_message " - Configuracion de info de usuario de GIT:" "$COLOR_SECONDARY"
        print_message " - Instalación de AWSCLI" "$COLOR_SECONDARY"
        print_message " - Instalación de KUBECTL" "$COLOR_SECONDARY"
        print_message " - Instalación de ASDF y plugins" "$COLOR_SECONDARY" "after"

        print_message "En el paso de la instalacion donde se ofrece instalar zsh y oh my zsh, si se decide instalarlo, cuando esté disponible ZSH, escribir "exit" para salir de dicho terminal y terminar con la instalación" "$COLOR_PRIMARY"
        print_message "ya que la instalación se ha lanzado desde bash y en ese contexto, zsh es un proceso lanzado mas y se queda esperando hasta terminar (con el exit), no la terminal por defecto." "$COLOR_PRIMARY" "after"

        # if [[ "$(print_question "LA INSTALACIÓN VA A COMENZAR. ¿Continuar?" "$COLOR_WARNING")" = "Y" ]]; then
            print_semiheader "Instalación paquetes de software" "$COLOR_TERNARY" "" "center"

            install_packages "yes" "${TRUS_PACKAGES[@]}"

            if [ -e "~/.fzf" ]; then
                rm -fr ~/.fzf
                clone_if_not_exists "https://github.com/junegunn/fzf.git" "~/.fzf"
                exec_command "~/.fzf/install"
            fi

            config_git
            install_docker
            install_awscli
            install_kubectl
            install_asdf

            touch "/tmp/trus_install"
        # else
        #     print_header "$COLOR_ERROR" "NO ESTAS PREPARADO"
        # fi
    fi
}

install_truedat() {
    clear
    print_semiheader "Intalación de Truedat"

    if [ ! -e "/tmp/truedat_installation" ]; then
        if [ -f "$SSH_PUBLIC_FILE" ]; then
            print_message "Guia de instalación: https://confluence.bluetab.net/pages/viewpage.action?pageId=136022683" "$COLOR_QUATERNARY" 5 "both"

            print_message "IMPORTANTE: Para poder seguir con la instalación de Truedat, debes crear las claves SSH con 'trus -cs' y tambien tenerlas registrarlas en Gitlab y Githab" "$COLOR_WARNING" "before"
            print_message "De lo contrario, no se descargarán los proyectos y dará error" "$COLOR_WARNING" "after"

            print_message "Se va a proceder a realizar las siguientes tareas:" "$COLOR_PRIMARY"
            print_message " - Configurar AWS los perfiles 'default' y 'truedat'" "$COLOR_SECONDARY"
            print_message " - Instalación de contenedores" "$COLOR_SECONDARY"
            print_message " - Añadido a fichero de hosts info de Truedat" "$COLOR_SECONDARY"
            print_message " - Creación de estructuras de proyecto y descarga de código" "$COLOR_SECONDARY"
            print_message " - Configuración de elastic 'max_map_count'" "$COLOR_SECONDARY"
            print_message " - Linkado de paquetes del los proyectos de  front" "$COLOR_SECONDARY"
            print_message " - Descarga de último backup de bdd de TEST y aplicado a las bdd locales" "$COLOR_SECONDARY"
            print_message " - Configuración de Kong" "$COLOR_SECONDARY"

            if [[ "$(print_question 'Se va a proceder a realizar la instalación de Truedat. ¿Continuar?')" = "n" ]]; then exit 0; fi

            aws_configure
            hosts_config

            start_containers
            clone_truedat_project

            cd $DEV_PATH
            sudo sysctl -w vm.max_map_count=262144
            sudo cp elastic-search/999-map-count.conf /etc/sysctl.d/

             "-a" "yes"
            link_web_modules
            ddbb "-du"
            config_kong
            touch "/tmp/truedat_installation"
            print_message "Truedat ha sido instalado" "$COLOR_SUCCESS" "both"
        else
            print_message "- Claves SSH (NO CREADAS): Tienes que tener creada una clave SSH (el script chequea que la clave se llame 'truedat') en la carpeta ~/.ssh" "$COLOR_ERROR" "before"
            print_message "RECUERDA que tiene que estar registrada en el equipo y en Gitlab. Si no, debes crearla con 'trus -cr' y registarla en la web'" "$COLOR_WARNING" "after"
        fi

    else
        print_message "Truedat ha sido instalado" "$COLOR_PRIMARY" "both"
    fi
}

install_asdf() {
    print_semiheader "ASDF"

    if [[ ! -e "$ASDF_ROOT_PATH" ]] || [[ "$(print_question 'Ya hay una instalación de ASDF, pero si lo deseas se puede BORRAR y REINSTALAR. ¿Continuar?')" = "Y" ]]; then
        print_semiheader "Instalacion y configuración de ASDF y los plugins de Erlang, Elixir, NodeJS y Yarn"

        rm -fr $ASDF_ROOT_PATH

        print_message_with_animation "Instalando ASDF" "$COLOR_TERNARY"
        clone_if_not_exists "https://github.com/asdf-vm/asdf.git" "$ASDF_ROOT_PATH" "--branch v0.14.1"

        . "$HOME/.asdf/asdf.sh"

        print_message "ASDF Instalado" "$COLOR_SUCCESS"

        print_message_with_animation "Instalando plugins de ASDF" "$COLOR_TERNARY"
        exec_command "asdf plugin add erlang"
        exec_command "asdf plugin add elixir"
        exec_command "asdf plugin add nodejs"
        exec_command "asdf plugin add yarn"
        print_message "Plugins de ASDF instalados" "$COLOR_SUCCESS"

        print_message_with_animation "Descargando versiones de Erlang, Elixir, NodeJS y Yarn" "$COLOR_TERNARY"
        exec_command "KERL_BUILD_DOCS=yes asdf install erlang 25.3"
        exec_command "asdf install elixir 1.13.4"
        exec_command "asdf install elixir 1.14.5-otp-25"
        exec_command "asdf install elixir 1.15"
        exec_command "asdf install elixir 1.16"
        exec_command "asdf install nodejs 20.18.0"
        exec_command "asdf install yarn latest"
        print_message "Versiones instaladas" "$COLOR_SUCCESS"

        print_message_with_animation "Seteando versiones por defecto" "$COLOR_TERNARY"
        exec_command "asdf global erlang 25.3"
        exec_command "asdf global elixir 1.14.5-otp-25"
        exec_command "asdf global nodejs 20.18.0"
        exec_command "asdf global yarn latest"
        print_message "Versiones seteadas" "$COLOR_SUCCESS"

        print_message_with_animation "Instalando Gradient Terminal y dependencias" "$COLOR_TERNARY"
        # Meto esto aqui porque aunque no es de ASDF, depende de que ASDF instale NodeJs
        # https://github.com/aurora-0025/gradient-terminal?tab=readme-ov-file
        exec_command "npm install -g gradient-terminal"
        exec_command "npm install -g tinygradient"
        exec_command "npm install -g ansi-regex"
        print_message "Gradient Terminal instalado" "$COLOR_SUCCESS"
    fi
}

install_docker() {
    print_semiheader "Docker"
    if [[ ! -e "$AWS_PATH" ]] || [[ "$(print_question 'Ya hay una instalación de Docker, pero si lo deseas se puede volver a lanzar el asistente de instalación. ¿Continuar?')" = "Y" ]]; then
        print_message_with_animation "Instalando Docker" "$COLOR_SECONDARY"
        
        exec_command "sudo install -m 0755 -d /etc/apt/keyrings"
        exec_command "sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc"
        exec_command "sudo chmod a+r /etc/apt/keyrings/docker.asc"

        exec_command "echo \
        'deb [arch=$SYSTEM_ARCHITECTURE signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$ID $VERSION_CODENAME stable' | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
         
        install_packages "yes" "${DOCKER_PACKAGES[@]}"

        if [ ! -z "$DEV_PATH" ]; then
            mkdir -p $TRUEDAT_ROOT_PATH
            clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/true-dev.git $DEV_PATH
        fi

        cd $DEV_PATH

       
        print_message "Docker y configurado" "$COLOR_SUCCESS"
    fi
}
install_awscli() {
    print_semiheader "AWS"
    if [[ ! -e "$AWS_PATH" ]] || [[ "$(print_question 'Ya hay una instalación de AWS, pero si lo deseas se puede volver a lanzar el asistente de instalación. ¿Continuar?')" = "Y" ]]; then
        local arch="x86_64"
        if [ $SYSTEM_ARCHITECTURE = "amd64" ]; then
            arch="aarch64"
        fi
        
        mkdir -p $AWS_PATH
        cd $AWS_PATH                            
        exec_command "curl 'https://awscli.amazonaws.com/awscli-exe-linux-$arch.zip' -o 'awscliv2.zip'"
        unzip awscliv2.zip
        cd aws
        sudo ./install
    fi
}

install_kubectl() {
    if [ ! -e "$KUBE_PATH" ]; then
        print_message_with_animation "Instalando Kubectl" "$COLOR_TERNARY"

        mkdir -p $KUBE_PATH

        cd $KUBE_PATH

        exec_command "curl -LO https://dl.k8s.io/release/v1.23.6/bin/linux/$SYSTEM_ARCHITECTURE/kubectl && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl"

        touch "$KUBECONFIG_PATH"

        {
            echo 'apiVersion: v1'
            echo 'clusters:'
            echo '- cluster:'
            echo '    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRFNE1URXlPVEF4TlRJeU5Gb1hEVEk0TVRFeU5qQXhOVEl5TkZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTGtjCnBhOWlvSGNYNmIyTGEycmtJQnpqdUd3SkFMYjR6QkxiSzl2b2ZkZGdRODNFeUZaMFExR2UrT3JuUmNZUEowT04KeHBGUTNYT2o2RW9HSGYxbGVQQU8zZG84WlR1UGp6YnluOWVNdU55YkxqWkY1NXNGaGVEYzhtYUlIWW4yV0VzcApkeHl6UllFWUVtRjlHU0EyblZ0bDk2NGxnOEpVMjJMN092THV6bWFhSHlJZGN4VU1JS2I0RThFdG03T3d6aElMClNKZUdTU0xvYUNDQzVaVXFObWx3Yk1tQlE3QkNqUzhwblo3c0FSWjRtbUhDa3ZzQ2RrN01pYUJDMStvZXk3b3IKcjhSbW1yeUN6MndER0R5NTlNamlrOElNRG92cldLQXlPSE9zZXBuS3VRTjRGd0E0U2g5M3g1Rml5bEpyamVRMAo0Y0FxN2swd0xKRFFpb3BTR3ZrQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFHS1hDMFdJSWZHVmhDRXFKUUVRY2xzS1Q1MlUKSkdFMmtlS2piYytwdWVuL0tZTSs2b2hRZE4wbjRDNHZRZzVaNC9NTW1kZ1Vmb0Z2TmcyTy9DKzFSb0ZkajBCOQpNWG1Zc1BzZTVCcEQ1YUkzY0praU1mcElmUC9JYmRRbGVWOW1YYkZoa0lKKzRWYzhjN3FabUdUbzdqdTZvdHRGCkpuVjQxMmZNS25PWHp4NC9MYm1kSjcrdkhGZ053M2kvbjc2Q24wOVNsWTMxRVBtc25ZekYwUUlJczhHZjlZby8Kdm02T3VzbjIyTDZBeUVWNVNnTDBsaWorZEVOR1FoMkpnYUpRYURLM3QySkN3YTg5U2ZFSTZKZHFBaDVSVllLdApQYk82bW1TeTRFTEJWNy9WM1lTTnplZ0ZyR0EvRStaL01CbTBoS3FxcStPUERwUlVmVkk1djlmYTdtZz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo='
            echo '    server: https://B4E4C4ED51C8A123744DE0E261A4C8F7.sk1.eu-west-1.eks.amazonaws.com'
            echo '  name: arn:aws:eks:eu-west-1:576759405678:cluster/truedat'
            echo '- cluster:'
            echo '    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJVEhPc2VHTWkrRm93RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TkRBeE1UQXhOREk0TkRKYUZ3MHpOREF4TURjeE5ETXpOREphTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURQQzZRQjIrZUNCbGE0a1pWVjVrMEx1OFJSRlozN2M3c3VvSnYxUlhwUFhHb2c4d1RpbkZiNVVpSzQKUFJHc3c2ZDU5M2l5YlI4TzYzRTBmM05HTFNGcEUyMkpscW9DQUNyRmpDTEF3NzN6Z0NiQXY1Ym8xdWh2Mk5DVQpjVFN5RjFQN29qK3RXQ0o0QUVDQlA1KzgyZXVUK0czOUFKelRhdDFrUUpVVWtlbUllR1dWM2Zvblk5YS91SkVECkJUcllmMnJEVWUxOG02T2xEVlBQNEdoRG85Q3Yya0J1bVJ0Z0ovYnRkbWpFYkpOdkFTYjB5QTRpWnJxeGYxeE8KakFOZTdJWnFBbjVBWm42NU1zbmNNTW5ISmw2Q3k2LzJmSU0yMWNOeUxXU1JoVFI4ZkJXdlRXWFNDNUZJUjBXdQpTSzNnRG9lTEI2YnZMN2dxZ21Mbyt4WnNDMWVOQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJUZjBLVEhYVU9SZnFUSU93Rm5nOUdRY2lBNGpqQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ3dwZWVQODQzRQpTWFFya0piK2NQakIyZDk1eHNRUG1vL0NRL0l2MGdQd2tKam1ZcXdDU1ptUE1qcmV6WE5mUVZVUSt4bU94M3BaCjBrL0dBTEVOLzYyei9RVm9rQnZkakxwN0dJblhsb2dwUFZxN0ZOUkZSckpYTy9jOTZpWUVoZFFSdDVpMmRtVmYKcWltNnAzMXZSVTVBclFpUktBcW5KZzFuYnA0Q0NTb0pERmhUWlh0dFBFU2RJZ3Mwb05wUmZjWm9xZXNQQlJvOAorZDFYRUdzeGw4bXJJN0FNRXIzMVdSRlNwdHQ5eFpRenhKQU9WY3V2NkFJK2dQMmhnWnBEQTJPY3BhRk40bkkyCmpJTmhrVUVTRWRRSlFUNUJwa2hVUmkxNTBjMStSTm0zclRBbmVEQ1IydjMzQUNXc2h1bmdhdlJ0cy9mVTIzbWoKc1JRTjFpZFBIcEdMCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K'
            echo '    server: https://69A8FA57BC0A79CAB4BBAD796024AB81.gr7.eu-west-1.eks.amazonaws.com'
            echo '  name: arn:aws:eks:eu-west-1:576759405678:cluster/test-truedat-eks'
            echo 'contexts:'
            echo '- context:'
            echo '    cluster: arn:aws:eks:eu-west-1:576759405678:cluster/truedat'
            echo '    user: arn:aws:eks:eu-west-1:576759405678:cluster/truedat'
            echo '  name: truedat'
            echo '- context:'
            echo '    cluster: arn:aws:eks:eu-west-1:576759405678:cluster/test-truedat-eks'
            echo '    user: arn:aws:eks:eu-west-1:576759405678:cluster/test-truedat-eks'
            echo '  name: test-truedat-eks'
            echo '- context:'
            echo '    cluster: arn:aws:eks:eu-west-1:576759405678:cluster/test-truedat-eks'
            echo '    user: arn:aws:eks:eu-west-1:576759405678:cluster/test-truedat-eks'
            echo '  name: arn:aws:eks:eu-west-1:576759405678:cluster/test-truedat-eks'
            echo 'current-context: arn:aws:eks:eu-west-1:576759405678:cluster/test-truedat-eks'
            echo 'kind: Config'
            echo 'preferences: {}'
            echo 'users:'
            echo '- name: arn:aws:eks:eu-west-1:576759405678:cluster/truedat'
            echo '  user:'
            echo '    exec:'
            echo '      apiVersion: client.authentication.k8s.io/v1alpha1'
            echo '      args:'
            echo '      - --region'
            echo '      - eu-west-1'
            echo '      - eks'
            echo '      - get-token'
            echo '      - --cluster-name'
            echo '      - truedat'
            echo '      command: aws'
            echo '- name: arn:aws:eks:eu-west-1:576759405678:cluster/test-truedat-eks'
            echo '  user:'
            echo '    exec:'
            echo '      apiVersion: client.authentication.k8s.io/v1beta1'
            echo '      args:'
            echo '      - --region'
            echo '      - eu-west-1'
            echo '      - eks'
            echo '      - get-token'
            echo '      - --cluster-name'
            echo '      - test-truedat-eks'
            echo '      - --output'
            echo '      - json'
            echo '      command: aws'

        } >$KUBECONFIG_PATH

        aws eks update-kubeconfig --region eu-west-1 --name $AWS_TEST_CONTEXT

        print_message "Kubectl instalado y configurado" "$COLOR_SUCCESS"
    fi

    print_message "Paquetes y dependencias instalado correctamente" "$COLOR_SUCCESS" "both"
}

# =================================================================================================
# ====== Kong
# =================================================================================================

get_service_port() {
    local SERVICE_NAME=$1
    local PORT

    case "$SERVICE_NAME" in
    "td_audit")
        PORT=4007
        ;;

    "td_auth")
        PORT=4001
        ;;

    "td_bg")
        PORT=4002
        ;;

    "td_dd")
        PORT=4005
        ;;

    "td_dq")
        PORT=4004
        ;;

    "td_lm")
        PORT=4012
        ;;

    "td_qe")
        PORT=4009
        ;;

    "td_qx")
        PORT=4010
        ;;

    "td_se")
        PORT=4006
        ;;

    "td_df")
        PORT=4013
        ;;

    "td_ie")
        PORT=4014
        ;;

    "td_i18n")
        PORT=4003
        ;;

    "health")
        PORT=9999
        ;;

    "td_cx")
        PORT=4008
        ;;

    "td_ai")
        PORT=4015
        ;;
    esac

    echo $PORT
}

kong_routes() {
    print_title
    print_semiheader "Generación de rutas en Kong"

    if [[ "$USE_KONG" = false ]]; then
        print_message "Kong no está habilitado" "$COLOR_WARNING"
        print_message "Si se desea habilitar, utiliza 'trus --config_kong'" "$COLOR_WARNING"
    else
        cd $KONG_PATH
        set -o pipefail

        for SERVICE in ${KONG_SERVICES[@]}; do
            local PORT=$(get_service_port "$SERVICE")
            local SERVICE_ID=$(do_api_call "${KONG_ADMIN_URL}/services/${SERVICE}" "GET" "" ".id // empty")
            local DATA='{ "name": "'${SERVICE}'", "host": "'${DOCKER_LOCALHOST}'", "port": '$PORT' }'

            print_message_with_animation "Creando rutas para el servicio: $SERVICE (puerto: $PORT)" "$COLOR_TERNARY"

            if [ -n "${SERVICE_ID}" ]; then
                ROUTE_IDS=$(do_api_call "${KONG_ADMIN_URL}/services/${SERVICE}/routes" "GET" "" ".data[].id")
                if [ -n "${ROUTE_IDS}" ]; then
                    for ROUTE_ID in ${ROUTE_IDS}; do
                        do_api_call "${KONG_ADMIN_URL}/routes/${ROUTE_ID}" "DELETE"
                    done
                fi
                do_api_call "${KONG_ADMIN_URL}/services/${SERVICE_ID}" "DELETE"
            fi

            local API_ID=$(do_api_call "${KONG_ADMIN_URL}/services" "POST" "-d '$DATA'" ".id")
            exec_command "sed -e \"s/%API_ID%/${API_ID}/\" ${SERVICE}.json | curl --silent -H \"Content-Type: application/json\" -X POST \"${KONG_ADMIN_URL}/routes\" -d @- | jq -r '.id'"

            print_message "Rutas servicio: $SERVICE (puerto: $PORT) creadas con éxito" "$COLOR_SUCCESS"
        done

        exec_command "do_api_call '${KONG_ADMIN_URL}/services/health/plugins' 'POST' '--data 'name=request-termination' --data 'config.status_code=200' --data 'config.message=Kong is alive'' '.id'"

        print_message "Creacion de rutas finalizada" "$COLOR_SUCCESS" "both"

    fi
}

activate_kong() {
    print_semiheader "Habilitación de Kong"
    print_message "A continuación, se van a explicar los pasos que se van a seguir si sigues con este proceso" "$COLOR_PRIMARY" "before"
    print_message "Se va a actualizar el archivo de configuracion para reflejar que se debe utilizar Kong a partir de ahora" "$COLOR_SECONDARY"
    print_message "Se va a descargar el repo de Kong en $BACK_PATH" "$COLOR_SECONDARY"
    print_message "Se van a descargar los siguientes contenedores: ${CONTAINERS_SETUP[@]}" "$COLOR_SECONDARY"

    for container in "${CONTAINERS_SETUP[@]}"; do
        print_message "${container[@]}" "$COLOR_TERNARY"
    done

    print_message "Se va a actualizar el archivo $TD_WEB_DEV_CONFIG para que apunte a Kong" "$COLOR_SECONDARY"
    print_message "Se van a actualizar las rutas de Kong" "$COLOR_SECONDARY"

    if [[ "$(print_question 'Se va a activar Kong. ¿Continuar? ')" = "Y" ]]; then
        sed -i "" 's/USE_KONG=false/USE_KONG=false/' "$TRUS_CONFIG"

        cd $BACK_PATH

        clone_if_not_exists git@gitlab.bluetab.net:dgs-core/true-dat/back-end/kong-setup.git $BACK_PATH/kong-setup

        for container in "${CONTAINERS_SETUP[@]}"; do
            print_message " > $container" "$COLOR_SECONDARY"
            exec_command "docker-compose up -d '${container}'"            
        done

        # target: "https://test.truedat.io:443",       -> Se utilizarán los servicios del entorno test
        # target: "http://localhost:8000",             -> Se utilizarán los servicios de nuestro local
        cd $FRONT_PATH

        touch $TD_WEB_DEV_CONFIG

        {
            echo 'module.exports = {'
            echo '  devServer: {'
            echo '    historyApiFallback: true,'
            echo ''
            echo '    proxy: {'
            echo '      "/api": {'
            echo '        target: "http://localhost:8000",'
            echo '        secure: true,'
            echo '        changeOrigin: true,'
            echo '      },'
            echo '      "/callback": {'
            echo '        target: "http://localhost:8000",'
            echo '      },'
            echo '    },'
            echo '  },'
            echo '};'
        } >$TD_WEB_DEV_CONFIG

        start_containers

        kong_routes
    else
        print_message "NO SE HAN REALIZADO MODIFICACIONES" "$COLOR_WARNING" "" "centered"
    fi
}

deactivate_kong() {
    print_semiheader "Deshabilitación de Kong"
    print_message "A continuación, se van a explicar los pasos que se van a seguir si sigues con este proceso" "$COLOR_PRIMARY" "before"
    print_message "Se va a actualizar el archivo de configuracion para reflejar que se debe utilizar Kong a partir de ahora" "$COLOR_SECONDARY"
    print_message "Se va a borrar el proyecto de kong, que se encuentra en $BACK_PATH/kong-setup" "$COLOR_SECONDARY"
    print_message "Se va a eliminar los siguientes contenedores" "$COLOR_SECONDARY"

    for container in "${CONTAINERS_SETUP[@]}"; do
        print_message "${container[@]}" "$COLOR_TERNARY"
    done

    print_message "Se va a actualizar el archivo $TD_WEB_DEV_CONFIG para que se encargue de enrutar td-web" "$COLOR_SECONDARY"

    if [[ "$(print_question 'Se va a desactivar Kong. ¿Continuar? ')" = "Y" ]]; then
        sed -i "" 's/USE_KONG=false/USE_KONG=false/' "$TRUS_CONFIG"

        rm -f $BACK_PATH/kong_routes

        local kong_id=$(docker ps -q --filter "name=kong")

        stop_docker

        if [ ! $kong_id="" ]; then
            docker rm $kong_id
        fi

        cd $FRONT_PATH

        touch $TD_WEB_DEV_CONFIG

        {
            echo 'const target = host => ({'
            echo '  target: host,'
            echo '  secure: false,'
            echo '  proxyTimeout: 5 * 60 * 1000,'
            echo '  timeout: 5 * 60 * 1000,'
            echo '  onProxyReq: (proxyReq, req, res) => req.setTimeout(5 * 60 * 1000),'
            echo '  changeOrigin: true'
            echo '});'
            echo '// const defaultHost = "https://test.truedat.io";'
            echo 'const defaultHost = "http://localhost:4001";'
            echo 'const defaultTargets = {'
            echo '  ai: target(defaultHost),'
            echo '  audit: target(defaultHost),'
            echo '  auth: target(defaultHost),'
            echo '  bg: target(defaultHost),'
            echo '  cx: target(defaultHost),'
            echo '  dd: target(defaultHost),'
            echo '  df: target(defaultHost),'
            echo '  dq: target(defaultHost),'
            echo '  ie: target(defaultHost),'
            echo '  lm: target(defaultHost),'
            echo '  se: target(defaultHost),'
            echo '  i18n: target(defaultHost),'
            echo '  qx: target(defaultHost)'
            echo '};'
            echo 'const targets = {'
            echo '  ...defaultTargets,'
            echo '  ai: target("http://localhost:4015"),'
            echo '  audit: target("http://localhost:4007"),'
            echo '  auth: target("http://localhost:4001"),'
            echo '  bg: target("http://localhost:4002"),'
            echo '  cx: target("http://localhost:4008"),'
            echo '  dd: target("http://localhost:4005"),'
            echo '  df: target("http://localhost:4013"),'
            echo '  dq: target("http://localhost:4004"),'
            echo '  ie: target("http://localhost:4014"),'
            echo '  lm: target("http://localhost:4012"),'
            echo '  se: target("http://localhost:4006"),'
            echo '  i18n: target("http://localhost:4003"),'
            echo '  qx: target("http://localhost:4010")'
            echo '};'
            echo 'const ai = {'
            echo '  "/api/actions": targets.ai,'
            echo '  "/api/indices": targets.ai,'
            echo '  "/api/predictions": targets.ai,'
            echo '  "/api/resource_mappings": targets.ai,'
            echo '  "/api/providers": targets.ai,'
            echo '  "/api/prompts": targets.ai,'
            echo '  "/api/suggestions": targets.ai'
            echo '};'
            echo 'const audit = {'
            echo '  "/api/events": targets.audit,'
            echo '  "/api/notifications": targets.audit,'
            echo '  "/api/subscribers": targets.audit,'
            echo '  "/api/subscriptions": targets.audit'
            echo '};'
            echo 'const auth = {'
            echo '  "/api/acl_entries": targets.auth,'
            echo '  "/api/auth": targets.auth,'
            echo '  "/api/groups": targets.auth,'
            echo '  "/api/init": targets.auth,'
            echo '  "/api/password": targets.auth,'
            echo '  "/api/permission_groupss": targets.auth,'
            echo '  "/api/permissions": targets.auth,'
            echo '  "/api/roles": targets.auth,'
            echo '  "/api/sessions": targets.auth,'
            echo '  "/api/users": targets.auth'
            echo '};'
            echo 'const bg = {'
            echo '  "/api/business_concept_filters": targets.bg,'
            echo '  "/api/business_concept_user_filters": targets.bg,'
            echo '  "/api/business_concept_versions": targets.bg,'
            echo '  "/api/business_concepts": targets.bg,'
            echo '  "/api/domains": targets.bg'
            echo '};'
            echo 'const cx = {'
            echo '  "/api/configurations": targets.cx,'
            echo '  "/api/job_filters": targets.cx,'
            echo '  "/api/jobs": targets.cx,'
            echo '  "/api/sources": targets.cx'
            echo '};'
            echo 'const dd = {'
            echo '  "/api/comments": targets.dd,'
            echo '  "/api/accesses": targets.dd,'
            echo '  "/api/buckets": targets.dd,'
            echo '  "/api/data_structure_filters": targets.dd,'
            echo '  "/api/data_structure_notes": targets.dd,'
            echo '  "/api/data_structure_tags": targets.dd,'
            echo '  "/api/data_structure_types": targets.dd,'
            echo '  "/api/data_structure_versions": targets.dd,'
            echo '  "/api/data_structure_links": targets.dd,'
            echo '  "/api/data_structures": targets.dd,'
            echo '  "/api/grant_filters": targets.dd,'
            echo '  "/api/grant_request_groups": targets.dd,'
            echo '  "/api/grant_requests": targets.dd,'
            echo '  "/api/grants": targets.dd,'
            echo '  "/api/graphs": targets.dd,'
            echo '  "/api/labels": targets.dd,'
            echo '  "/api/lineage_events": targets.dd,'
            echo '  "/api/lineage": targets.dd,'
            echo '  "/api/nodes": targets.dd,'
            echo '  "/api/profile_execution_groups": targets.dd,'
            echo '  "/api/profile_executions": targets.dd,'
            echo '  "/api/profiles": targets.dd,'
            echo '  "/api/reference_data": targets.dd,'
            echo '  "/api/relation_types": targets.dd,'
            echo '  "/api/systems": targets.dd,'
            echo '  "/api/units": targets.dd,'
            echo '  "/api/user_search_filters": targets.dd,'
            echo '  "/api/v2": targets.dd'
            echo '};'
            echo 'const df = {'
            echo '  "/api/templates": targets.df,'
            echo '  "/api/template_relations": targets.df,'
            echo '  "/api/hierarchies": targets.df'
            echo '};'
            echo 'const dq = {'
            echo '  "/api/execution_groups": targets.dq,'
            echo '  "/api/executions": targets.dq,'
            echo '  "/api/functions": targets.dq,'
            echo '  "/api/rule_filters": targets.dq,'
            echo '  "/api/rule_implementation_filters": targets.dq,'
            echo '  "/api/rule_implementations": targets.dq,'
            echo '  "/api/rule_results": targets.dq,'
            echo '  "/api/rule_types": targets.dq,'
            echo '  "/api/rules": targets.dq,'
            echo '  "/api/segment_results": targets.dq'
            echo '};'
            echo 'const ie = {'
            echo '  "/api/ingests": targets.ie,'
            echo '  "/api/ingest_filters": targets.ie,'
            echo '  "/api/ingest_versions": targets.ie'
            echo '};'
            echo 'const lm = {'
            echo '  "/api/business_concept/\\d+/links": targets.lm,'
            echo '  "/api/relations": targets.lm,'
            echo '  "/api/tags": targets.lm'
            echo '};'
            echo 'const se = {'
            echo '  "/api/global_search": targets.se,'
            echo '  "/api/elastic_indexes": targets.se'
            echo '};'
            echo 'const i18n = {'
            echo '  "/api/messages": targets.i18n,'
            echo '  "/api/locales": targets.i18n'
            echo '};'
            echo 'const qx = {'
            echo '  "/api/data_views": targets.qx,'
            echo '  "/api/quality_functions": targets.qx,'
            echo '  "/api/quality_controls": targets.qx'
            echo '};'
            echo ''
            echo 'module.exports = {'
            echo '  devtool: "cheap-module-eval-source-map",'
            echo '  devServer: {'
            echo '    host: "0.0.0.0",'
            echo '    disableHostCheck: true,'
            echo '    historyApiFallback: true,'
            echo '    proxy: {'
            echo '      ...ai,'
            echo '      ...audit,'
            echo '      ...auth,'
            echo '      ...bg,'
            echo '      ...cx,'
            echo '      ...dd,'
            echo '      ...df,'
            echo '      ...dq,'
            echo '      ...ie,'
            echo '      ...lm,'
            echo '      ...se,'
            echo '      ...i18n,'
            echo '      ...qx,'
            echo '      "/api": target(defaultHost)'
            echo '    }'
            echo '  }'
            echo '};'
        } >$TD_WEB_DEV_CONFIG
    else
        print_message "NO SE HAN REALIZADO MODIFICACIONES" "$COLOR_WARNING" "" "centered"
    fi
}

config_kong() {
    print_semiheader "Kong"

    local question=$(print_question "¿Quién quieres que enrute, Kong(K) o td-web(w)?" "$COLOR_PRIMARY" "K" "w")

    if [ $question = "K" ]; then
        activate_kong
    elif [ $question = "w" ]; then
        deactivate_kong
    fi
}

# =================================================================================================
# ======Arranque y apagado
# =================================================================================================

start_containers() {
    print_semiheader "Contenedores Docker"

    cd $DEV_PATH

    exec_command "aws ecr get-login-password --profile truedat --region eu-west-1 | docker login --username AWS --password-stdin 576759405678.dkr.ecr.eu-west-1.amazonaws.com"
    print_message "Login de Docker en AWS realizado con éxito" "$COLOR_SUCCESS"

    print_message "Arrancando contenedores" "$COLOR_SECONDARY"

    for container in "${CONTAINERS[@]}"; do
        print_message " > $container" "$COLOR_SECONDARY"

        exec_command "docker-compose up -d '${container}'"
    done

    if "$USE_KONG" = true; then
        exec_command "docker-compose up -d kong"
    fi
}

stop_docker() {
    print_semiheader "Apagando contenedores..."
    cd "$DEV_PATH"

    for container in "${CONTAINERS[@]}"; do
        exec_command "docker stop '${container}'"
    done

    if "$USE_KONG" = true; then
        exec_command "docker stop 'kong'"
    fi
}

start_services() {
    local SERVICES_TO_IGNORE=("$@")
    local SERVICES_TO_START=()

    for SERVICE in "${SERVICES[@]}"; do
        SERVICE_NAME="${SERVICE#td-}"
        if [[ ! " ${SERVICES_TO_IGNORE[*]} " =~ $SERVICE_NAME ]]; then
            SERVICES_TO_START+=("$SERVICE")
        fi
    done

    for SERVICE in "${SERVICES_TO_START[@]}"; do
        screen -h 10000 -mdS "$SERVICE" bash -c "cd $BACK_PATH/$SERVICE && iex --sname ${SERVICE#td-} -S mix phx.server"
    done

    print_screen_sessions
}

start_tmux(){
    local session=$1
    kill_truedat
    
    print_title

    read -p "$(eval 'print_message "¿Cuantas términales hay que crear?: " "$COLOR_SECONDARY" "both"')" count    
    
    create_tmux_session "$session"
    
    if [ "$count" -lt 6 ]; then
        count=$((count - 1))
    fi
    tmux list-panes
    for ((i=0; i<count; i++)); do
        # tmux split-window -h -t $session:0.$i
        tmux send-keys -t $session:0.$i "sleep 1 && neofetch" C-m
    done
    tmux list-panes
    tmux select-layout tiled 
    # go_to_tmux_session "$session"
}

create_tmux_session(){
    local session=${1:-"$TMUX_SESSION"}
    tmux source-file $TMUX_PATH_CONFIG
    tmux new-session -d -s $session -n "$session"
    tmux split-window -h -t $session:0.0
}

start_truedat() {
    local TMUX_SERVICES=("$@")
    local SCREEN_SERVICES=()

    kill_truedat
    start_containers

    for SERVICE in "${SERVICES[@]}"; do
        local founded_service="false"
        SERVICE=${SERVICE/td-/}
        for SPLIT in "${TMUX_SERVICES[@]}"; do
            if [[ "${SERVICE/td-/}" = "$SPLIT" ]]; then
                founded_service="true"
                break
            fi
        done

        if [[ "$founded_service" = "false" ]]; then
            SCREEN_SERVICES+=("${SERVICE}")
        fi
    done

    start_services "${TMUX_SERVICES[@]}"

    create_tmux_session

    tmux send-keys -t $TMUX_SESSION:0."$((count_tmux_termnals))" "sleep 1 && neofetch" C-m
    tmux send-keys -t $TMUX_SESSION:0."$((count_tmux_termnals + 1))" "trus -sf" C-m

    if [ ${#TMUX_SERVICES[@]} -gt 0 ]; then
        for i in "${!TMUX_SERVICES[@]}"; do
            SERVICE="${TMUX_SERVICES[$i]}"
            SERVICE_NAME="td-${SERVICE}"

            local command="cd $BACK_PATH/$SERVICE_NAME && iex --sname ${SERVICE} -S mix phx.server"

            if (($(count_tmux_termnals) % TMUX_ROWS_PER_COLUMN == 0)); then
                tmux split-window -h -t $TMUX_SESSION:0.0
                tmux send-keys -t $TMUX_SESSION:0."$((count_tmux_termnals + 1))" "$command" C-m
            else
                tmux split-window -v -t $TMUX_SESSION:0
                tmux send-keys -t $TMUX_SESSION:0 "$command" C-m
            fi

        done
    fi

    go_to_tmux_session
}

count_tmux_termnals() {
    echo "$(tmux list-panes -t $TMUX_SESSION | wc -l)"
}

go_to_tmux_session() {
    local session=${1:-"$TMUX_SESSION"}
    clear
    
    if [ "$session" = "$TMUX_SESSION" ]; then
        local cols=$((TMUX_ROWS_PER_COLUMN / 50))
        local rows=$((TMUX_ROWS_PER_COLUMN / 100))

        tmux resize-pane -t $session:0.0 -x 50%

        for ((i = total_panes; i >= 1; i--)); do
            tmux resize-pane -t $session:0.$i -x $cols% -y $rows%
        done

        tmux select-pane -t $session:0.0
    fi

    tmux attach-session -t "$session"
}

go_out_tmux_session() {
    tmux detach-client
}

go_to_screen_session() {
    print_screen_sessions

    print_message "Introduce el id de la sesión a la que quieres acceder" "$COLOR_PRIMARY"
    read -r screen_id_session

    screen -r $screen_id_session
}

go_out_screen_session() {
    screen -d
}

print_screen_sessions() {
    print_title

    print_semiheader "Sesiones activas de Screen:" "$COLOR_PRIMARY"

    screen -ls | awk '/\.td-/ {print $1}' | sed 's/\.\(td-[[:alnum:]]*\)/ => \1/' | while read -r line; do
        print_message "$line" "$COLOR_SECONDARY"
    done
}

kill_truedat() {
    print_title
    print_semiheader "Matando procesos"
    print_message "Matando 'mix' (elixir)" "$COLOR_SECONDARY"
    pkill -9 -f mix >/dev/null 2>&1

    print_message "Matando sesiones Screen" "$COLOR_SECONDARY"
    for session in $(screen -ls | awk '/\t/ {print $1}'); do
        screen -S "$session" -X quit >/dev/null 2>&1
    done

    screen -wipe >/dev/null 2>&1

    print_message "Matando sesiones TMUX" "$COLOR_SECONDARY"
    tmux list-sessions -F "#{session_name}" | while read -r session; do
        tmux kill-session -t "$session" >/dev/null 2>&1
    done


    print_message "Matando front" "$COLOR_SECONDARY"
    pkill -9 -f yarn >/dev/null 2>&1

    print_separator "" "=" "full" "" "$COLOR_SAD"
    print_message "Truedat ha muerto" "$COLOR_SAD" "" "centered"
    print_separator "" "=" "full" "" "$COLOR_SAD" "after"

}

start_front() {
    cd "$FRONT_PATH"/td-web
    yarn start
}

# =================================================================================================
# ====== Otras operaciones importantes
# =================================================================================================

help() {
    local option=${1:-""}
    local suboption=${2:-""}

    case "$option" in
    "trus --help 'main_menu_help'") echo "main_menu_help LANZADA" ;;
    "trus --help 'configure_menu_help'") echo "configure_menu_help LANZADA" ;;
    "trus --help 'configuration_files_menu_help'") echo "configuration_files_menu_help LANZADA" ;;
    "trus --help 'animation_menu_help'") echo "animation_menu_help LANZADA" ;;
    "trus --help 'principal_actions_menu_help'") echo "principal_actions_menu_help LANZADA" ;;
    "trus --help 'start_menu_help'") echo "start_menu_help LANZADA" ;;
    "trus --help 'secondary_actions_menu_help'") echo "secondary_actions_menu_help LANZADA" ;;
    "trus --help 'ddbb_menu_help'") echo "ddbb_menu_help LANZADA" ;;
    "trus --help 'repo_menu_help'") echo "repo_menu_help LANZADA" ;;
    "trus --help 'kong_menu_help'") echo "kong_menu_help LANZADA" ;;
    "0 - Volver") print_message "Volver al menú anterior" "$COLOR_PRIMARY" ;;
    "0 - Salir") print_message "Salir de TrUs" "$COLOR_PRIMARY" ;;
    *) echo "TODO" ;;
    esac
}

main_menu_help() {
    local option=$1

    case "$option" in
    1)
        print_message "Configurar" "$COLOR_PRIMARY"
        print_message "Aqui se puede instalar los paquetes necesarios para truedat, generar diferentes archivos de configuracón, personalizar TrUs y el equipo, etc" "$COLOR_SECONDARY"
        ;;
    2)
        print_message "Acciones principales" "$COLOR_PRIMARY"
        print_message "Aqui se realizan las acciones importantes: Arrancar y matar Truedat, actualizar repos, bajar backups de bdd, etc" "$COLOR_SECONDARY"
        ;;
    3)
        print_message "Actiones secundarias" "$COLOR_PRIMARY"
        print_message "Aqui se realizan otras acciones, no tan importantes, pero necesarias: Reindexar Elastic, Crear claves ssh, configurar el uso de Kong en el equipo, linkar paquetes web, etc" "$COLOR_SECONDARY"
        ;;
    4)
        print_message "Ayuda" "$COLOR_PRIMARY"
        print_message "Aqui se muestra toda la ayuda de todas las opciones disponibles en Trus (incluidos parámetros para realizar acciones desde script)" "$COLOR_SECONDARY"
        ;;
    *)

        print_semiheader "Opciones Menú Principal"
        print_message "Configurar" "$COLOR_PRIMARY"
        print_message "Aqui se puede instalar los paquetes necesarios para truedat, generar diferentes archivos de configuracón, personalizar TrUs y el equipo, etc" "$COLOR_SECONDARY"

        print_message "Acciones principales" "$COLOR_PRIMARY"
        print_message "Aqui se realizan las acciones importantes: Arrancar y matar Truedat, actualizar repos, bajar backups de bdd, etc" "$COLOR_SECONDARY"

        print_message "Actiones secundarias" "$COLOR_PRIMARY"
        print_message "Aqui se realizan otras acciones, no tan importantes, pero necesarias: Reindexar Elastic, Crear claves ssh, configurar el uso de Kong en el equipo, linkar paquetes web, etc" "$COLOR_SECONDARY"

        print_message "Ayuda" "$COLOR_PRIMARY"
        print_message "Aqui se muestra toda la ayuda de todas las opciones disponibles en Trus (incluidos parámetros para realizar acciones desde script)" "$COLOR_SECONDARY"
        ;;

    esac
}

animation_menu_help() {
    local animation=$1
    local frames_var="TERMINAL_ANIMATION_${animation}"
    local frame_delay=0.1

    eval "local frames=(\"\${${frames_var}[@]}\")"

    for frame in "${frames[@]}"; do
        echo "$frame"
    done
}

# =================================================================================================
# ====== Otras operaciones importantes
# =================================================================================================

informe_pidi() {
    print_title
    print_semiheader "Generación de informe PiDi"
    print_message "IMPORTANTE Formato de fecha a introducir: YYYY-MM-DD" "$COLOR_WARNING" "both"

    while true; do
        print_message "Por favor, introduce una fecha de inicio (por defecto: 2020-01-01)"
        read informe_desde

        if validate_date "$informe_desde"; then
            break
        else
            print_message "La fecha introducida no es válida. Inténtalo de nuevo." "$COLOR_ERROR"
        fi
    done

    while true; do
        print_message "Por favor, introduce una fecha de fin (por defecto: 2032-12-31)"
        read informe_hasta

        if validate_date "$informe_hasta"; then
            break
        else
            print_message "La fecha introducida no es válida. Inténtalo de nuevo." "$COLOR_ERROR"
        fi
    done

    generar_informe_pidi "$informe_desde" "$informe_hasta"

    print_message "Informe generado con éxito" "$COLOR_SUCCESS"
    print_message "Archivo generado: $PIDI_FILE" "$COLOR_QUATERNARY"
}

generar_informe_pidi() {
    local desde=${1:-"2020-01-01"}
    local hasta=${2:-"2032-12-31"}
    local autor="$(git config user.email)"

    if [ ! -e "$PIDI_PATH" ]; then
        mkdir -p $PIDI_PATH
    fi

    touch "$PIDI_FILE"
    local header="commit;author;commit line 1;commit line 2;commit line 3;commit line 4;commit line 5;"

    for SERVICE in "${SERVICES[@]}"; do
        {
            echo ""
            echo "Commits de $SERVICE"
            echo ""
        } >>"$PIDI_FILE"

        cd "$BACK_PATH/$SERVICE"
        echo "$header" >>"$PIDI_FILE"

        git log --all --pretty=format:"%h - %an <%ae> - %s" \
            --since="$desde" \
            --until="$hasta" \
            --regexp-ignore-case |
            grep -i "$autor" |
            sed 's/ - /;/g' \
                >>"$PIDI_FILE"
    done

    for LIBRARY in "${LIBRARIES[@]}"; do
        {
            echo ""
            echo "Commits de $LIBRARY"
            echo ""
        } >>"$PIDI_FILE"

        cd "$BACK_PATH/$LIBRARY"
        echo "$header" >>"$PIDI_FILE"

        git log --all --pretty=format:"%h - %an <%ae> - %s" \
            --regexp-ignore-case |
            grep -i "$autor" |
            sed 's/ - /;/g' \
                >>"$PIDI_FILE"
    done

    {
        echo ""
        echo "Commits de td-web"
        echo ""
    } >>"$PIDI_FILE"

    cd "$FRONT_PATH/td-web"

    echo "$header" >>"$PIDI_FILE"

    git log --all --pretty=format:"%h - %an <%ae> - %s" \
        --regexp-ignore-case |
        grep -i "$autor" |
        sed 's/ - /;/g' \
            >>"$PIDI_FILE"

    {
        echo ""
        echo "Commits de td-web-modules"
        echo ""
    } >>"$PIDI_FILE"

    cd "$FRONT_PATH/td-web-modules"

    echo "$header" >>"$PIDI_FILE"

    git log --all --pretty=format:"%h - %an <%ae> - %s" \
        --regexp-ignore-case |
        grep -i "$autor" |
        sed 's/ - /;/g' \
            >>"$PIDI_FILE"

}

# =================================================================================================
# ====== Menus principales
# =================================================================================================

main_menu() {
    local option=$(print_menu "trus --help 'main_menu_help'" "${MAIN_MENU_OPTIONS[@]}")

    option=$(extract_menu_option "$option")

    case "$option" in
    1) configure_menu ;;
    2) principal_actions_menu ;;
    3) secondary_actions_menu ;;
    4) help ;;
    0)
        clear
        tput reset
        exit 0
        ;;
    esac
}

configure_menu() {
    local option=$(print_menu "trus --help 'configure_menu_help'" "${CONFIGURE_MENU_OPTIONS[@]}")

    option=$(extract_menu_option "$option")

    case "$option" in
    1) install_truedat ;;
    2)
        install_zsh
        zsh_config
        ;;
    3) configuration_files_menu ;;
    4) splash_loader ;;
    5) swap ;;
    6) animation_menu ;;
    7) config_colours_menu ;;
    0) main_menu ;;
    esac
}

configuration_files_menu() {
    local option=$(print_menu "trus --help 'configuration_files_menu_help'" "${CONFIGURATION_FILES_MENU_OPTIONS[@]}")

    option=$(extract_menu_option "$option")

    case "$option" in
    1) zsh_config ;;
    2) bash_config ;;
    3) bash_config "y" ;;
    4) tmux_config ;;
    5) tlp_config ;;
    6) hosts_config ;;
    7)
        zsh_config
        bash_config "y"
        tmux_config
        tlp_config
        hosts_config
        ;;
    0) configure_menu ;;
    esac
}

principal_actions_menu() {
    local option=$(print_menu "trus --help 'principal_actions_menu_help'" "${PRINCIPAL_ACTIONS_MENU_OPTIONS[@]}")

    option=$(extract_menu_option "$option")

    case "$option" in
    1) start_menu ;;
    2) kill_truedat ;;
    3) ddbb_menu ;;
    4) repo_menu ;;
    5) sessions_menu ;;
    0) main_menu ;;
    esac
}

start_menu() {
    local option=$(print_menu "trus --help 'start_menu_help'" "${START_MENU_OPTIONS[@]}")

    option=$(extract_menu_option "$option")

    case "$option" in
    1)
        trus -s
        ;;

    2)
        trus -sc
        ;;

    3)
        trus -ss
        ;;

    4)
        trus -sf
        ;;

    0)
        principal_actions_menu
        ;;
    esac
}

sessions_menu() {
    local option=$(print_menu "trus --help 'sessions_menu_help'" "${SESSIONS_MENU_OPTIONS[@]}")

    option=$(extract_menu_option "$option")

    case "$option" in
    1)
        trus --attach-tmux
        ;;

    2)
        trus --detach-tmux
        ;;

    3)
        trus --attach-screen
        ;;

    4)
        trus --detach-screen
        ;;

    0)
        secondary_actions_menu
        ;;
    esac
}

secondary_actions_menu() {
    local option=$(print_menu "trus --help 'secondary_actions_menu_help'" "${SECONDARY_ACTIONS_MENU_OPTIONS[@]}")

    option=$(extract_menu_option "$option")

    case "$option" in
    1)
        trus --reindex
        ;;

    2)
        trus --create-ssh
        ;;

    3)
        kong_menu
        ;;

    4)
        trus --link-modules
        ;;

    5)
        trus --rest
        ;;

    6)
        trus --load-structures
        ;;

    7)
        trus --load-linage
        ;;

    8)
        informe_pidi
        ;;

    0)
        main_menu
        ;;
    esac
}

local_backup_menu() {
    local backups=("0 - Volver" $(find "$DDBB_BASE_BACKUP_PATH" -mindepth 1 -type d -exec basename {} \;) "Otro...")

    local option=$(print_menu "trus --help 'local_backup_help'" "${backups[@]}")

    case "$option" in
    "0 - Volver")
        ddbb_menu
        ;;

    "Otro...")
        trus -d -lu
        ;;

    *)
        update_ddbb_from_backup "$DDBB_BASE_BACKUP_PATH/$option"
        ;;
    esac
}

clean_local_backup_menu() {
    local backups=("0 - Volver" $(find "$DDBB_BASE_BACKUP_PATH" -mindepth 1 -type d -exec basename {} \;) "Borrar todo")
    local option=$(print_menu "trus --help 'clean_local_backup_help'" "${backups[@]}")

    case "$option" in
    "0 - Volver")
        ddbb_menu
        ;;

    "Borrar todo")
        if [[ "$(print_question 'Se van a borrar todos los backups de $DDBB_BASE_BACKUP_PATH. ¿Continuar? ')" = "Y" ]]; then
            local files=${DDBB_BASE_BACKUP_PATH}"/*"

            for FILENAME in $files; do
                print_message_with_animation "Borrando backup -> $FILENAME" "$COLOR_TERNARY"
                rm -fr $FILENAME
                print_message "Backup $FILENAME Borrado" "$COLOR_SUCCESS"

            done

            print_message "Backups borrados" "$COLOR_SUCCESS" "both" "" "centered"
        fi
        ;;

    *)
        if [[ "$(print_question 'Se van a borrar el backup $DDBB_BASE_BACKUP_PATH/$option. ¿Continuar? ')" = "Y" ]]; then
            rm -fr $DDBB_BASE_BACKUP_PATH/$option
        fi
        ;;
    esac
}

ddbb_menu() {
    local option=$(print_menu "trus --help 'ddbb_menu_help'" "${DDBB_MENU_OPTIONS[@]}")

    option=$(extract_menu_option "$option")

    case "$option" in
    1)
        trus -d -d
        ;;

    2)
        trus -d -du
        ;;

    3)
        local_backup_menu
        ;;

    4)
        trus -d -lb
        ;;

    5)
        clean_local_backup_menu
        ;;

    6)
        trus -d -rc
        ;;

    0)
        main_menu
        ;;
    esac
}

repo_menu() {
    local option=$(print_menu "trus --help 'repo_menu_help'" "${REPO_MENU_OPTIONS[@]}")

    option=$(extract_menu_option "$option")

    case "$option" in

    1)
        trus --update-repos --all
        ;;

    2)
        trus --update-repos --back
        ;;

    3)
        trus --update-repos --front
        ;;

    4)
        trus --update-repos --libs
        ;;

    1)
        trus --update-repos --all
        ;;

    0) ;;
    esac
}

kong_menu() {
    local option=$(print_menu "trus --help 'kong_menu_help'" "${KONG_MENU_OPTIONS[@]}")

    option=$(extract_menu_option "$option")

    case "$option" in
    1)
        kong_routes
        ;;

    2)
        config_kong
        ;;

    0)
        secondary_menu
        ;;
    esac
}

# =================================================================================================
# ====== Enrutador de parámetros
# =================================================================================================

param_router() {
    local param1=$1
    local param2=$2
    local param3=$3
    local param4=$4
    local param5=$5
    local param6=$6
    local param7=$7
    local param8=$8
    local param9=$9

    if [ -z "$param1" ]; then
        print_logo
        sleep 0.5
        print_title
        main_menu
    else
        params=()
        case "$param1" in
        "-i" | "--install")
            install
            ;;

        "-s" | "--start")
            shift
            start_truedat "$@"
            ;;

        "-d" | "--ddbb")
            ddbb "$param2"
            ;;

        "-r" | "--reindex")
            reindex_all
            ;;

        "-k" | "--kill")
            kill_truedat
            ;;

        "-cs" | "--create-ssh")
            create_ssh $SSH_NAME
            ;;

        "-ur" | "--update-repos")
            update_repositories "$param2" "$param3"
            ;;

        "-l" | "--link-modules")
            link_web_modules
            ;;

        "-kr" | "--kong-routes")
            kong_routes
            ;;

        "-cl" | "--config_kong")
            config_kong
            ;;

        "-h" | "--help")
            help $param2
            ;;

        "-sc" | "--start-containers")
            start_containers
            ;;

        "--stop-containers")
            stop_docker
            ;;

        "-ss" | "--start-services")
            shift
            header="$param1"
            shift
            params_echo="${*}"
            start_services "$header" "$params_echo"
            ;;

        "-sf" | "--start-front")
            start_front "$param1"
            ;;

        "-ls" | "--load-structures")
            load_structures "$param2" "$param3"
            ;;

        "-ll" | "--load-linages")
            load_linages "$param2"
            ;;

        "--rest")
            do_api_call "$param2" "$param3" "$param4" "$param5" "$param6" "$param7" "$param8" "$param9"
            ;;

        "-cts" | "--create-tmux-session")
            start_tmux "$param2"
            ;;

        "-att" | "--attach-tmux")
            go_to_tmux_session "$param2"
            ;;

        "-dtt" | "--dettach-tmux")
            go_out_tmux_session
            ;;

        "-ats" | "--attach-screen")
            go_to_screen_session
            ;;

        "-dts" | "--dettach-screen")
            go_out_screen_session
            ;;

        "--help")
            help "$param2" "$param3"
            ;;

        "*")
            help
            ;;
        esac
    fi
}

# =================================================================================================
# ====== Lógica inicial
# =================================================================================================

if [ "$1" = "--lib" ]; then
    print_message "Modo libreria activado"
elif [[ "$0" == "./trus.sh" ]]; then
    install_trus
    set_terminal_config
    preinstallation
elif [ "$1" = "--help" ]; then
    help "$2" "$3" "$4"
else
    source shell-tools

    set_terminal_config

    param_router $*    
fi

# # print_message "cosas que antes habia y ahora no" "$color_primary"
# # print_message "- hacer los helps" "$color_secondary"
# # print_message "- funciones de ayuda" "$color_secondary"

# # print_message "cosas nuevas" "$color_primary"
# # print_message "- multi yarn test" "$color_secondary"
# # print_message "- añadir submenu al reindexado de elastic, para seleccionar qué indices se quiere reindexar" "$color_secondary"
# # print_message "- añadir submenu al arranque de todo/servicios de truedat, para seleccionar qué servicios se quiere arrancar" "$color_secondary"
# # print_message "- añadir submenu a la actualizacion de repos para seleccionar qué actualizar" "$color_secondary"
# # print_message "- añadir submenu a la descarga de bdd de test para seleccionar qué actualizar" "$color_secondary" "after"
