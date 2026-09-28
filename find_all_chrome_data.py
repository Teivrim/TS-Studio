import os
import json
import sqlite3
import shutil

user_data_path = os.path.join(os.environ['LOCALAPPDATA'], 'Google', 'Chrome', 'User Data', 'Default')

# Check Preferences file for saved passwords or login data
prefs_path = os.path.join(user_data_path, 'Preferences')
if os.path.exists(prefs_path):
    with open(prefs_path, 'r', encoding='utf-8') as f:
        prefs = json.load(f)
    
    # Look for login data
    if 'profile' in prefs:
        profile = prefs['profile']
        if 'name' in profile:
            print(f"Profile name: {profile['name']}")
    
    # Check for saved passwords in preferences
    if 'password_manager' in prefs:
        print(f"Password manager settings found")
    
    # Check for account info
    if 'account_info' in prefs:
        accounts = prefs['account_info']
        print(f"Account info: {json.dumps(accounts, indent=2)}")
    
    # Check for signin
    if 'signin' in prefs:
        print(f"Signin settings: {json.dumps(prefs['signin'], indent=2)}")

# Check Login Data for all profiles
login_data_path = os.path.join(user_data_path, 'Login Data')
if os.path.exists(login_data_path):
    temp_db = os.path.join(os.environ['TEMP'], 'chrome_login_all.db')
    shutil.copy2(login_data_path, temp_db)
    
    conn = sqlite3.connect(temp_db)
    cursor = conn.cursor()
    
    # Get all logins
    cursor.execute("""
        SELECT origin_url, username_value, password_value, date_created, date_password_modified
        FROM logins 
        ORDER BY date_created DESC
    """)
    
    rows = cursor.fetchall()
    print(f"\n=== All saved logins ({len(rows)}) ===")
    for url, username, password, date_created, date_modified in rows:
        print(f"  URL: {url}")
        print(f"  Username: {username}")
        print(f"  Password length: {len(password)} bytes")
        print(f"  Created: {date_created}")
        print(f"  Modified: {date_modified}")
        print()
    
    conn.close()
    os.remove(temp_db)

# Check Web Data for autofill
web_data_path = os.path.join(user_data_path, 'Web Data')
if os.path.exists(web_data_path):
    temp_db = os.path.join(os.environ['TEMP'], 'chrome_web_all.db')
    shutil.copy2(web_data_path, temp_db)
    
    conn = sqlite3.connect(temp_db)
    cursor = conn.cursor()
    
    # Get autofill data
    cursor.execute("""
        SELECT name, value, date_created
        FROM autofill
        WHERE value != ''
        ORDER BY date_created DESC
        LIMIT 50
    """)
    
    rows = cursor.fetchall()
    print(f"\n=== Autofill data ({len(rows)} items) ===")
    for name, value, date_created in rows:
        print(f"  {name}: {value[:100]}")
    
    conn.close()
    os.remove(temp_db)
