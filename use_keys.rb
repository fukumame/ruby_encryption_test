require 'openssl'

password = "!secret passphrase!"
private_key =  File.read('private_key.pem')
public_key = File.read('public_key.pem')

# 秘密鍵によるrsaオブジェクトの生成
private_rsa = OpenSSL::PKey::RSA.new(private_key, password )

# 公開鍵によるrsaオブジェクトの取得
public_rsa = OpenSSL::PKey::RSA.new(public_key, password )

# 暗号化対象の文字列
secret_text = "This is a secret text."

# 秘密鍵による暗号化
encrypted_text_pri = private_rsa.private_encrypt(secret_text)
puts "encrypted by private => #{encrypted_text_pri}"

# 公開鍵による復号化
puts  "decrypted by public => #{public_rsa.public_decrypt(encrypted_text_pri)}"

# 公開鍵による暗号化
encrypted_text_pub = public_rsa.public_encrypt(secret_text)
puts "encrypted by public => #{encrypted_text_pub}"

# 秘密鍵による復号化
puts  "decrypted by private => #{private_rsa.private_decrypt(encrypted_text_pub)}"


begin
  # この処理は公開鍵であるにもかかわらず、秘密鍵での暗号化処理を行っているため失敗する
  public_rsa.private_encrypt(secret_text)

  # この処理も公開鍵であるにもかかわらず、秘密鍵での復号化処理を行っているため失敗する
  public_rsa.private_decrypt(encrypted_text_pub)
rescue => e
  puts "Error Occurred => #{e}"
end

