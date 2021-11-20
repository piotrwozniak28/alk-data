sudo apt-get update
sudo apt-get install git
git config --global user.name "Piotr Wozniak"
git config --global user.email "piotrwozniak28@gmail.com"
ssh-keygen -t rsa -b 4096 -C "piotrwozniak28@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat < ~/.ssh/id_rsa.pub
https://github.com/settings/keys
git clone git@github.com:piotrwozniak28/alk-data.git