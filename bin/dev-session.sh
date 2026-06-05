#!/usr/bin/env bash

SESSION="dev"

tmux has-session -t "$SESSION" 2>/dev/null
if [ $? -eq 0 ]; then
  tmux attach -t "$SESSION"
  exit 0
fi

tmux new-session -d -s "$SESSION"

# Step 1: split vertically (top/bottom)
tmux split-window -v -t "$SESSION"

# Step 2: split the TOP pane horizontally
tmux select-pane -t 0
tmux split-window -h

# Rename panes (optional)
tmux select-pane -t 0 -T "nvim"
tmux select-pane -t 1 -T "lazygit"
tmux select-pane -t 2 -T "agent"

# Start tools
tmux send-keys -t 0 "nvim ." C-m
tmux send-keys -t 1 "lazygit" C-m
tmux send-keys -t 2 "claude-code" C-m

tmux select-pane -t 0
tmux attach -t "$SESSION"
