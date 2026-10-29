#!/usr/bin/env python3
"""
Generate an Ansible inventory.ini file from Terraform state or CLI arguments.
Usage:
    python generate_inventory.py [--key-path ~/.ssh/id_rsa] [--state ../infra/terraform.tfstate]
"""

import argparse
import json
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description="Generate Ansible inventory from Terraform state.")
    parser.add_argument(
        "--state",
        default=str(Path(__file__).parent.parent / "infra" / "terraform.tfstate"),
        help="Path to terraform.tfstate file",
    )
    parser.add_argument(
        "--key-path",
        default="~/.ssh/id_rsa",
        help="Path to the SSH private key (default: ~/.ssh/id_rsa)",
    )
    parser.add_argument(
        "--user",
        default="ubuntu",
        help="Remote SSH user (default: ubuntu)",
    )
    parser.add_argument(
        "--output",
        default=str(Path(__file__).parent / "inventory.ini"),
        help="Output inventory path (default: ansible/inventory.ini)",
    )

    args = parser.parse_args()

    state_path = Path(args.state)
    if not state_path.is_file():
        raise SystemExit(f"Error: Terraform state file not found at {state_path}")

    try:
        with open(state_path, "r", encoding="utf-8") as f:
            state = json.load(f)
    except Exception as e:
        raise SystemExit(f"Error reading {state_path}: {e}")

    outputs = state.get("outputs", {})
    public_ip = outputs.get("public_ip", {}).get("value")

    if not public_ip:
        raise SystemExit("Error: 'public_ip' output not found in terraform state.")

    inventory_content = (
        f"[app]\n"
        f"flask-app ansible_host={public_ip} ansible_user={args.user} "
        f"ansible_ssh_private_key_file={args.key_path}\n"
    )

    output_path = Path(args.output)
    output_path.write_text(inventory_content, encoding="utf-8")
    print(f"Successfully generated inventory at {output_path} for host {public_ip}")


if __name__ == "__main__":
    main()
