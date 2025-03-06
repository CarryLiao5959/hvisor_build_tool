
def get_by_triple(hashes, triple):
    try:
        return hashes[triple]
    except:
        raise bb.parse.SkipRecipe("Unsupported triple: %s" % triple)


def rust_std_md5(triple):
    HASHES = {
        "aarch64-unknown-linux-gnu": "41eef2ba7c3e86aa7a97b586ea9a01f9",
        "aarch64-unknown-linux-musl": "3980fb1395bf80aed59718950acb9680",
        "arm-unknown-linux-gnueabi": "d8f92ca911f7f33810bef2fe7d6beb6f",
        "arm-unknown-linux-gnueabihf": "81e4434688145096af840ed681f05aa5",
        "armv5te-unknown-linux-gnueabi": "2f12f950bc24b41fd70030db87c1a917",
        "armv5te-unknown-linux-musleabi": "2d84d994223a1bf56b9cd109f9587b57",
        "armv7-unknown-linux-gnueabihf": "176028376b8ad6207972e4731c279df2",
        "armv7-unknown-linux-musleabihf": "a9f75899ad34009de211cb59d26da540",
        "i686-unknown-linux-gnu": "cdd3ddd629292241d5f05866f4c0ae57",
        "powerpc-unknown-linux-gnu": "0c4b66f979539ed317083238f6e920fc",
        "x86_64-unknown-linux-gnu": "29071dae6f54ac52c89e811d5661840a",
        "riscv64gc-unknown-linux-gnu": "d046a008976da92a37cd82d876e93e93",
        "thumbv7neon-unknown-linux-gnueabihf": "242d8c808195c064d550c865fb3d425b",
    }
    return get_by_triple(HASHES, triple)

def rust_std_sha256(triple):
    HASHES = {
        "aarch64-unknown-linux-gnu": "77500a894910b9d2622849c2e65c35ea5e008a4022cd6150e0b5d192868373e4",
        "aarch64-unknown-linux-musl": "3d2faaaffe67aea4fb74c2d4ee1362076f8018f5b6d38be7e27be2c90e5d999c",
        "arm-unknown-linux-gnueabi": "f04e6b4d4f977fb5903197812bc30992ee143c30b87edd7d215693d73b13587e",
        "arm-unknown-linux-gnueabihf": "5b7d83224a1a1b5baf76569f80cb02cf867e04dfe2fa23d86c05ceae76769c31",
        "armv5te-unknown-linux-gnueabi": "c51535cc543587b7b524b51400f3af8a9106ee27e0c4f97b98fcd53c1234200a",
        "armv5te-unknown-linux-musleabi": "266c3d1e37239bfdc3b51aa5dac2dc8356324b7acf82b82759a231b376709190",
        "armv7-unknown-linux-gnueabihf": "c04a81128e9f47783ca35128307b8bdde18d0e0d4437a0db27d49fddac87dfb9",
        "armv7-unknown-linux-musleabihf": "be5471fc70e0bd5713501d93a95ab867c8dc9f54ddb38023ad247fc7b80bcaed",
        "i686-unknown-linux-gnu": "2c97039d0eea1b297b6d26a4f0ad108cdc7ea3dcc2303d5afdb39cdbdf351af7",
        "powerpc-unknown-linux-gnu": "b5a318f1315496bb6c222044da1e865905927e3094deccfdfd3184259fa174d7",
        "x86_64-unknown-linux-gnu": "ede5087c92ef9094bba9ca6ccf531a2e4aa5f585060e263eb63a8764a5b2a06a",
        "riscv64gc-unknown-linux-gnu": "629efec44a42d2c45a02ddaf5c3ab366214dc43671146c9c88bc5a52654b7af7",
        "thumbv7neon-unknown-linux-gnueabihf": "bb46b0f08b7e6abbaaa8e63287f7d564ae644fa88bbc7a537cde4ae336f06ea3",
    }
    return get_by_triple(HASHES, triple)

def rustc_md5(triple):
    HASHES = {
        "aarch64-unknown-linux-gnu": "7d730d131c2dc49511fdcdfc2d432bfd",
        "arm-unknown-linux-gnueabi": "85c8f2578255dadd4a5730c5ac9139c6",
        "arm-unknown-linux-gnueabihf": "cb83edf015f1bb21be741de7d7f26902",
        "armv7-unknown-linux-gnueabihf": "ab4e84971dfa0da4f9b94a14231ecc49",
        "i686-unknown-linux-gnu": "a077d6b29765d42859385a8c9595c32b",
        "x86_64-unknown-linux-gnu": "3799061ddac11c4bd5f04bcdb33b85c7",
    }
    return get_by_triple(HASHES, triple)

def rustc_sha256(triple):
    HASHES = {
        "aarch64-unknown-linux-gnu": "fbab036302272a308539ba5efdef2749dd16274765ee7c9b4df8b4e833b5f8d1",
        "arm-unknown-linux-gnueabi": "e23ebf21c68fdb171613fdda1e9edc648ba41d686a5f37759180608b507ffe3a",
        "arm-unknown-linux-gnueabihf": "68763a747f709578d6ea24f9188bcca8bc97feb0faa13bd559fba70c72eae81b",
        "armv7-unknown-linux-gnueabihf": "1368bba68dd0beecf172393622c95ff7d57d17b3d97a6128d97bd56e4ed4df65",
        "i686-unknown-linux-gnu": "1d7d48b974203f119a44e46ce9f38318669c2367391abac2d8718293d58160fc",
        "x86_64-unknown-linux-gnu": "3c8fae19ff2c82edd08a0e548aa1733ed140251f74a5604f5a2b21488705fe9a",
    }
    return get_by_triple(HASHES, triple)

def rust_src_md5(triple):
    HASHES = {
        "x86_64-unknown-linux-gnu": "e65c9be4292e544c85aa314b8938b115",
    }
    return get_by_triple(HASHES, triple)

def rust_src_sha256(triple):
    HASHES = {
        "x86_64-unknown-linux-gnu": "93fd23ff3bbeb7ba11e399420cf9712b3246fd672b4448a8e0b45e412f9de0f3",
    }
    return get_by_triple(HASHES, triple)

def llvm_src_md5(triple):
    HASHES = {
        "x86_64-unknown-linux-gnu": "64946a4cce5e6d6f35cd71464913d1ae",
    }
    return get_by_triple(HASHES, triple)

def llvm_src_sha256(triple):
    HASHES = {
        "x86_64-unknown-linux-gnu": "625a4b0b51e050924d0666337a94f8ee237e04c8eec870015044ef0b47544d2e",
    }
    return get_by_triple(HASHES, triple)



LIC_FILES_CHKSUM = "file://COPYRIGHT;md5=c2cccf560306876da3913d79062a54b9"

require rust-bin-cross.inc
