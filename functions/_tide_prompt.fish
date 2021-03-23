function _tide_prompt
    # Variables are exported as strings, convert _tide_last_pipestatus back into a list
    set -g _tide_last_pipestatus (string split ' ' $_tide_last_pipestatus)

    test "$tide_print_newline_before_prompt" = true && printf '%b' '\n'

    set -l leftPrompt (_tide_left_prompt)
    set -l leftPromptHeight (count $leftPrompt)
    set -l rightPrompt (_tide_right_prompt)

    if test $leftPromptHeight = 2
        if test "$tide_left_prompt_frame_enabled" = true
            set -l frameColor (set_color $tide_left_prompt_frame_color -b normal || echo)
            set leftPrompt[1] $frameColor╭─"$leftPrompt[1]"
            set leftPrompt[2] $frameColor╰─"$leftPrompt[2]"
        end
        if test "$tide_right_prompt_frame_enabled" = true
            set -l frameColor (set_color $tide_right_prompt_frame_color -b normal || echo)
            set rightPrompt[1] "$rightPrompt[1]"$frameColor─╮
            set rightPrompt[2] "$rightPrompt[2]"$frameColor─╯
        end

        printf '%s' $leftPrompt[1]

        set_color $tide_prompt_connection_color
        set -l lengthToMove (math $COLUMNS - (_tide_decolor "$leftPrompt[1]""$rightPrompt[1]" | string length) - 1)
        test $lengthToMove -lt 0 && set lengthToMove 0
        # String pad with escapes mimics string repeat
        string pad --width $lengthToMove --char=$tide_prompt_connection_icon "$rightPrompt[1]"\e
    end

    set -U $_tide_right_prompt_display_var $rightPrompt[$leftPromptHeight]
    printf '%s' $leftPrompt[-1]' '
end
