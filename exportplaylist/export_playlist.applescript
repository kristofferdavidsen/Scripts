property playListName : "Music"
on run argv
	set errorCode to 0 as integer
	set myInput to item 1 of argv
	set outputFile to ((path to me as text) & myInput & ".txt")
	
	set aText to ""
	set {aNameMaximum, artistMaximum} to {0, 0}
	
	tell application "Music"
		try
			set theTracks to every track in playlist myInput
			
			-- Get max lengths for each prop
			repeat with aTrack in theTracks
				set aNameLength to length of (get name of aTrack)
				if aNameLength > aNameMaximum then set aNameMaximum to aNameLength
				set artistLength to length of (get artist of aTrack)
				if artistLength > artistMaximum then set artistMaximum to artistLength
			end repeat
			
			-- build the body
			repeat with aTrack in theTracks
				-- name
				set namePlaceholder to (get name of aTrack)
				repeat while (length of namePlaceholder) < aNameMaximum
					set namePlaceholder to namePlaceholder & space
				end repeat
				set aText to aText & namePlaceholder & " | "
				-- artist
				set artistPlaceholder to (get artist of aTrack)
				repeat while (length of artistPlaceholder) < artistMaximum
					set artistPlaceholder to artistPlaceholder & space
				end repeat
				set aText to aText & artistPlaceholder & " | "
				-- duration
				set aDuration to (get duration of aTrack) as integer
				set aDuration to my convertTime(aDuration)
				set aText to aText & aDuration & " | "
				-- number of plays
				set aPlays to (get played count of aTrack as string)
				set aText to aText & aPlays & return
			end repeat
		on error
			set errorCode to 1 as integer
		end try
	end tell
	
	try
		set fileReference to open for access file outputFile with write permission
		set eof of fileReference to 0
		write aText to fileReference
		close access fileReference
	on error
		try
			close access outputFile
		end try
	end try
	return errorCode
end run

on convertTime(tis)
	set timeSecs to tis mod 60
	set timeMins to tis div 60
	set timeHours to timeMins div 60 as string
	set timeMins to timeMins mod 60
	if length of timeHours is 1 then
		set timeHours to "0" & timeHours
	end if
	timeHours & ":" & characters -2 thru -1 of ("00" & timeMins as string) & ":" & Â
		characters -2 thru -1 of ("00" & timeSecs as string) as string
end convertTime


