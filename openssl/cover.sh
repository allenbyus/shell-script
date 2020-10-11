#How to Convert Your Certificates and Keys to PEM Using OpenSSL
#There are four basic ways to manipulate certificates — you can view, transform, combine, or extract them. To transform one type of encoded certificate to another — such as converting CRT to PEM, CER to PEM, and DER to PEM — you’ll want to use the following commands:

#OpenSSL: Convert CRT to PEM:
#Type the following code into your OpenSSL client:

openssl x509 -in cert.crt -out cert.pem

#OpenSSL: Convert CER to PEM
openssl x509 -in cert.cer -out cert.pem

#OpenSSL: Convert DER to PEM
openssl x509 -in cert.der -out cert.pem

#You can also use similar commands to convert PEM files to these different types of files as well. Furthermore, there are additional parameters you can specify in your command — such as -inform and -outform — but the above examples are the basic, bare bones OpenSSL commands.
#Haven’t purchased your x.509 certificate? Get your certificates from the leading certificate authorities (CA) at the best prices — guaranteed.
