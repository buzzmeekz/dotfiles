#!/bin/bash
# Start DPP local development environment
# Opens iTerm2 with 4 tabs and starts redis in the background

DPP="$HOME/Code/dpp"

# Start redis in the background (daemonized)
echo "Starting redis-server..."
redis-server --daemonize yes

# Open iTerm2 with 4 tabs
osascript <<EOF
tell application "iTerm2"
  activate

  -- Tab 1: Rails server (bundle install, migrate, server)
  set newWindow to (create window with default profile)
  tell newWindow
    tell current session of current tab
      write text "cd $DPP/apps/rails && bundle install && rails db:migrate && rails data:migrate && rails server"
    end tell

    -- Tab 2: Rails JS (yarn install + yarn dev)
    set tab2 to (create tab with default profile)
    tell current session of tab2
      write text "cd $DPP/apps/rails && yarn install && yarn dev"
    end tell

    -- Tab 3: Web app (yarn install + yarn dev)
    set tab3 to (create tab with default profile)
    tell current session of tab3
      write text "cd $DPP/apps/web && yarn install && yarn dev"
    end tell

    -- Tab 4: Sidekiq
    set tab4 to (create tab with default profile)
    tell current session of tab4
      write text "cd $DPP/apps/rails && bundle exec sidekiq"
    end tell

    -- Tab 5: Docker + nginx
    set tab5 to (create tab with default profile)
    tell current session of tab5
      write text "cd $DPP && open -a Docker && echo 'Waiting for Docker to start...' && until docker info > /dev/null 2>&1; do sleep 1; done && docker compose up -d nginx"
    end tell
  end tell
end tell
EOF
