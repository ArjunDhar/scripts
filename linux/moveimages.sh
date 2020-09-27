# The client is not confident of moving files in FTP on a large scale that can lead to mess ups
# So the core /www/... folders are insulated from daily uploads esp for product images
# providing a script which will copy their product assets from content folder to website relative folders

rm ~/catalog/192/* -rf
cd ~/catalog/192/
find ~/publisher-access/content/images/192/ -name '*.*' -exec cp '{}' ./ \;
rm DSC*
echo Refreshed files for 192

rm ~/catalog/311/* -rf
cd ~/catalog/311/
find ~/publisher-access/content/images/311/ -name '*.*' -exec cp '{}' ./ \;
rm DSC*
echo Refreshed files for 311

rm ~/catalog/933/* -rf
cd ~/catalog/933/
find ~/publisher-access/content/images/933/ -name '*.*' -exec cp '{}' ./ \;
rm DSC*
echo Refreshed files for 933


