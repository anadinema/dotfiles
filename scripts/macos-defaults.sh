# Script for restoring macos settings using defaults :)

# Close System Preferences, to prevent them from overriding settings we'll change

__settings_change_setup() {
	osascript -e 'tell application "System Preferences" to quit'
}

###############################################################################
# General UI/UX                                                               #
###############################################################################

__change_general_settings() {

	# Change wallpaper for mac
	# defaults write com.apple.wallpaper SystemWallpaperURL -string "file:///System/Library/Desktop%20Pictures/Light%20Stream%20Red.madesktop"

	# Disable the “Are you sure you want to open this application?” dialog
	defaults write com.apple.LaunchServices LSQuarantine -bool false

	# Always show scrollbars
	defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

	# Disable automatic termination of inactive apps
	defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

	# Reveal IP address, hostname, OS version, etc. when clicking the clock
	# in the login window
	# sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

	# Disable Notification Center and remove the menu bar icon
	# launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

	# Disable automatic capitalization as it’s annoying when typing code
	# defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

	# Disable smart dashes as they’re annoying when typing code
	# defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

	# Disable automatic period substitution as it’s annoying when typing code
	# defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

	# Disable smart quotes as they’re annoying when typing code
	# defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

	# Disable auto-correct
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

	# Disable Resume system-wide
	defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

	# Disable automatic termination of inactive apps
	defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

}


###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

__change_input_settings() {

	# Trackpad: enable tap to click for this user and for the login screen
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
	defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock -bool false
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool true

	# Trackpad: map bottom right corner to right-click
	# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
	# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
	# defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
	# defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

	# Disable “natural” scrolling
	defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

	# Increase sound quality for Bluetooth headphones/headsets
	# defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

	# Enable full keyboard access for all controls
	# (e.g. enable Tab in modal dialogs)
	defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

	# Set language and text formats
	# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
	# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
	# defaults write NSGlobalDomain AppleLanguages -array "en" "nl"
	# defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=EUR"
	# defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
	# defaults write NSGlobalDomain AppleMetricUnits -bool true

	# Show language menu in the top right corner of the boot screen
	sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool false

}


###############################################################################
# Finder                                                                      #
###############################################################################

__change_finder_settings() {

	# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
	defaults write com.apple.finder QuitMenuItem -bool false

	# Finder: disable window animations and Get Info animations
	# defaults write com.apple.finder DisableAllAnimations -bool true

	# Show icons for hard drives, servers, and removable media on the desktop
	defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
	defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
	defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
	defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

	# Finder: show hidden files by default
	# defaults write com.apple.finder AppleShowAllFiles -bool true

	# Finder: show all filename extensions
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true

	# Finder: new window target view type
	defaults write com.apple.finder NewWindowTarget -string "PfHm"

	# Finder: new window will be opened on this folder path
	defaults write com.apple.finder NewWindowTargetPath -string "file:///Users/anadinema/"

	# Finder: show status bar
	defaults write com.apple.finder ShowRecentTags -bool false
	defaults write com.apple.finder SidebarTagsSctionDisclosedState -bool true

	# Finder: show status bar
	defaults write com.apple.finder SidebarWidth -int 165

	# Finder: show status bar
	defaults write com.apple.finder ShowStatusBar -bool true

	# Finder: show path bar
	defaults write com.apple.finder ShowPathbar -bool true

	# Keep folders on top when sorting by name
	defaults write com.apple.finder _FXSortFoldersFirst -bool true

	# Defines the default group by for all folder
	# defaults write com.apple.finder FXPreferredGroupBy -string "Type"

	# When performing a search, search the current folder by default
	defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

	# Disable the warning when changing a file extension
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

	# Enable spring loading for directories
	defaults write NSGlobalDomain com.apple.springing.enabled -bool true

	# Remove the spring loading delay for directories
	defaults write NSGlobalDomain com.apple.springing.delay -float 0

	# Avoid creating .DS_Store files on network or USB volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

	# Disable disk image verification
	defaults write com.apple.frameworks.diskimages skip-verify -bool true
	defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
	defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

	# Automatically open a new Finder window when a volume is mounted
	# defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
	# defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
	# defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

	# Show item info near icons on the desktop and in other icon views
	# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
	# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
	# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

	# Show item info to the right of the icons on the desktop
	# /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

	# Enable snap-to-grid for icons on the desktop and in other icon views
	/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

	# Increase grid spacing for icons on the desktop and in other icon views
	# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 50" ~/Library/Preferences/com.apple.finder.plist
	# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 50" ~/Library/Preferences/com.apple.finder.plist
	# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 50" ~/Library/Preferences/com.apple.finder.plist

	# Use list view in all Finder windows by default
	# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
	defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

	# Disable the warning before emptying the Trash
	defaults write com.apple.finder WarnOnEmptyTrash -bool false

	# Enable AirDrop over Ethernet and on unsupported Macs running Lion
	# defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

	# Show the ~/Library folder
	chflags nohidden ~/Library

	# Show the /Volumes folder
	# sudo chflags nohidden /Volumes

	# Expand the following File Info panes:
	# “General”, “Open with”, and “Sharing & Permissions”
	defaults write com.apple.finder FXInfoPanesExpanded -dict \
		General -bool true \
		OpenWith -bool true \
		Privileges -bool true

}


###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

__change_dock_settings() {

	# Enable highlight hover effect for the grid view of a stack (Dock)
	defaults write com.apple.dock mouse-over-hilite-stack -bool true

	# Set the icon size of Dock items to 40 pixels
	defaults write com.apple.dock tilesize -int 40
	defaults write com.apple.dock magnification -int 1
	defaults write com.apple.dock largesize -int 101


	# Change minimize/maximize window effect
	# defaults write com.apple.dock mineffect -string "scale"

	# Minimize windows into their application’s icon
	defaults write com.apple.dock minimize-to-application -bool true

	# Enable spring loading for all Dock items
	defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

	# Show indicator lights for open applications in the Dock
	defaults write com.apple.dock show-process-indicators -bool true

	# Wipe all (default) app icons from the Dock
	# This is only really useful when setting up a new Mac, or if you don’t use
	# the Dock to launch apps.
	# defaults write com.apple.dock persistent-apps -array

	# Show only open applications in the Dock
	# defaults write com.apple.dock static-only -bool true

	# Don’t animate opening applications from the Dock
	defaults write com.apple.dock launchanim -bool false

	# Speed up Mission Control animations
	defaults write com.apple.dock expose-animation-duration -float 0.1

	# Don’t group windows by application in Mission Control
	# (i.e. use the old Exposé behavior instead)
	# defaults write com.apple.dock expose-group-by-app -bool false

	# Disable Dashboard
	# defaults write com.apple.dashboard mcx-disabled -bool true

	# Don’t show Dashboard as a Space
	# defaults write com.apple.dock dashboard-in-overlay -bool true

	# Put the dock on the left side
	defaults write com.apple.dock orientation -string "left"

	# Don’t automatically rearrange Spaces based on most recent use
	defaults write com.apple.dock mru-spaces -bool false

	# Remove the auto-hiding Dock delay
	defaults write com.apple.dock autohide-delay -float 0

	# Remove the animation when hiding/showing the Dock
	# defaults write com.apple.dock autohide-time-modifier -float 0

	# Automatically hide and show the Dock
	defaults write com.apple.dock autohide -bool true

	# Make Dock icons of hidden applications translucent
	defaults write com.apple.dock showhidden -bool true

	# Don’t show recent applications in Dock
	defaults write com.apple.dock show-recents -bool false

	# Disable the Launchpad gesture (pinch with thumb and three fingers)
	defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

	# Reset Launchpad, but keep the desktop wallpaper intact
	# find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

	# Add iOS & Watch Simulator to Launchpad
	# sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
	# sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

	# Add a spacer to the left side of the Dock (where the applications are)
	# defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
	# Add a spacer to the right side of the Dock (where the Trash is)
	# defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

	# Hot corners
	# Possible values:
	#  0: no-op
	#  2: Mission Control
	#  3: Show application windows
	#  4: Desktop
	#  5: Start screen saver
	#  6: Disable screen saver
	#  7: Dashboard
	# 10: Put display to sleep
	# 11: Launchpad
	# 12: Notification Center
	# 13: Lock Screen
	# Top left screen corner → Mission Control
	#defaults write com.apple.dock wvous-tl-corner -int 2
	#defaults write com.apple.dock wvous-tl-modifier -int 0
	# Top right screen corner → Desktop
	#defaults write com.apple.dock wvous-tr-corner -int 4
	#defaults write com.apple.dock wvous-tr-modifier -int 0
	# Bottom left screen corner → Start screen saver
	#defaults write com.apple.dock wvous-bl-corner -int 5
	#defaults write com.apple.dock wvous-bl-modifier -int 0

}


###############################################################################
# Energy saving                                                               #
###############################################################################

__change_energy_settings() {

	# Comment out the below line if any of the below commands are active
	echo ""

	# Enable lid wakeup
	# sudo pmset -a lidwake 1

	# Sleep the display in different cases
	# sudo pmset -b displaysleep 5 # When on battery
	# sudo pmset -c displaysleep 10 # When on charger

	# Disable machine sleep while charging
	# sudo pmset -c sleep 0

	# Set machine sleep in different cases
	# sudo pmset -b sleep 10 # When on battery
	# sudo pmset -c sleep 15 # When on charger

	# Set standby delay to 24 hours (default is 1 hour)
	# sudo pmset -a standbydelay 86400

	# Never go into computer sleep mode
	# sudo systemsetup -setcomputersleep Off > /dev/null

	# Hibernation mode
	# 0: Disable hibernation (speeds up entering sleep mode)
	# 3: Copy RAM to disk so the system state can still be restored in case of a
	#    power failure.
	# sudo pmset -a hibernatemode 0

	# Remove the sleep image file to save disk space
	# sudo rm /private/var/vm/sleepimage
	# Create a zero-byte file instead…
	# sudo touch /private/var/vm/sleepimage
	# …and make sure it can’t be rewritten
	# sudo chflags uchg /private/var/vm/sleepimage

}


###############################################################################
# Screen                                                                      #
###############################################################################

__change_screen_settings() {

	# Set scrrensaver idleTime to 3 minutes
	defaults -currentHost write com.apple.screensaver idleTime -int 180

	# Save screenshots to the Screenshots folder in Pictures
	if [ ! -d "$HOME"/Pictures/Screenshots ]; then
		mkdir -p $HOME/Pictures/Screenshots
	fi
	defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

	# Save screenshots in JPG format (other options: BMP, GIF, JPG, PDF, TIFF)
	defaults write com.apple.screencapture type -string "jpg"

	# Disable shadow in screenshots
	# defaults write com.apple.screencapture disable-shadow -bool true

	# Enable subpixel font rendering on non-Apple LCDs
	# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
	# defaults write NSGlobalDomain AppleFontSmoothing -int 1

	# Enable HiDPI display modes (requires restart)
	# sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

}


###############################################################################
# AltTab                                                                      #
###############################################################################

__change_alttab_settings() {

	# Enable automatic updates
	defaults write com.lwouis.alt-tab-macos SUAutomaticallyUpdate -bool true
	defaults write com.lwouis.alt-tab-macos SUEnableAutomaticChecks -bool true
	defaults write com.lwouis.alt-tab-macos updatePolicy -int 2

	# Hide thumbnails while switching apps
	defaults write com.lwouis.alt-tab-macos hideThumbnails -bool false

	# Change shortcut from option + tab to command + tab
	defaults write com.lwouis.alt-tab-macos holdShortcut -string "⌘"

	# Change menu bar icon
	defaults write com.lwouis.alt-tab-macos menubarIconShown -string false

	# Swtich windows on mouse hover
	# defaults write com.lwouis.alt-tab-macos mouseHoverEnabled -bool false

	# Show 6 windows in each row during switch
	defaults write com.lwouis.alt-tab-macos rowsCount -int 6

	# Set the theme to be of macos or windows (0 or 1 respectively)
	defaults write com.lwouis.alt-tab-macos theme -int 0

  # Set crash policy to never send any reports
  defaults write com.lwouis.alt-tab-macos crashPolicy -int 0

  # Show on the active screen
  defaults write com.lwouis.alt-tab-macos showOnScreen -int 0

	# Other appearance changes
	defaults write com.lwouis.alt-tab-macos appearanceSize -int 1
	defaults write com.lwouis.alt-tab-macos appearanceVisibility -int 0

  # Change the blacklist for apps to be ignored by AltTab
  # original_val holds the values which comes preinstalled, but doesn't appear in defaults output
  local original_val='{"hide":"1","bundleIdentifier":"com.McAfee.McAfeeSafariHost","ignore":"0"},{"hide":"2","ignore":"0","bundleIdentifier":"com.apple.finder"},{"ignore":"2","bundleIdentifier":"com.microsoft.rdc.macos","hide":"0"},{"hide":"0","ignore":"2","bundleIdentifier":"com.teamviewer.TeamViewer"},{"hide":"0","ignore":"2","bundleIdentifier":"org.virtualbox.app.VirtualBoxVM"},{"hide":"0","ignore":"2","bundleIdentifier":"com.parallels."},{"ignore":"2","hide":"0","bundleIdentifier":"com.citrix.XenAppViewer"},{"ignore":"2","bundleIdentifier":"com.citrix.receiver.icaviewer.mac","hide":"0"},{"hide":"0","bundleIdentifier":"com.nicesoftware.dcvviewer","ignore":"2"},{"bundleIdentifier":"com.vmware.fusion","ignore":"2","hide":"0"},{"hide":"0","ignore":"2","bundleIdentifier":"com.apple.ScreenSharing"},{"ignore":"2","bundleIdentifier":"com.utmapp.UTM","hide":"0"}'
  # additional_val holds the values which we want to add
  local additional_val='{"hide":"2","ignore":"0","bundleIdentifier":"com.nordvpn.macos"}'
  local stringified_val=''
  if [ -n $additional_val ]; then
    stringified_val="[$original_val,$additional_val]"
  else
    stringified_val="[$original_val]"
  fi
  # Apply the values
  defaults write com.lwouis.alt-tab-macos blacklist $(echo "'$stringified_val'")

}


###############################################################################
# Itsycal                                                                      #
###############################################################################

__change_itsycal_settings() {

	# Enable automatic updates
	defaults write com.mowglii.ItsycalApp SUEnableAutomaticChecks -bool true

  # Do not show the icon in menu bar
  defaults write com.mowglii.ItsycalApp HideIcon -bool true

  # Change the menu bar icon to itsycal icon, use if the HideIcon is not true
  # defaults write com.mowglii.ItsycalApp MenuBarIconType -int 3

  # Change other view preferences
  defaults write com.mowglii.ItsycalApp HighlightedDOWs -int 65
  defaults write com.mowglii.ItsycalApp SizePreference -int 1
  defaults write com.mowglii.ItsycalApp ShowEventDays -int 7
  defaults write com.mowglii.ItsycalApp ShowWeeks -bool true
  defaults write com.mowglii.ItsycalApp ClockFormat -string "'w.'w • E, MMM d"


}


###############################################################################
# Mail                                                                        #
###############################################################################

__change_mail_settings() {

	# Comment out the below line if any of the below commands are active
  echo ""

  # Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
	# defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

	# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
	# defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

	# Display emails in threaded mode, sorted by date (oldest at the top)
	# defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
	# defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
	# defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

	# Disable inline attachments (just show the icons)
	# defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

	# Disable automatic spell checking
	# defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

}


###############################################################################
# Time Machine                                                                #
###############################################################################

__change_time_machine_settings() {

	# Comment out the below line if any of the below commands are active
	echo ""

  # Prevent Time Machine from prompting to use new hard drives as backup volume
	# defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

	# Disable local Time Machine backups
	# hash tmutil &> /dev/null && sudo tmutil disablelocal

}


###############################################################################
# Activity Monitor                                                            #
###############################################################################

__change_activity_monitor_settings() {

	# Show the main window when launching Activity Monitor
	defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

	# Visualize CPU usage in the Activity Monitor Dock icon
	defaults write com.apple.ActivityMonitor IconType -int 5

	# Show all processes in Activity Monitor
	# defaults write com.apple.ActivityMonitor ShowCategory -int 0

	# Sort Activity Monitor results by CPU usage
	# defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
	# defaults write com.apple.ActivityMonitor SortDirection -int 0

}


###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

__change_other_mix_settings() {

	# Comment out the below line if any of the below commands are active
  echo ""

  # Enable the debug menu in Address Book
	# defaults write com.apple.addressbook ABShowDebugMenu -bool true

	# Enable Dashboard dev mode (allows keeping widgets on the desktop)
	# defaults write com.apple.dashboard devmode -bool true

	# Enable the debug menu in iCal (pre-10.8)
	# defaults write com.apple.iCal IncludeDebugMenu -bool true

	# Use plain text mode for new TextEdit documents
	# defaults write com.apple.TextEdit RichText -int 0
	# Open and save files as UTF-8 in TextEdit
	# defaults write com.apple.TextEdit PlainTextEncoding -int 4
	# defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

	# Enable the debug menu in Disk Utility
	# defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
	# defaults write com.apple.DiskUtility advanced-image-options -bool true

	# Auto-play videos when opened with QuickTime Player
	# defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

}


###############################################################################
# Mac App Store                                                               #
###############################################################################

__change_app_store_settings() {

	# Enable the WebKit Developer Tools in the Mac App Store
	# defaults write com.apple.appstore WebKitDeveloperExtras -bool true

	# Enable Debug Menu in the Mac App Store
	# defaults write com.apple.appstore ShowDebugMenu -bool true

	# Enable the automatic update check
	defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

	# Check for software updates daily, not just once per week
	# defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

	# Download newly available updates in background
	defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

	# Install System data files & security updates
	defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

	# Automatically download apps purchased on other Macs
	#defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

	# Turn on app auto-update
	defaults write com.apple.commerce AutoUpdate -bool true

	# Allow the App Store to reboot machine on macOS updates
	# defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

}


###############################################################################
# Photos                                                                      #
###############################################################################

__change_photos_settings() {

	# Prevent Photos from opening automatically when devices are plugged in
	defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

}


###############################################################################
# Kill affected applications                                                  #
###############################################################################

__kill_applications() {

	apps_list=(
		"Activity Monitor"
		"Calendar"
		"Dock"
		"Finder"
		"cfprefsd"
		"Contacts"
		"Dock"
		"Finder"
		"Photos"
		"Safari"
		"SystemUIServer"
		"AltTab"
    "Itsycal"
		"Calendar"
	)

	for app in $apps_list; do
		echo "Killing : $app"
		killall "$app" &> /dev/null || true
	done

}


#### Main function run call chain ####

if [ $RUN_DEFAULTS -eq 1 ]; then
	echo "$LINE\n ### Running defaults to restore settings for macos... ### \n$LINE"
	__settings_change_setup
	__change_general_settings
	__change_input_settings
	__change_finder_settings
	__change_dock_settings
	__change_energy_settings
	__change_screen_settings
	__change_alttab_settings
  __change_itsycal_settings
	__change_mail_settings
	__change_time_machine_settings
	__change_activity_monitor_settings
	__change_other_mix_settings
	__change_app_store_settings
	__change_photos_settings
	__kill_applications
	echo "$LINE\n ### Done. Might need a logout/restart for few changes to take effect ### \n$LINE"
else
	echo "$LINE\n ### Defaults set to not run... skipping the step... ### \n$LINE"
fi
