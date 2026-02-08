#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetKeyDelay , 100, 50

j::          ; when 'j' is pressed
Send ^x      ; cut the selection
Send ^v      ; paste the selection
;Send ^+n     ; make a new layer (2.9)
Send ^k      ; hide the layer
Send {PgDn}  ; move layer selection down
Send ^+a     ; remove selection
return
