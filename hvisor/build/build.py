import json
import re

def parse_config(config_file):
    """Parse the .config file and return a dictionary of settings."""
    config_dict = {}
    with open(config_file, "r") as file:
        for line in file:
            line = line.strip()
            if line and not line.startswith("#"):  # Ignore comments
                match = re.match(r"CONFIG_(\w+)=(.+)", line)
                if match:
                    key, value = match.groups()
                    if value.startswith("\"") and value.endswith("\""):
                        value = value.strip("\"")  # Remove quotes for strings
                    elif value.isdigit():
                        value = int(value)  # Convert numbers
                    elif value in ("y", "n"): 
                        value = True if value == "y" else False
                    config_dict[key] = value
    return config_dict

def update_json(config_dict, json_file):
    """Update linux2.json based on .config values."""
    with open(json_file, "r") as file:
        data = json.load(file)
    if "ARCH_AARCH64" in config_dict and config_dict["ARCH_AARCH64"]:
        data["arch"] = "arm64"
    if "CPU_COUNT" in config_dict:
        data["cpus"] = [config_dict["CPU_COUNT"] - 1]  # CPU index starts from 0
    if "MEMORY_SIZE" in config_dict:
        memory_size = config_dict["MEMORY_SIZE"] * 0x100000  # Convert MB to bytes
        data["memory_regions"][0]["size"] = hex(memory_size)
    if "KERNEL_FILE" in config_dict:
        data["kernel_filepath"] = config_dict["KERNEL_FILE"]
    if "DTB_FILE" in config_dict:
        data["dtb_filepath"] = config_dict["DTB_FILE"]
    if "PCI_SUPPORT" in config_dict and config_dict["PCI_SUPPORT"]:
        data["num_pci_devs"] = config_dict.get("NUM_PCI_DEVS", 1)
    with open(json_file, "w") as file:
        json.dump(data, file, indent=4)
    print(f"Updated {json_file}")

def update_dts(config_dict, dts_file):
    """Modify linux2.dts to match .config settings."""
    with open(dts_file, "r") as file:
        dts_content = file.readlines()
    new_dts = []
    for line in dts_content:
        if "memory@50000000" in line:
            mem_size = hex(config_dict.get("MEMORY_SIZE", 256) * 0x100000)
            new_dts.append(f"\treg = <0x0 0x80000000 0x0 {mem_size}>;\n")
        elif "cpu@" in line and "reg = <" in line:
            new_dts.append(f"\tcpu@{config_dict.get('CPU_COUNT', 1)-1} {{\n")
        else:
            new_dts.append(line)
    with open(dts_file, "w") as file:
        file.writelines(new_dts)
    print(f"Updated {dts_file}")

if __name__ == "__main__":
    config_file = "./.config"
    json_file = "./linux2.json"
    dts_file = "./linux2.dts"
    config_dict = parse_config(config_file)
    update_json(config_dict, json_file)
    update_dts(config_dict, dts_file)

