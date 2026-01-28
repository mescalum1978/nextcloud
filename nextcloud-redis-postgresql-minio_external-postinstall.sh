# Enable the External storage app
docker exec -u www-data nextcloud-app php occ app:enable files_external

# Create an S3 mount called "minio"
docker exec -u www-data nextcloud-app php occ files_external:create \
  --user=admin \
  --config bucket=nextcloud \
  --config hostname=minio \
  --config region=us-east-1 \
  --config use_ssl=false \
  --config use_path_style=true \
  --config key=change_this_minio_access_key \
  --config secret=change_this_minio_secret_key \
  "MinIO (S3)" amazons3 amazons3::accesskey
