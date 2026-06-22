(* demo.sml - encode/decode and hash fixed inputs with each codec, printing
   deterministic output (RFC 4648 / 3174 / 6234 / CRC-32 vectors). Same output
   on every run and compiler (no RNG, no clock). *)

(* Base16 *)
val () = print "Base16 (RFC 4648):\n"
val () = print ("  encode \"foobar\" = " ^ Base16.encode "foobar" ^ "\n")
val () = print ("  decode roundtrip = "
                ^ (case Base16.decode (Base16.encode "foobar")
                     of SOME s => "\"" ^ s ^ "\"" | NONE => "<none>") ^ "\n")

(* Base64 *)
val () = print "\nBase64 (RFC 4648):\n"
val () = print ("  encode    \"foobar\" = " ^ Base64.encode "foobar" ^ "\n")
val () = print ("  encodeUrl \"foobar\" = " ^ Base64.encodeUrl "foobar" ^ "\n")
val () = print ("  decode roundtrip   = "
                ^ (case Base64.decode (Base64.encode "foobar")
                     of SOME s => "\"" ^ s ^ "\"" | NONE => "<none>") ^ "\n")

(* CRC-32 *)
val () = print "\nCRC-32 (ISO 3309):\n"
val () = print ("  crcHex \"123456789\" = " ^ Crc32.crcHex "123456789" ^ "\n")

(* SHA-1 / SHA-256 / SHA-512 *)
val () = print "\nHashes of \"abc\":\n"
val () = print ("  SHA-1   = " ^ Sha1.hexDigest "abc" ^ "\n")
val () = print ("  SHA-256 = " ^ Sha256.hexDigest "abc" ^ "\n")
val () = print ("  SHA-512 = " ^ Sha512.hexDigest "abc" ^ "\n")
