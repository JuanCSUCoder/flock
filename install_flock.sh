#!/usr/bin/env bash

echo Flock is being installed...

# 1. Pull docker image for Flock OpenCode environment
docker pull docker.io/juancsucoder/flock_env:latest

# 2. Extract flock

# Define output path
TARGET_DIR="/bin" # Or /usr/local/bin for system-wide (requires sudo)
TARGET_FILE="$TARGET_DIR/flock"

# Ensure the destination directory exists
sudo mkdir -p "$TARGET_DIR"

# Write the inner script content
sudo bash -c "cat << 'EOF' > "$TARGET_FILE"
#!/usr/bin/env bash

if [ -z \"\$1\" ]; then
    echo \"Error: You need to define the agent name as the first argument.\"
    exit 1
fi

mkdir -p .opencode/worktrees
touch .opencode/worktrees/.gitkeep

# Define target file and line content
FILE=\".gitignore\"
LINE=\".opencode/worktrees/*\"

# Ensure the target file exists
touch \"\$FILE\"

# Check if the line exists (using -F for fixed string matching, -x for exact line matching)
if ! grep -Fq -x \"\$LINE\" \"\$FILE\"; then
    echo \"\$LINE\" >> \"\$FILE\"
    echo \"Line added to gitignore.\"
else
    echo \"Verifying gitignore...\"
fi

# Define target file and line content
FILE=\".gitignore\"
LINE=\"!.opencode/worktrees/.gitkeep\"

# Ensure the target file exists
touch \"\$FILE\"

# Check if the line exists (using -F for fixed string matching, -x for exact line matching)
if ! grep -Fq -x \"\$LINE\" \"\$FILE\"; then
  echo \"\$LINE\" >> \"\$FILE\"
  echo \"Line added to gitignore.\"
else
  echo \"Gitignore already configured for worktrees. No changes made.\"
fi

git worktree add .opencode/worktrees/agent-\$1 -b feature/agent-\$1

cd .opencode/worktrees/agent-\$1

docker run -it --rm \
  -v ~/.config/opencode:/root/.config/opencode \
  -v \"\$(pwd):/worktree\" \
  -v \"\$(pwd)/../../../.git:\$(pwd)/../../../.git\" \
  -v \"~/.local/share/opencode:/root/.local/share/opencode\" \
  docker.io/juancsucoder/flock_env:latest --prompt \"You are now working in a new worktree for agent-\$1 located in /worktree. Modify the code as needed and commit your changes during the process. Also, when you're done, make a final commit to finalize your work. These are the guidelines, don't start working yet, wait for the user to give you instructions. When you finish, write a skill with the guidelines and structure you used to solve the task and make a commit.\"

EOF"

# 3. Grant execution permissions
sudo chmod +x "$TARGET_FILE"

# Install complete

echo "Flock was installed successfully at $TARGET_FILE"
