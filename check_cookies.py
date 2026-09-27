import os
import sqlite3
import shutil
import json

# Check cookies for job sites
user_data_path = os.path.join(os.environ['LOCALAPPDATA'], 'Google', 'Chrome', 'User Data')
cookies_path = os.path.join(user_data_path, 'Default', 'Cookies')

if not os.path.exists(cookies_path):
    print("Cookies file not found")
    exit()

temp_cookies = os.path.join(os.environ['TEMP'], 'chrome_cookies.db')
shutil.copy2(cookies_path, temp_cookies)

conn = sqlite3.connect(temp_cookies)
cursor = conn.cursor()

# Get all cookies for job-related sites
cursor.execute("""
    SELECT host_key, name, value, length(encrypted_value)
    FROM cookies
    WHERE host_key LIKE '%hh.ru%' 
       OR host_key LIKE '%rabota%'
       OR host_key LIKE '%career%'
       OR host_key LIKE '%avito%'
       OR host_key LIKE '%superjob%'
       OR host_key LIKE '%linkedin%'
       OR host_key LIKE '%yandex%'
    ORDER BY host_key
""")

rows = cursor.fetchall()
print(f"Found {len(rows)} cookies for job sites:\n")

for host, name, value, enc_len in rows:
    if value:
        print(f"  {host}: {name} = {value[:100]}")
    else:
        print(f"  {host}: {name} = [encrypted, {enc_len} bytes]")

conn.close()
os.remove(temp_cookies)
