import os
import sqlite3
import shutil

# Firefox cookies
firefox_path = os.path.join(os.environ['APPDATA'], 'Mozilla', 'Firefox', 'Profiles')
profiles = os.listdir(firefox_path)

for profile in profiles:
    cookies_path = os.path.join(firefox_path, profile, 'cookies.sqlite')
    if not os.path.exists(cookies_path):
        continue
    
    temp_cookies = os.path.join(os.environ['TEMP'], 'firefox_cookies.db')
    shutil.copy2(cookies_path, temp_cookies)
    
    conn = sqlite3.connect(temp_cookies)
    cursor = conn.cursor()
    
    # Get all cookies for job-related sites
    cursor.execute("""
        SELECT host, name, value, path, expiry
        FROM moz_cookies
        WHERE host LIKE '%hh.ru%' 
           OR host LIKE '%rabota%'
           OR host LIKE '%career%'
           OR host LIKE '%avito%'
           OR host LIKE '%superjob%'
           OR host LIKE '%linkedin%'
           OR host LIKE '%yandex%'
        ORDER BY host
    """)
    
    rows = cursor.fetchall()
    if rows:
        print(f"=== Profile: {profile} ===")
        print(f"Found {len(rows)} cookies for job sites:\n")
        
        for host, name, value, path, expiry in rows:
            print(f"  Host: {host}")
            print(f"  Name: {name}")
            print(f"  Value: {value[:100] if value else '[empty]'}")
            print(f"  Path: {path}")
            print(f"  Expiry: {expiry}")
            print()
    
    conn.close()
    os.remove(temp_cookies)
