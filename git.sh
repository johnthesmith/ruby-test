#**************************************************************************************
# Create file for ssh auth
# /root/.ssh/config
# https://www.keybits.net/post/automatically-use-correct-ssh-key-for-remote-git-repo/
# File Contain:
#
# Host github.com
#     HostName github.com
#     User git
#     IdentityFile /root/.ssh/github
#**************************************************************************************
GIT_PATH='/opt/nginx/app/news/';
cd $GIT_PATH

## Github
if ! [ -d $GIT_PATH'/.git' ]; then
    # Init githup if path not found
    git init;
    git add -A;
    git config --global user.name "john the smith";
    git config --global user.email "still@itserv.ru";
    git commit -m "first commit";
    git remote add origin git@github.com:johnthesmith/ruby-test.git
else
    # Init githup if path found
    git add -A;
    git commit -m "commit";
fi

# guthub push
# git pull origin
git push -u origin master;