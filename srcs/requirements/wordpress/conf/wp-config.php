<?php

// WordPress Database Configuration
// These settings are pulled from environment variables so that we can access 
// the database with the correct credentials.

define( 'DB_NAME', getenv('DB_NAME') );
define( 'DB_USER', getenv('DB_USER_NAME') );
define( 'DB_PASSWORD', getenv('DB_USER_PASS') );
define( 'DB_HOST', getenv('DB_HOST') );
define( 'WP_HOME', getenv('WP_HOME') );
define( 'WP_SITEURL', getenv('WP_SITEURL') );

define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );

$table_prefix = 'wp_';

define('WP_DEBUG', true);

#define( 'WP_DEBUG_LOG', true );
#define( 'WP_DEBUG_DISPLAY', true );
#define( 'SCRIPT_DEBUG', true );
#error_reporting(E_ALL);
#ini_set('display_errors', 1);

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
