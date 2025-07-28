#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

SPACE_ICONS=(" " "" " " " " "󰙯" "󰀶 " "󰃰 " " " " ")

space=(
	icon.font="Hack Nerd Font:Bold:16.0"
	icon.padding_left=7
	icon.padding_right=7
	background.padding_left=2
	background.padding_right=2
	label.padding_right=20
	label.font="sketchybar-app-font:Regular:16.0"
	label.background.height=26
	label.background.drawing=on
	label.background.color="$SURFACE1"
	label.background.corner_radius=8
	label.drawing=off
	script="$PLUGIN_DIR/spaces/scripts/space.sh"
)

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
	sketchybar --add space space."$sid" left \
		--set space."$sid" associated_space="$sid" \
		icon="${SPACE_ICONS[sid]}" \
		icon.highlight_color="$(getRandomCatColor)" \
		"${space[@]}" \
		--subscribe space."$sid" mouse.clicked \
		--subscribe space."$sid" aerospace_workspace_change

done

spaces_bracket=(
	background.color="$SURFACE0"
	background.border_color="$SURFACE1"
	background.border_width=0
	background.drawing=on
)

sketchybar --add bracket spaces '/space\..*/' \
	--set spaces "${spaces_bracket[@]}"
