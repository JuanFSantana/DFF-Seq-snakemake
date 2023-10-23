import os
import subprocess

# List of required tools
tools_to_check = ["unpigz", "pandas", "curl", "gunzip", "awk"]

# Function to install a tool if it's missing
def install_tool(tool_name):
    print(f"Installing {tool_name}...")
    if tool_name == "unpigz":
        subprocess.call(["sudo", "apt-get", "install", "pigz"])
        os.symlink("/usr/bin/pigz", "/usr/local/bin/unpigz")
    elif tool_name == "pandas":
        subprocess.call(["pip", "install", "pandas"])
    print(f"{tool_name} is now installed.")

# Check if all tools are available
missing_tools = [tool for tool in tools_to_check if subprocess.call(["which", tool]) != 0]

if not missing_tools:
    print("All required tools are installed and available in the PATH.")
else:
    print("Some required tools are missing. Installing or making them executable...")

    for tool in missing_tools:
        # Install or make executable based on the tool
        if tool in ["unpigz", "pandas"]:
            install_tool(tool)
        elif tool == "gunzip":
            # gunzip is part of gzip, so we'll symlink gzip to gunzip
            os.symlink("/bin/gzip", "/usr/local/bin/gunzip")
            print("gunzip is now available.")
        elif tool == "awk":
            # awk is a standard Unix tool, so no need to install or symlink
            print("awk is already available.")

# Make all scripts in the 'scripts/' directory executable
scripts_directory = "scripts"
if os.path.isdir(scripts_directory):
    print(f"Checking and making scripts in '{scripts_directory}' executable...")
    for filename in os.listdir(scripts_directory):
        script_path = os.path.join(scripts_directory, filename)
        os.chmod(script_path, 0o755)  # Make the script executable
        print(f"'{filename}' is now executable.")

