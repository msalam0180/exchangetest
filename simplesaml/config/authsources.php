<?php

// Custom Changes to determine correct environment for IDP.
$env = getenv('AH_SITE_ENVIRONMENT') ? $_ENV['AH_SITE_ENVIRONMENT'] : '';
$server_cert = $private_key = '';

if (file_exists('/var/www/html/' . $_ENV['AH_SITE_NAME'] . '/acquia-files/nobackup/simplesaml/cert/serverCertificate.crt')) {
  $server_cert = '/var/www/html/' . $_ENV['AH_SITE_NAME'] . '/acquia-files/nobackup/simplesaml/cert/serverCertificate.crt';
}

if (file_exists('/var/www/html/' . $_ENV['AH_SITE_NAME'] . '/acquia-files/nobackup/simplesaml/cert/exchange.key')) {
  $private_key = '/var/www/html/' . $_ENV['AH_SITE_NAME'] . '/acquia-files/nobackup/simplesaml/cert/exchange.key';
}

// Default ADFS server to non-prod. This is used for non-prod environments.
$idp = 'http://adfsstg.sec.gov/adfs/services/trust';
// Switch ADFS server to prod. This is used for prod environment.
if ($env == 'prod') {
  $idp = 'http://adfs.sec.gov/adfs/services/trust';
}

// Default $entity_id to Exchange.
$entity_id = 'urn:drupal:adfs-saml-insider-'.$env;

// This file is available at
// https://docs.acquia.com/resource/simplesaml/sources/

$config = [
  // This is a authentication source which handles admin authentication.
  'admin' => [
    // The default is to use core:AdminPassword, but it can be replaced with
    // any authentication source.

    'core:AdminPassword',
  ],
  'default-sp' => [
    'saml:SP',
    // The entityID is the entityID of the SP that the IdP is expecting.
    // This value must be exactly what the IdP is expecting. If the
    // entityID is not set, it defaults to the URL of the SP's metadata.
    // Don't declare an entityID for Site Factory.
    'entityID' => $entity_id,

    // If the IdP requires the SP to hold a certificate, the location
    // of the self-signed certificate.
    // If you need to generate a SHA256 cert, see
    // https://gist.github.com/guitarte/5745b94c6883eaddabfea68887ba6ee6
    'certificate' => $server_cert,
    'privatekey' => $private_key,
    'redirect.sign' => TRUE,
    'redirect.validate' => TRUE,

    // The entityID of the IdP.
    // This is included in the metadata from the IdP.
    'idp' => $idp,

    // NameIDFormat is included in the metadata from the IdP
    'NameIDFormat' => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',

    // If the IdP does not pass any attributes, but provides a NameID in
    // the authentication response, we can filter and add the value as an
    // attribute.
    // See https://simplesamlphp.org/docs/stable/saml:nameidattribute
    // 'authproc' => [
    //   20 => [
    //     'class' => 'saml:NameIDAttribute',
    //     'format' => '%V',
    //   ],
    // ],
    // The RelayState parameter needs to be set if SSL is terminated
    // upstream. If you see the SAML response come back with
    // https://example.com:80/saml_login, you likely need to set this.
    // See https://github.com/simplesamlphp/simplesamlphp/issues/420
    'RelayState' => 'https://' . $_SERVER['HTTP_HOST'] . '/saml_login',

    // If working with ADFS, Microsoft may soon only allow SHA256 certs.
    // You must specify signature.algorithm as SHA256.
    // Defaults to SHA1 (http://www.w3.org/2000/09/xmldsig#rsa-sha1)
    // See https://docs.microsoft.com/en-us/security/trusted-root/program-requirements

    // 'signature.algorithm'  => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256',
  ],
];
