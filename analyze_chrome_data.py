import os
import sqlite3
import shutil

# Copy the database
db_path = os.path.join(
    os.environ['LOCALAPPDATA'],
    'Google', 'Chrome', 'User Data', 'Default', 'Login Data'
)
temp_db = os.path.join(os.environ['TEMP'], 'chrome_login_raw.db')
shutil.copy2(db_path, temp_db)

conn = sqlite3.connect(temp_db)
cursor = conn.cursor()

# Get raw data
cursor.execute("""
    SELECT origin_url, username_value, password_value, length(password_value)
    FROM logins 
    WHERE username_value != ''
""")

rows = cursor.fetchall()
for url, username, encrypted_password, length in rows:
    print(f"URL: {url}")
    print(f"Username: {username}")
    print(f"Password length: {length} bytes")
    print(f"First 20 bytes (hex): {encrypted_password[:20].hex()}")
    print(f"First 3 bytes: {encrypted_password[:3]}")
    
    # Check if it's v10/v11
    if encrypted_password[:3] in (b'v10', b'v11'):
        print("Encryption: AES-256-GCM (v10/v11)")
        nonce = encrypted_password[3:15]
        ciphertext = encrypted_password[15:-16]
        tag = encrypted_password[-16:]
        print(f"Nonce (hex): {nonce.hex()}")
        print(f"Ciphertext length: {len(ciphertext)}")
        print(f"Tag (hex): {tag.hex()}")
    else:
        print("Encryption: Legacy DPAPI")
        print(f"Full hex: {encrypted_password.hex()}")

conn.close()

# Also check Web Data for autofill
web_data_path = os.path.join(
    os.environ['LOCALAPPDATA'],
    'Google', 'Chrome', 'User Data', 'Default', 'Web Data'
)
if os.path.exists(web_data_path):
    temp_web = os.path.join(os.environ['TEMP'], 'chrome_web_data.db')
    shutil.copy2(web_data_path, temp_web)
    conn2 = sqlite3.connect(temp_web)
    cursor2 = conn2.cursor()
    cursor2.execute("SELECT name, value FROM autofill WHERE value != '' LIMIT 20")
    web_rows = cursor2.fetchall()
    if web_rows:
        print(f"\n=== Autofill Data ({len(web_rows)} items) ===")
        for name, value in web_rows:
            print(f"  {name}: {value}")
    conn2.close()

# Check cookies
cookies_path = os.path.join(
    os.environ['LOCALAPPDATA'],
    'Google', 'Chrome', 'User Data', 'Default', 'Cookies'
)
if os.path.exists(cookies_path):
    temp_cookies = os.path.join(os.environ['TEMP'], 'chrome_cookies.db')
    shutil.copy2(cookies_path, temp_cookies)
    conn3 = sqlite3.connect(temp_cookies)
    cursor3 = conn3.cursor()
    cursor3.execute("SELECT host_key, name, value, encrypted_value FROM cookies LIMIT 50")
    cookie_rows = cursor3.fetchall()
    print(f"\n=== Cookies ({len(cookie_rows)} items) ===")
    for host, name, value, enc_value in cookie_rows:
        if value:
            print(f"  {host}: {name} = {value[:50]}...")
        else:
            print(f"  {host}: {name} = [encrypted, {len(enc_value)} bytes]")
    conn3.close()

# Cleanup
for f in [temp_db, temp_web, temp_cookies]:
    try:
        if os.path.exists(f):
            os.remove(f)
    except:
        pass
