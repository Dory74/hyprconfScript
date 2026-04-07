#!/bin/bash

# --- Configuration ---
MONITOR_A="DP-1"
MONITOR_B="HDMI-A-1"
MONITOR_TO_FOCUS="$MONITOR_B"
# ---------------------

echo "--- Script Configuration ---"
echo "Monitor A: $MONITOR_A"
echo "Monitor B: $MONITOR_B"
echo "Monitor to Focus (Final Target): $MONITOR_TO_FOCUS"
echo "----------------------------"

# 1. Get workspace names AND monitor geometry
monitor_data=$(hyprctl monitors -j | jq -r '
  .[] | select(.name == "'"$MONITOR_A"'" or .name == "'"$MONITOR_B"'") |
  "\(.name) \(.activeWorkspace.name) \(.x) \(.y) \(.width) \(.height)"
')

# ... (Error checking and parsing remains the same) ...

# Parse the output to get the current workspace NAMES
WORKSPACE_NAME_A=$(echo "$monitor_data" | grep "$MONITOR_A" | awk '{print $2}')
WORKSPACE_NAME_B=$(echo "$monitor_data" | grep "$MONITOR_B" | awk '{print $2}')

# Parse the geometry for the monitor we intend to focus
FOCUS_GEOMETRY=($(echo "$monitor_data" | grep "$MONITOR_TO_FOCUS" | awk '{print $3, $4, $5, $6}'))
FOCUS_X=${FOCUS_GEOMETRY[0]}
FOCUS_Y=${FOCUS_GEOMETRY[1]}
FOCUS_W=${FOCUS_GEOMETRY[2]}
FOCUS_H=${FOCUS_GEOMETRY[3]}

if [ -z "$WORKSPACE_NAME_A" ] || [ -z "$WORKSPACE_NAME_B" ] || [ -z "$FOCUS_W" ]; then
    echo "Fatal Error: Failed to parse workspace names or monitor geometry. Cannot proceed." >&2
    exit 1
fi
echo "Workspace on $MONITOR_A is: $WORKSPACE_NAME_A"
echo "Workspace on $MONITOR_B is: $WORKSPACE_NAME_B"
echo "Geometry for Focus Monitor ($MONITOR_TO_FOCUS): X=$FOCUS_X Y=$FOCUS_Y W=$FOCUS_W H=$FOCUS_H"
echo "---------------------------"

# 2. Perform the Swap
echo "Swapping: $MONITOR_A (W: $WORKSPACE_NAME_A) <-> $MONITOR_B (W: $WORKSPACE_NAME_B)"
hyprctl dispatch moveworkspacetomonitor "$WORKSPACE_NAME_A $MONITOR_B"
hyprctl dispatch moveworkspacetomonitor "$WORKSPACE_NAME_B $MONITOR_A"

# 3. Force Display Update and Set Focus
echo "Forcing display update and setting focus..."
hyprctl dispatch workspace "$WORKSPACE_NAME_B"
hyprctl dispatch workspace "$WORKSPACE_NAME_A"
# hyprctl dispatch focusmonitor "$MONITOR_TO_FOCUS"

# 4. Position the Mouse Cursor
# Calculate the center coordinates of the focused monitor.
# CENTER_X=$((FOCUS_X + FOCUS_W / 2))
# CENTER_Y=$((FOCUS_Y + FOCUS_H / 2))

# *** CHECK THIS OUTPUT ***
echo "--- DEBUG MOUSE COORDINATES ---"
echo "Calculated Target Mouse Position (Global): $CENTER_X $CENTER_Y"
echo "-------------------------------"

# Use the 'cursorpos' dispatch to move the mouse
# hyprctl dispatch cursorpos "$CENTER_X $CENTER_Y"
hyprctl dispatch movecursor 3202 720

echo "--- Success ---"
# echo "Swap complete, focus set to $MONITOR_TO_FOCUS, and mouse centered on it."