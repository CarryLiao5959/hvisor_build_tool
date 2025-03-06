
# Recipe for cargo 20230712
# This corresponds to rust release nightly

def get_by_triple(hashes, triple):
    try:
        return hashes[triple]
    except:
        raise bb.parse.SkipRecipe("Unsupported triple: %s" % triple)

def cargo_md5(triple):
    HASHES = {
        "aarch64-unknown-linux-gnu": "1e6cca0c8a7a76eb1cda88df8cbf06c6",
        "arm-unknown-linux-gnueabi": "d26a5236f298800dcf17d7ee804fb1d0",
        "arm-unknown-linux-gnueabihf": "e30a61e01b8c7058dc5a16a6ae26726f",
        "armv7-unknown-linux-gnueabihf": "9beb5cdeb73c0f656cfbec9d66673f0f",
        "i686-unknown-linux-gnu": "4bcaf5f5f770156ba324865a4b3e4b94",
        "x86_64-unknown-linux-gnu": "b305115e5b19a46e8ded1a0ca059b128",
    }
    return get_by_triple(HASHES, triple)

def cargo_sha256(triple):
    HASHES = {
        "aarch64-unknown-linux-gnu": "a3e6c896a5986e9c59659adaf03c8cd8b965a1685748637b95b9eb495aa9d9fc",
        "arm-unknown-linux-gnueabi": "8762492caa4f39d5df12bde0bd1ffeebb2f26c48d190fcc02a749dcaa086bd3e",
        "arm-unknown-linux-gnueabihf": "eb7e94ea6cb75b6c57117fda0e7e67bd955f360eb3b2f276fce227f817c8fc55",
        "armv7-unknown-linux-gnueabihf": "09ff10654dce6795566e5aff1edb79ce7cf92dfeb95fcdaf401bb285e5bbf6a5",
        "i686-unknown-linux-gnu": "b17ae867666046dc92495f4049f72d3d5eb870d15fd79882331bc25007fab40d",
        "x86_64-unknown-linux-gnu": "85fd1d53b9d5ca903e2a5852708167df6e211b486c16f555bce1eb8117ff0271",
    }
    return get_by_triple(HASHES, triple)

def cargo_url(triple):
    URLS = {
        "aarch64-unknown-linux-gnu": "https://static.rust-lang.org/dist/2023-07-12/cargo-nightly-aarch64-unknown-linux-gnu.tar.gz",
        "arm-unknown-linux-gnueabi": "https://static.rust-lang.org/dist/2023-07-12/cargo-nightly-arm-unknown-linux-gnueabi.tar.gz",
        "arm-unknown-linux-gnueabihf": "https://static.rust-lang.org/dist/2023-07-12/cargo-nightly-arm-unknown-linux-gnueabihf.tar.gz",
        "armv7-unknown-linux-gnueabihf": "https://static.rust-lang.org/dist/2023-07-12/cargo-nightly-armv7-unknown-linux-gnueabihf.tar.gz",
        "i686-unknown-linux-gnu": "https://static.rust-lang.org/dist/2023-07-12/cargo-nightly-i686-unknown-linux-gnu.tar.gz",
        "x86_64-unknown-linux-gnu": "https://static.rust-lang.org/dist/2023-07-12/cargo-nightly-x86_64-unknown-linux-gnu.tar.gz",
    }
    return get_by_triple(URLS, triple)

DEPENDS += "rust-bin-cross-${TARGET_ARCH} (= nightly-2023-07-12)"

LIC_FILES_CHKSUM = "\
    file://LICENSE-APACHE;md5=71b224ca933f0676e26d5c2e2271331c \
    file://LICENSE-MIT;md5=b377b220f43d747efdec40d69fcaa69d \
"

require cargo-bin-cross.inc
