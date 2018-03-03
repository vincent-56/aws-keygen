#! /bin/sh
echo "   _____  __      __  _________  __  "                                    
echo "  /  _  \/  \    /  \/   _____/ |  | __ ____ ___.__. ____   ____   ____  "
echo " /  /_\  \   \/\/   /\_____  \  |  |/ // __ <   |  |/ ___\_/ __ \ /    \ "
echo "/    |    \        / /        \ |    <\  ___/\___  / /_/  >  ___/|   |  \ "
echo "\____|__  /\__/\  / /_______  / |__|_ \\___  > ____\___  / \___  >___|  /"
echo "        \/      \/          \/       \/    \/\/   /_____/      \/     \/ "
echo "Author: Vincent Sincholle"
echo "Mar. 17"

echo " "
read -p "Name of the SSH key you want to generate? " keyname
ssh-keygen -t rsa -C $keyname -P '' -f ~/.ssh/$keyname

echo " "
echo " List of your AWS profiles : "
cat ~/.aws/config

echo " "
read -p "Which AWS profile you want to use? " profile
echo "The key ~/.ssh/"$keyname".pub will be deleted and uploaded in AWS using the profile" $profile
read -p "Do you want to continue? {y|n} " answer

echo " "
case $answer in
  [yY]*) 
	aws ec2 import-key-pair --public-key-material "$(cat ~/.ssh/$keyname.pub| tr -d '\n')"  --key-name $keyname --profile $profile
        rm ~/.ssh/$keyname.pub   
	echo "Public key have been deleted and sent in AWS";;
  [nN]*) echo "key have been deleted from you ssh diectory"
	 rm ~/.ssh/$keyname.*
         exit 0;;
  *) echo "Wrong keyboard input, keys have been deleted"
     rm ~/.ssh/$keyname.*
     exit 1;; 
            
esac
