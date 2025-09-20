import os
import time
import re
import requests
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# --- Configuration ---

# 1. Discord webhook URLs for each category
WEBHOOK_URLS = {
    'Local Chat':       'CHANGEME',
    'Groups':          'CHANGEME',
    'Conferences':      'CHANGEME',
    'Instant Messages': 'CHANGEME'
}

# 2. List of viewer folders to monitor within %APPDATA%
VIEWER_FOLDERS = [
    "Firestorm_x64",
    "Firestorm_x64_OLD",
    "Firestorm",
    "SecondLife",
    "Second-Life",
    "Radegast"
]

# 3. Set the root directory using the %APPDATA% environment variable
appdatalocation = os.path.expandvars('%APPDATA%')

# --- Helper Functions ---

def get_file_category_and_info(file_path):
    """
    Categorizes a log file based on its name and extracts relevant info.
    Returns a tuple: (category, info).
    """
    filename = os.path.basename(file_path)

    if filename.lower() == 'chat.txt':
        return ('Local Chat', None)

    if '(group)' in filename.lower():
        # Extract group name, which is everything before "(group)"
        # This handles filenames like "Misfit_s (group) (group).txt"
        group_name = re.split(r'\(group\)', filename, flags=re.IGNORECASE)[0].strip()
        return ('Groups', group_name)

    if 'conference' in filename.lower():
        # Extract conference starter, which is everything before "Conference"
        # This handles potential extra characters like underscores
        starter_name = re.split(r'conference', filename, flags=re.IGNORECASE)[0].strip()
        return ('Conferences', starter_name)

    # Any other .txt file is treated as an Instant Message
    # The name is the filename without the .txt extension
    im_name = os.path.splitext(filename)[0]
    return ('Instant Messages', im_name)

def get_username_from_path(file_path, base_paths):
    """
    Extracts the avatar's username from the file path. The username is the
    folder name immediately following the main viewer folder.
    """
    # Normalize path separators for consistent splitting
    normalized_path = file_path.replace(os.sep, '/')
    path_parts = normalized_path.split('/')

    for base_path in base_paths:
        try:
            viewer_folder = os.path.basename(base_path)
            if viewer_folder in path_parts:
                index = path_parts.index(viewer_folder)
                if index + 1 < len(path_parts):
                    return path_parts[index + 1] # The username is the next part
        except ValueError:
            continue
    return "unknown_user"

def send_to_discord(category, message):
    """Sends a formatted message to the appropriate Discord webhook."""
    webhook_url = WEBHOOK_URLS.get(category)
    if not webhook_url:
        print(f"Error: No webhook URL configured for category '{category}'")
        return

    payload = {'content': message}
    try:
        response = requests.post(webhook_url, json=payload, timeout=10)
        response.raise_for_status() # Raise an exception for HTTP errors
        print(f"Successfully sent to {category}: {message}")
    except requests.exceptions.RequestException as e:
        print(f"Error sending message to {category} webhook: {e}")

# --- File System Event Handler ---

class LogFileEventHandler(FileSystemEventHandler):
    """
    Reacts to file system events (creation, modification) for log files.
    """
    def __init__(self, watch_paths):
        self.last_lines = {} # Stores the last processed line for each file
        self.watch_paths = watch_paths

    def process(self, event):
        """Processes a file event to send the last line to Discord."""
        # Ignore directories and non-text files
        if event.is_directory or not event.src_path.lower().endswith('.txt'):
            return

        file_path = event.src_path
        
        # Read the last non-empty line from the file
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                lines = [line for line in f.read().splitlines() if line.strip()]
                if not lines:
                    return # File is empty or contains only whitespace
                last_line = lines[-1]
        except Exception as e:
            print(f"Could not read file {file_path}: {e}")
            return

        # Avoid sending duplicate messages by checking against the last sent line
        if self.last_lines.get(file_path) == last_line:
            return
            
        self.last_lines[file_path] = last_line

        # Get context: username, category, and specific info (group name, etc.)
        username = get_username_from_path(file_path, self.watch_paths)
        category, info = get_file_category_and_info(file_path)
        
        # Format the message payload according to the specified requirements
        if category == 'Groups':
            formatted_message = f"[{username}]: [{info}] {last_line}"
        elif category == 'Conferences':
            formatted_message = f"[{username}]: [{info} Conference] {last_line}"
        elif category == 'Instant Messages':
            # Create a clear and consistent format for IMs
            formatted_message = f"[{username}]: [IM with {info}] {last_line}"
        else: # Local Chat
            formatted_message = f"[{username}]: {last_line}"

        # Send the final message to the correct Discord channel
        send_to_discord(category, formatted_message)

    def on_modified(self, event):
        self.process(event)

    def on_created(self, event):
        self.process(event)

# --- Main Execution Block ---

if __name__ == "__main__":
    print("Starting log file monitor... 💻")
    
    # Identify all valid viewer directories that exist on the system
    paths_to_watch = []
    for folder in VIEWER_FOLDERS:
        path = os.path.join(appdatalocation, folder)
        if os.path.isdir(path):
            paths_to_watch.append(path)
            print(f"✔️ Monitoring directory: {path}")

    if not paths_to_watch:
        print("❌ Error: No valid viewer directories found to monitor. Exiting.")
        exit()

    # Set up and start the file system observer
    event_handler = LogFileEventHandler(paths_to_watch)
    observer = Observer()
    for path in paths_to_watch:
        observer.schedule(event_handler, path, recursive=True)
    
    observer.start()
    print("\n🚀 Monitoring started. Press Ctrl+C to stop.")

    try:
        # Keep the script running until manually stopped
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n🛑 Stopping monitor...")
        observer.stop()
    
    observer.join()
    print("Monitor stopped successfully.")
