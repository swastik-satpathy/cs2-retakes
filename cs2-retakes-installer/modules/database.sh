# echo "Installing MariaDB..."

# apt install -y mariadb-server

# mysql <<EOF

# CREATE DATABASE IF NOT EXISTS cs2;

# CREATE USER IF NOT EXISTS 'cs2server'@'localhost'
# IDENTIFIED BY 'cs2server';

# GRANT ALL PRIVILEGES ON cs2.* TO 'cs2server'@'localhost';

# FLUSH PRIVILEGES;

# EOF


echo "Checking MariaDB installation..."

# Check if MariaDB server exists

if command -v mysql >/dev/null 2>&1; then
echo "MariaDB already installed"
else
echo "Installing MariaDB..."
apt update
apt install -y mariadb-server
fi

echo "Checking CS2 database..."

DB_EXISTS=$(mysql -N -B -e "SHOW DATABASES LIKE 'cs2';" 2>/dev/null || true)

if [ "$DB_EXISTS" = "cs2" ]; then
echo "Database cs2 already exists — skipping creation"
else
echo "Creating database and user..."

mysql <<EOF
CREATE DATABASE IF NOT EXISTS cs2;

CREATE USER IF NOT EXISTS 'cs2server'@'localhost'
IDENTIFIED BY 'cs2server';

GRANT ALL PRIVILEGES ON cs2.* TO 'cs2server'@'localhost';

FLUSH PRIVILEGES;
EOF

fi
