[名前]
.\"O md5sum \- compute and check MD5 message digest
md5sum \- MD5 メッセージダイジェストの計算と照合を行う
[説明]
.\" Add any additional description here
.\"O [BUGS]
[バグ]
.\"O Do not use the MD5 algorithm for security related purposes.
.\"O Instead, use an SHA\-2 algorithm, implemented in the programs
.\"O sha224sum(1), sha256sum(1), sha384sum(1), sha512sum(1),
.\"O or the BLAKE2 algorithm, implemented in b2sum(1)
セキュリティ関連の目的では MD5 アルゴリズムは使用しないこと。
代わりに、SHA\-2 アルゴリズムか BLAKE2 アルゴリズムを使用すること。
SHA\-2 アルゴリズムは sha224sum(1), sha256sum(1), sha384sum(1), sha512sum(1)
プログラムで実装されています。
BLAKE2 アルゴリズムは b2sum(1) で実装されています。
