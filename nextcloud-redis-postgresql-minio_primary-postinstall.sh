# Start Containers
docker compose -f docker-compose.nextcloud-minio-primary.yml up -d

# Add the S3 object store config (MinIO) to config/config.php
docker exec -u www-data -it nextcloud-app bash -lc '\
php -r "
$configFile = '\''/var/www/html/config/config.php'\'';
if (!file_exists($configFile)) { file_put_contents($configFile, \"<?php\\n\\\$CONFIG = array ();\\n\"); }
include $configFile;
\$CONFIG['objectstore'] = [
  'class' => 'OC\\\\Files\\\\ObjectStore\\\\S3',
  'arguments' => [
    'bucket' => 'nextcloud',
    'autocreate' => true,
    'key' => 'change_this_minio_access_key',
    'secret' => 'change_this_minio_secret_key',
    'hostname' => 'minio',     // service name in compose network
    'port' => 9000,
    'use_ssl' => false,        // using HTTP for MinIO in lab
    'region' => 'us-east-1',   // any string works for MinIO
    'use_path_style' => true   // required for many non-AWS S3 backends
  ]
];
file_put_contents($configFile, \"<?php\\n\\\$CONFIG = \".var_export(\$CONFIG, true).\";\\n\");
"
'

# Finish the install non‑interactively with OCC (creates admin user, DB schema, etc.)

docker exec -u www-data -it nextcloud-app php occ maintenance:install \
  --database "pgsql" \
  --database-host "db" \
  --database-name "nextcloud" \
  --database-user "nextcloud" \
  --database-pass "change_this_pg_password" \
  --admin-user "admin" \
  --admin-pass "change_this_admin_password"

  
