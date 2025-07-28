#!/bin/bash

update() {
	if [ "$SID" = "$FOCUSED_WORKSPACE" ]; then
		SELECTED=true
	else
		SELECTED=false
	fi
	WIDTH="dynamic"
	if [ "$SELECTED" = "true" ]; then
		WIDTH="0"
	fi

	sketchybar --animate tanh 20 --set "$NAME" icon.highlight=$SELECTED label.width=$WIDTH
}

mouse_clicked() {
	aerospace workspace "$SID" 2>/dev/null
}

case "$SENDER" in
"mouse.clicked")
	mouse_clicked
	;;
*)
	update
	;;
esac
