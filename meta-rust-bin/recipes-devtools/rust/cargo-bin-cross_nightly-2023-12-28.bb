
# Recipe for cargo 20231228
# This corresponds to rust release nightly

def get_by_triple(hashes, triple):
    try:
        return hashes[triple]
    except:
        raise bb.parse.SkipRecipe("Unsupported triple: %s" % triple)

def cargo_md5(triple):
    HASHES = {
        "aarch64-unknown-linux-gnu": "8b315507543721a23d6f957c7af06f65",
        "arm-unknown-linux-gnueabi": "0a19de7d5c3f52d448421290a37d3baa",
        "arm-unknown-linux-gnueabihf": "696f2edcca297488c7c6fbf3f8eb0899",
        "armv7-unknown-linux-gnueabihf": "6a4b4d61f8a2ef346890514bcb0bb0c8",
        "i686-unknown-linux-gnu": "f2a956813dd125fe087b82b66efbfc2f",
        "x86_64-unknown-linux-gnu": "ced8771a59f3639b31937a8427d62c76",
    }
    return get_by_triple(HASHES, triple)

def cargo_sha256(triple):
    HASHES = {
        "aarch64-unknown-linux-gnu": "8c38c0fdafed08d93862256cb15cec3265be7025edfcb7cba55f45c3f6527cfc",
        "arm-unknown-linux-gnueabi": "848ec5bc70e5c2172c63acce5b13ed37c2cecf0b0b7b45029477a2b2231a6f3b",
        "arm-unknown-linux-gnueabihf": "ca04436d7051e568699eccf004454726697e956f952bc11a37649b3abef787a1",
        "armv7-unknown-linux-gnueabihf": "d602d29b8b3458f047e37feb777c59860ffdbb4f60362643ba221f980ed89a21",
        "i686-unknown-linux-gnu": "13495475871a97e0df6b22aab3ced9f33598a13057e0f38b32d699bd2b17b037",
        "x86_64-unknown-linux-gnu": "cacff8ebe3e276e672e5a0e42f10b3b7fdb54b52d7953f3401a57fc4cbeced05",
    }
    return get_by_triple(HASHES, triple)

def cargo_url(triple):
    URLS = {
        "aarch64-unknown-linux-gnu": "https://static.rust-lang.org/dist/2023-12-28/cargo-nightly-aarch64-unknown-linux-gnu.tar.gz",
        "arm-unknown-linux-gnueabi": "https://static.rust-lang.org/dist/2023-12-28/cargo-nightly-arm-unknown-linux-gnueabi.tar.gz",
        "arm-unknown-linux-gnueabihf": "https://static.rust-lang.org/dist/2023-12-28/cargo-nightly-arm-unknown-linux-gnueabihf.tar.gz",
        "armv7-unknown-linux-gnueabihf": "https://static.rust-lang.org/dist/2023-12-28/cargo-nightly-armv7-unknown-linux-gnueabihf.tar.gz",
        "i686-unknown-linux-gnu": "https://static.rust-lang.org/dist/2023-12-28/cargo-nightly-i686-unknown-linux-gnu.tar.gz",
        "x86_64-unknown-linux-gnu": "https://static.rust-lang.org/dist/2023-12-28/cargo-nightly-x86_64-unknown-linux-gnu.tar.gz",
    }
    return get_by_triple(URLS, triple)

DEPENDS += "rust-bin-cross-${TARGET_ARCH} (= nightly-2023-12-28)"

LIC_FILES_CHKSUM = "\
    file://LICENSE-APACHE;md5=71b224ca933f0676e26d5c2e2271331c \
    file://LICENSE-MIT;md5=b377b220f43d747efdec40d69fcaa69d \
"

require cargo-bin-cross.inc
