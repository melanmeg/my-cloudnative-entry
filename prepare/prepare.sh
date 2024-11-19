#!/bin/bash -eux

# Variables
BACKEND_BUCKT_NAME=test-project-373118-tfstate-bucket
WORDPRESS_USER_PASSWORD=testpassword
WORDPRESS_DB_PASSWORD=db-password

# バケット作成
gsutil mb -l asia-northeast1 gs://$BACKEND_BUCKT_NAME
gcloud storage buckets update gs://$BACKEND_BUCKT_NAME --versioning --uniform-bucket-level-access --lifecycle-file=./lifecycle_config.json

# シークレット作成
echo -n $WORDPRESS_USER_PASSWORD > user-password.secret  # wordpressログインユーザーのパスワード
echo -n $WORDPRESS_DB_PASSWORD > db-password.secret  # DBのパスワード ※もし改行が入ると、wordpressでは設定が上手く反映されなくなるため注意
gcloud secrets create wordpress-user-password-sm --replication-policy=automatic --data-file=user-password.secret
gcloud secrets create wordpress-db-password-sm --replication-policy=automatic --data-file=db-password.secret
rm -f user-password.secret db-password.secret

# Google Cloud KMS作成
gcloud kms keyrings create sops --location global
gcloud kms keys create sops-key --location global --keyring sops --purpose encryption
