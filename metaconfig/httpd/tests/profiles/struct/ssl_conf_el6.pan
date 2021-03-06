structure template struct/ssl_conf_el6;

"modules" = append(nlist(
    "name", "ssl_module", 
    "path", "modules/mod_ssl.so"
));
    
"listen" = list(
    nlist("port", 443),
);
"ssl" = nlist(
    "passphrasedialog", "builtin",

    "sessioncache", "shmcb:/var/cache/mod_ssl/scache(512000)",
    "sessioncachetimeout", 300,
    
    "mutex", "default",
    
    "randomseed", list(
        list("startup", "file:/dev/urandom", "256"),
        list("connect", "builtin"),
    ),
    "cryptodevice", list("builtin"),
);

"vhosts/base" = create("struct/default_vhost",
    "documentroot", "/var/www/cgi-bin",
    "port", 443);


"vhosts/base/log/error" = "logs/ssl_error_log";
"vhosts/base/log/transfer" = "logs/ssl_access_log";
"vhosts/base/log/level" = "warn";
"vhosts/base/log/custom" = list(
    nlist(
        "location", "logs/ssl_request_log",
        "name", '"%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"',
    ),
);


"vhosts/base/ssl/engine" = true;
# list("all", "-SSLv2") not allowed 
"vhosts/base/ssl/protocol" =  list("TLSv1");
# list("ALL", "!ADH", "!EXPORT", "!SSLv2", "RC4", "RSA", "+HIGH", "+MEDIUM", "+LOW")
"vhosts/base/ssl/ciphersuite" = list("TLSv1");
"vhosts/base/ssl/certificatefile" = "/etc/pki/tls/certs/localhost.crt";
"vhosts/base/ssl/certificatekeyfile" = "/etc/pki/tls/private/localhost.key";

"vhosts/base/files" = list(nlist(
    "regex", true,
    "name", '\.(cgi|shtml|phtml|php3?)$',
    "ssl", nlist(
        "options", list("+StdEnvVars"),
    ),
));
"vhosts/base/directories" = list(nlist(
    "name", "/var/www/cgi-bin",
    "ssl", nlist(
        "options", list("+StdEnvVars"),
    ),
));
"vhosts/base/env/if" = list(nlist(
    "attribute", "User-Agent",
    "regex", ".*MSIE.*",
    "variables", list("nokeepalive", "ssl-unclean-shutdown", "downgrade-1.0", "force-response-1.0"),
));
