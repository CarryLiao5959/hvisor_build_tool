
def get_by_triple(hashes, triple):
    try:
        return hashes[triple]
    except:
        raise bb.parse.SkipRecipe("Unsupported triple: %s" % triple)


def rust_std_md5(triple):
    HASHES = {
        "aarch64-unknown-linux-gnu": "d6124320f023d22f6166fff9c8f5e459",
        "aarch64-unknown-linux-musl": "772bf540185c1345960928ca8ccbe98d",
        "arm-unknown-linux-gnueabi": "7f1df76a5f85d2c464caa7fbd3d85d9f",
        "arm-unknown-linux-gnueabihf": "3e4a1f281b773142183b423e1573555d",
        "armv5te-unknown-linux-gnueabi": "9010c9ae7e27a85c184ea9a8f097c867",
        "armv5te-unknown-linux-musleabi": "7b98ad33c2e73a610be1178c66d4a5f7",
        "armv7-unknown-linux-gnueabihf": "39afe88703d2c70610e74ff64d1b7c86",
        "armv7-unknown-linux-musleabihf": "a308cdb1f394beca581fd0f7671f766f",
        "i686-unknown-linux-gnu": "08c942bbffb79528d924502dde0a0ffc",
        "powerpc-unknown-linux-gnu": "6dacbb6552158049e5e65fbfd8454705",
        "x86_64-unknown-linux-gnu": "c3b768c356baa090bd6a8b707c5c504a",
        "riscv64gc-unknown-linux-gnu": "ca8258e809fe93fd724ec6fb4cd85865",
        "thumbv7neon-unknown-linux-gnueabihf": "f5fbe854db126f881151d5bf10f1bccc",
    }
    return get_by_triple(HASHES, triple)

def rust_std_sha256(triple):
    HASHES = {
        "aarch64-unknown-linux-gnu": "bc771bc912f06622957728a262dcdbc68428aa29fdeb88075c7eec075008914c",
        "aarch64-unknown-linux-musl": "d25f4c731553cfbd11b5baefbef1e96280ff6e13efe473c62e6151ca3efd1ae8",
        "arm-unknown-linux-gnueabi": "ce67f0d73acab9bc9bd60a0e07cf0636ffffb3803602b6f767c04d593f768587",
        "arm-unknown-linux-gnueabihf": "5285d740004ce012f27cd4895ce66e11a3f358ddea23f0c1cc7791bb15156fff",
        "armv5te-unknown-linux-gnueabi": "3498fca1480cdc47eaa35e4275b683f0a3cc98df2fbe3348ab98011bbad65789",
        "armv5te-unknown-linux-musleabi": "0465a84211ad9eae2554c80f5210599d31aec1c24c9165f93502190b5ce77946",
        "armv7-unknown-linux-gnueabihf": "1a752ad529acb97febd82dcb04e4fe06ad781e5204dbf2fbccde7ffe55c21a17",
        "armv7-unknown-linux-musleabihf": "024d5d8d5b9f326d1240a68bcdca14ab04bf6f9e4746ded52ff10e740e22e3be",
        "i686-unknown-linux-gnu": "ea34adeb110e2f6eeddd5df565d00ef67959e7ba253bd8d57deacb7b52542112",
        "powerpc-unknown-linux-gnu": "dfde433357f4145e5adebd794b12df5c8ee7f1f2fd2ab1fcb1a273c4273b42a6",
        "x86_64-unknown-linux-gnu": "c20547bac88f0409449cd708cba6fe63ba49a06b058de84bcd015cf86103bb09",
        "riscv64gc-unknown-linux-gnu": "b6fdf24492236ad5b32e8592ec74994a15290c62dffad70f786641a434999f0c",
        "thumbv7neon-unknown-linux-gnueabihf": "feb0bd951c5e31d5c6a2f3b857b5f230eed852bea54984786db8c2a53216c6f1",
    }
    return get_by_triple(HASHES, triple)

def rustc_md5(triple):
    HASHES = {
        "aarch64-unknown-linux-gnu": "3a9c7fdd57ef1e6ac3a81d6d3833582a",
        "arm-unknown-linux-gnueabi": "29ed5ba3f04bd3711129b8fbb4e89014",
        "arm-unknown-linux-gnueabihf": "14c3eda89b623f13ae7d7e6790da641c",
        "armv7-unknown-linux-gnueabihf": "4e008baa573a3d098dd341b53dcc2d2a",
        "i686-unknown-linux-gnu": "82a76e197191866cb58913dba1764588",
        "x86_64-unknown-linux-gnu": "106041b5cea29ed9f0691b641ba916f4",
    }
    return get_by_triple(HASHES, triple)

def rustc_sha256(triple):
    HASHES = {
        "aarch64-unknown-linux-gnu": "b44c4cc831a82a221228305f4f0dc290c9f44e1f7f0c99e27b88e8c31598eafc",
        "arm-unknown-linux-gnueabi": "fdbaca6d622e3b6ca7adea31f9472f845089a485ab9a28c1f14a567361c40266",
        "arm-unknown-linux-gnueabihf": "5795d4a23552962c500db63b55fd5ba19e642c11d97e03a13767286eecaa17c3",
        "armv7-unknown-linux-gnueabihf": "e7bbac164b093322c3bdcda6baec9abfbb5705394bc7285e8ad084123c53f5b2",
        "i686-unknown-linux-gnu": "da97426abc50cf6f4e3a74877c104c3af50388386ed4ee15d3696e96593d65de",
        "x86_64-unknown-linux-gnu": "a1f89247e9e9b1fdb8a7c7cab33eb4711c7c8c61b63e927be5e6f855208c06d0",
    }
    return get_by_triple(HASHES, triple)

def rust_src_md5(triple):
    HASHES = {
        "x86_64-unknown-linux-gnu": "b31625066cb04e0216745023fa9d2252",
    }
    return get_by_triple(HASHES, triple)
 
def rust_src_sha256(triple):
    HASHES = {
        "x86_64-unknown-linux-gnu": "69144a1bea6de7c01e3da5e5acff0cb797e3fd15c9d14538aff909d469b28de4",
    }
    return get_by_triple(HASHES, triple)

def llvm_src_md5(triple):
    HASHES = {
        "x86_64-unknown-linux-gnu": "714e3baf6d27eedd66660464a5dfd6ab",
    }
    return get_by_triple(HASHES, triple)
 
def llvm_src_sha256(triple):
    HASHES = {
        "x86_64-unknown-linux-gnu": "2b115842e67806d315e875ccdf94ec6fdda52e21db083950bf6bd409a31bee51",
    }
    return get_by_triple(HASHES, triple)


LIC_FILES_CHKSUM = "file://COPYRIGHT;md5=c2cccf560306876da3913d79062a54b9"

require rust-bin-cross.inc
