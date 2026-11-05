#!/bin/bash
echo "🔄 macOS Orijinal Ayarlarına Döndürülüyor..."

# 1. Reset Key Mapping
hidutil property --set '{"UserKeyMapping":[]}'
rm -f ~/Library/LaunchAgents/com.local.KeyMapping.plist

# 2. Reset Scroll Direction
defaults write -g com.apple.swipescrolldirection -bool true

# 3. Reset KeyBindings
rm -f ~/Library/KeyBindings/DefaultKeyBinding.dict

# 4. Reload preferences
killall cfprefsd 2>/dev/null || true
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true

echo "✓ Orijinal Apple fabrika ayarlarına başarıyla geri dönüldü."
