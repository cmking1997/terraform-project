For a full-stack modern application my stack consists of the following:
Amplify for the frontend, this will make hosting a React application quite simple.
Lambda backend focused on micoservice infrasatructure.
S3 for document storage and requirements there.
RDS for regular data storage using mySQL, potentially could be swapped to PostgreSQL based on preference.
If Route 53 is used that can be included, for custom domains but since this is a dev env i excluded it

I'm using Docker Desktop (on Windows)

To start docker instance in terminal run:
docker run --rm --name terraform-test -p 5000:5000 motoserver/moto:latest

in docker instance terminal do:
apt update
apt-get install unzip
apt install wget
apt install nano
wget https://releases.hashicorp.com/terraform/1.12.2/terraform_1.12.2_linux_amd64.zip
unzip terraform_1.12.2_linux_amd64.zip
mv terraform /usr/local/bin/
terraform --version
nano main.tf
copy paste main.tf into nano terminal
terraform init
terraform plan
