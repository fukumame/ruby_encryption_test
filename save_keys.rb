require 'openssl'

# 引数は鍵のサイズ
rsa = OpenSSL::PKey::RSA.generate(2048)

# 秘密鍵を暗号化するためのパスワード
passphrase = "!secret passphrase!"

# 秘密鍵の出力
private_key = rsa.export
puts private_key

# 秘密鍵を暗号化して出力
encrypted_private_key = rsa.export(OpenSSL::Cipher.new("aes256"), passphrase)
puts encrypted_private_key

# 出力した秘密鍵(暗号化済)をファイルに書き込み
File.open("./private_key.pem", "w") do |f|
  f.write(encrypted_private_key)
end

# 公開鍵をpublic_key.pemに保存
public_key = rsa.public_key
File.open("public_key.pem", "w") do |f|
  f.write(public_key.export)
end