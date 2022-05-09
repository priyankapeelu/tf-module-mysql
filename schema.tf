resource "null_resource" "schema" {
  provisioner "local-exec" {
    command = <<EOF
cd /tmp
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
unzip -o mysql.zip
cd mysql-main
mysql -h ${aws_db_instance.mysql.address} -u admin1 -pRoboShop1 <shipping.sql
EOF
  }
}
