# clouduploader

Helps to upload file to Azure Blob Storage. Provides shareble link to blob.

Now you may upload one file at once.


# How to Install

1. Clone repository `git clone https://github.com/dms4000/clouduploader.git`
2. Copy script for example to directory ~/bin `cp clouduploader.sh ~/bin/clouduploader`
3. Ensure the script is executable by running: `chmod +x ~/bin/clouduploader`
4. Add the Directory to Your PATH. 
    - Open your `~/.bashrc` file with a text editor (e.g., `nano ~/.bashrc`).
    - Add the following line at the end of the file: `export PATH="$HOME/bin:$PATH"`
    - Save the file and load the updated PATH into the current shell session `source ~/.bashrc`
5. Now you can run your `clouduploader` script from anywhere in the terminal! 


# How to use

1. Go to working directory e.g. `cd ~/upload`
2. Run script `clouduploader`
1. Run > az login
3. Go through the steps
