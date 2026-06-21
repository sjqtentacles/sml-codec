(* Tests for sml-codec: RFC 4648 (base16/base64), RFC 3174 (sha1),
   RFC 6234 (sha256), and standard CRC-32 vectors. *)

structure CodecTests =
struct
  open Harness

  fun run () =
    let
      val () = section "Base16"
      val () = checkString "encode foobar" ("666f6f626172", Base16.encode "foobar")
      val () = checkString "encode empty" ("", Base16.encode "")
      val () = checkString "encodeUpper" ("48656C6C6F", Base16.encodeUpper "Hello")
      val () = checkBool "decode roundtrip"
                 (true, Base16.decode (Base16.encode "any bytes!") = SOME "any bytes!")
      val () = checkBool "decode odd length is NONE" (true, Base16.decode "abc" = NONE)
      val () = checkBool "decode non-hex is NONE" (true, Base16.decode "zz" = NONE)
      val () = checkBool "decode case-insensitive"
                 (true, Base16.decode "48656C6C6F" = SOME "Hello")

      (* RFC 4648 section 10 test vectors. *)
      val () = section "Base64 (RFC 4648 vectors)"
      val () = checkString "''" ("", Base64.encode "")
      val () = checkString "f" ("Zg==", Base64.encode "f")
      val () = checkString "fo" ("Zm8=", Base64.encode "fo")
      val () = checkString "foo" ("Zm9v", Base64.encode "foo")
      val () = checkString "foob" ("Zm9vYg==", Base64.encode "foob")
      val () = checkString "fooba" ("Zm9vYmE=", Base64.encode "fooba")
      val () = checkString "foobar" ("Zm9vYmFy", Base64.encode "foobar")

      val () = section "Base64 decode"
      val () = checkBool "decode Zg==" (true, Base64.decode "Zg==" = SOME "f")
      val () = checkBool "decode Zm8=" (true, Base64.decode "Zm8=" = SOME "fo")
      val () = checkBool "decode foobar" (true, Base64.decode "Zm9vYmFy" = SOME "foobar")
      val () = checkBool "decode without padding"
                 (true, Base64.decode "Zg" = SOME "f")
      val () = checkBool "decode empty" (true, Base64.decode "" = SOME "")
      val () = checkBool "decode stray char NONE" (true, Base64.decode "!!!!" = NONE)
      val () = checkBool "encode/decode roundtrip"
                 (true, Base64.decode (Base64.encode "The quick brown fox") = SOME "The quick brown fox")

      val () = section "Base64 URL-safe"
      (* 0xfb 0xff -> standard "+/8=" ; url-safe "-_8" *)
      val () = checkString "url-safe alphabet"
                 ("-_8", Base64.encodeUrl (String.implode [Char.chr 0xfb, Char.chr 0xff]))
      val () = checkBool "url-safe decodes"
                 (true, Base64.decode "-_8" = SOME (String.implode [Char.chr 0xfb, Char.chr 0xff]))

      (* RFC 3174 / FIPS 180 SHA-1 vectors. *)
      val () = section "SHA-1 (RFC 3174 vectors)"
      val () = checkString "empty"
                 ("da39a3ee5e6b4b0d3255bfef95601890afd80709", Sha1.hexDigest "")
      val () = checkString "abc"
                 ("a9993e364706816aba3e25717850c26c9cd0d89d", Sha1.hexDigest "abc")
      val () = checkString "two-block"
                 ("84983e441c3bd26ebaae4aa1f95129e5e54670f1",
                  Sha1.hexDigest "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
      val () = checkString "million a's"
                 ("34aa973cd4c4daa4f61eeb2bdbad27316534016f",
                  Sha1.hexDigest (String.implode (List.tabulate (1000000, fn _ => #"a"))))
      val () = checkInt "digest length is 20" (20, String.size (Sha1.digest "abc"))

      (* RFC 6234 / FIPS 180 SHA-256 vectors. *)
      val () = section "SHA-256 (RFC 6234 vectors)"
      val () = checkString "empty"
                 ("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
                  Sha256.hexDigest "")
      val () = checkString "abc"
                 ("ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
                  Sha256.hexDigest "abc")
      val () = checkString "two-block"
                 ("248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1",
                  Sha256.hexDigest "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
      val () = checkInt "digest length is 32" (32, String.size (Sha256.digest "abc"))

      (* CRC-32 vectors. crc32("") = 0; crc32("123456789") = 0xCBF43926. *)
      val () = section "CRC-32"
      val () = checkBool "empty is 0" (true, Crc32.crc "" = 0w0)
      val () = checkString "check value hex" ("cbf43926", Crc32.crcHex "123456789")
      val () = checkString "'The quick brown fox jumps over the lazy dog'"
                 ("414fa339", Crc32.crcHex "The quick brown fox jumps over the lazy dog")
    in
      ()
    end
end
