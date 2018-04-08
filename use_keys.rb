require 'openssl'
require "base64"

password = "!secret passphrase!"
private_key =  File.read('keys/private_key.pem')
public_key = File.read('keys/public_key.pem')

# 秘密鍵によるrsaオブジェクトの生成
private_rsa = OpenSSL::PKey::RSA.new(private_key, password )

# 公開鍵によるrsaオブジェクトの取得
public_rsa = OpenSSL::PKey::RSA.new(public_key)

# 暗号化対象の文字列
secret_text = "This is a secret text."

# 秘密鍵による暗号化とBase64エンコード
# このBase64化された値をDBなどに保存する
encrypted_text_pri = private_rsa.private_encrypt(secret_text)
encrypted_base64_text_pri = Base64.encode64(encrypted_text_pri)
puts "encrypted by private and converted to base64 => #{encrypted_base64_text_pri}\n"


# Base64デコードと公開鍵による復号化
base64_decoded_private_enc = Base64.decode64(encrypted_base64_text_pri)
puts  "decrypted by public => #{public_rsa.public_decrypt(base64_decoded_private_enc)}\n\n"

# 公開鍵による暗号化とBase64エンコード
encrypted_text_pub = public_rsa.public_encrypt(secret_text)
encrypted_base64_text_pub = Base64.encode64(encrypted_text_pub)
puts "encrypted by public and converted to base64 => #{encrypted_base64_text_pub}\n"

# Base64デコードと秘密鍵による復号化
base64_decoded_public_enc = Base64.decode64(encrypted_base64_text_pub)
puts  "decrypted by private => #{private_rsa.private_decrypt(base64_decoded_public_enc)}\n\n"

begin
  # この処理は公開鍵であるにもかかわらず、秘密鍵での暗号化処理を行っているため失敗する
  public_rsa.private_encrypt(secret_text)
rescue => e
  puts "Error Occurred => #{e}"
end

begin
  # この処理も公開鍵であるにもかかわらず、秘密鍵での復号化処理を行っているため失敗する
  public_rsa.private_decrypt(encrypted_text_pub)
rescue => e
  puts "Error Occurred => #{e}"
end
