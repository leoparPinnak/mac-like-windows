#!/bin/bash
set -e

echo "🚀 macOS Windows-Style Keyboard & Mouse Setup Başlatılıyor..."

# 1. Scroll Direction (Windows Mouse Scroll)
echo "▸ [1/4] Scroll yönü Windows stiline ayarlanıyor (Natural Scrolling -> Kapalı)..."
defaults write -g com.apple.swipescrolldirection -bool false

# 2. Key Mapping (hidutil)
# Left Ctrl -> Command, Right Ctrl -> Command, Left Option -> Control
echo "▸ [2/4] Ctrl ve Command tuşları Windows kas hafızasına göre eşleniyor..."
hidutil property --set '{"UserKeyMapping":[
  {"HIDKeyboardModifierMappingSrc":0x7000000E0,"HIDKeyboardModifierMappingDst":0x7000000E3},
  {"HIDKeyboardModifierMappingSrc":0x7000000E4,"HIDKeyboardModifierMappingDst":0x7000000E7},
  {"HIDKeyboardModifierMappingSrc":0x7000000E2,"HIDKeyboardModifierMappingDst":0x7000000E0}
]}'

# 3. Permanent LaunchAgent
echo "▸ [3/4] Yeniden başlatmalarda ayarların korunması için LaunchAgent oluşturuluyor..."
mkdir -p ~/Library/LaunchAgents
cat << 'EOF' > ~/Library/LaunchAgents/com.local.KeyMapping.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.KeyMapping</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":30064771296,"HIDKeyboardModifierMappingDst":30064771299},{"HIDKeyboardModifierMappingSrc":30064771300,"HIDKeyboardModifierMappingDst":30064771303},{"HIDKeyboardModifierMappingSrc":30064771298,"HIDKeyboardModifierMappingDst":30064771296}]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# 4. Text Navigation (Home, End, Shift+Home, Shift+End)
echo "▸ [4/4] Home ve End tuşları Windows satır başı/sonu davranışına ayarlanıyor..."
mkdir -p ~/Library/KeyBindings
cat << 'EOF' > ~/Library/KeyBindings/DefaultKeyBinding.dict
{
    /* Home / End (Satır başı / Satır sonu) */
    "\UF729"  = "moveToBeginningOfLine:";
    "\UF72B"  = "moveToEndOfLine:";
    "$\UF729" = "moveToBeginningOfLineAndModifySelection:";
    "$\UF72B" = "moveToEndOfLineAndModifySelection:";

    /* Shift + Home / End seçimi */
    "^$\UF729" = "moveToBeginningOfDocumentAndModifySelection:";
    "^$\UF72B" = "moveToEndOfDocumentAndModifySelection:";
}
EOF

# 5. Reload preferences
killall cfprefsd 2>/dev/null || true
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true

echo "✓ Başarılı! Mac artık tamamen Windows klavye, kısayol ve fare düzeniyle çalışıyor."
